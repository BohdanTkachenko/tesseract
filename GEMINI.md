# Tesseract

Tesseract is the name of my homelab server. I use it to self-host my file server, Plex, photos, etc.

Note: this doc has some TODOs in it. This is to provide a better context about future updates.

## Hardware

Tesseract is enclosed in Fractal Design Node 304 Mini ITX Cube Compact Computer Case. It is connected directly with a cable to my U6 Enterprise IW via 2.5G interface. I also have JetKVM connected to Tesseract, so I can access my server if network configuration breaks or if the server cannot boot. It is also plugged in through a smart outlet controlled by Home Assistant, so I can control Tesseract's power remotely.

It has the following hardware components:
- ASRock Z790M-ITX WiFi
- Intel Core i5-13600T
- 2 x TEAMGROUP T-Force Vulcan DDR5 32GB 5200MHz
- GeForce GTX 1050 Ti
- 2 x WD Red SN700 4 TB SSD
- 2 x Seagate IronWolf Pro 20 TB Enterprise NAS Internal HDD
- 2 x Western Digital Red WD40EFRX-68N32N0 NAS Internal HDD
- PSU with enough wattage to power everything (I forgot the exact specs)

## Home Network

My provider is Verizon Fios with 1Gbps speeds. I am physically located in Weehawken, NJ. I have an optical cable come to my house, where I have a standard Verizon fiber-to-Ethernet media converter. It is connected to my own UCG Max. Then I have USW Enterprise 8 PoE in the same area connected directly to UCG Max. It powers other Unifi devices with PoE. I also have 3 U6 Enterprise IW access point on each floor that serve Wi-Fi. I also have USW Flex Mini in my Living Room used by my TV and Home Assistant Yellow. I also have USW Flex 2.5G 5 in my Office Room and my worstation and laptop (when docked) use a wired connection.

I have 3 Wi-Fi networks:

- Barlig - used by most clients
- Barlig-IoT - used by different IoT devices.
- Barlig-Legacy - same as Barlig, but with some features turned off for compatibility with other devices.

TODO: Isolate Barlig-IoT so IoT devices do not have access to the rest of the network.

Currently I have 2 VLANS:

- Default: my main home network is `10.0.0.0/24` with gateway at `10.0.0.1`
- Tesseract: specific for my homelab and all its virtual IPs: `10.42.0.0/16` with gateway at `10.0.0.254`.

I have a dynamic external IP on paper, but in reality it rarely changes, usually due to a power loss (once per 3 months on average).

I also have a WireGuard VPN server running on Unifi, so I can access my home network from anywhere.

Also I have setup the following port forwarding (all of them point to Tesseract IPs):
- WAN TCP `:22` -> `10.42.0.1:22`
- WAN TCP/UDP `:80` -> `10.42.0.80:80`
- WAN TCP/UDP `:443` -> `10.42.0.80:443`
- WAN TCP `:32400` -> `10.42.0.32:32400`

## DNS

Externally `tesseract.sh` and `*.tesseract.sh` point to my dynamic DDNS via Cloudflare. Cloudflare also hides my real IP address. With the port forwarding that makes all requests to my domain outside of my network to get to Tesseract server.

Internally I override the whole `tesseract.sh` zone to point to Tesseract's own DNS server at `10.42.0.53` which itself sets a proper local IP addresses, so all local clients just go to Tesseract directly, bypassing Cloudflare.

## Host

Tesseract has both SSDs and HDDs, where the system itself is stored on SSDs. Both SSDs use a BTRFS RAID 1, so they are mirrored for a better redurancy. HDDs are also on BTRFS RAID 0 for more storage space. Both SSDs and HDDs are encrypted with LUKS. SSDs are encrypted with a passphrase, but unlock automatically with TPM 2. HDD unlock keys are stored on SSDs, so it cannot be unlocked without unlocking SSDs first. HDD is mounted at `/var/mnt/hdd`.

Tesseract is running Fedora IoT which allows more stable and secure environment. Base OS filesystem is immutable and all system changes are managed by `rpm-ostree`.

Tesseract also running K8s control plane. Control plane may host a few system K8s apps, they all are located in `k8s/system` dir.

Tesseract is using libvirt to host VMs. Inside VMs also run Kubernetes that are connected to the control plane. Running Kubernetes in VMs allow better security and isolation. Malicious pod is less likely to do a serious harm. Files are shared with VMs using virtiofs. All "fast" volumes (SSD) are stored in `/var/lib/volumes` while all "slow" volumes (HDD) are stored in `/var/mnt/hdd/volumes`. All VM configuration is located in `vms/` dir.

One of VMs (called "gpu") also have direct access to my video card, so pods on that node can use GPU hardware acceleration for video streaming (for example Plex) or can use GPU for other tasks (like running AI model).

TODO: Upgrade to Intel Arc Pro B50 and explore the possibility to share GPU across nodes.

Base system configuration is managed by ansible and located in `metal/` directory.

Among other things Ansible sets up access to K8s cluster and to libvirt using certificates on a local machine. So I should expect to have both `kubectl` and `virsh working on my local machine and provide access to Tesseract.

## Running

To validate changes it is crucial to run them. It might be dangerous sometimes because some updates might be destructive.

### Ansible

Changes to the host should be made with Ansible. There are two main playbooks:

- `metal/site.yaml` - sets up whole host node and sets up keys for local system to access the host
- `metal/destroy.yaml` - remove all changes made by site.yaml. Should not usually be called.

To run Ansible use:

```sh
make ansible
```

If no changes were made to OSTree I can skip OSTree commands for faster run:

```sh

make ansible ANSIBLE_SKIP_TAGS=ostree 
```

TODO: configure tags in a way that I can only run commands to setup local keys.

### OpenTofu/Terragrunt

Everything else is managed by OpenTofu/Terragrunt. You can simply run the following command to run Terragrunt in non-interactive mode:

```sh
make terragrunt
```

This make rule accepts `DIR` argument which allows to only apply changes to a specific sub-directory. This is preferred when working on a specific sub-directory to speedup the process. Example:

```sh
make terragrunt DIR=k8s/apps/media
```

When extra debug information is needed, `TF_LOG` argument may be provided. For example:

```sh
make terragrunt DIR=k8s/apps/media TF_LOG=TRACE
```

You can also execute commands directly without Makefile when needed. Note that there is a known issue that requires a patched `dmacvicar/libvirt` provider. Makefile already handles that but for any custom command that involves `vms` directory it needs `TF_CLI_CONFIG_FILE` env variable. See `KNOWN_ISSUES.md` for details.

#### Secrets

Terragrunt uses SOPS to store secrets. SOPS config is in .sops.yaml. Encrypted secrets are in secrets.yaml. Unencrypted secrets are in `secrets-unencrypted.yaml`. Note that secrets are rarely updated and `secrets-unencrypted.yaml` is not in Git, so it is expected it might not be present in every system.

There are two Makefile rules in place for convinience of managing secrets:
- `make secrets.yaml` will encrypt secrets. To be used when secrets were changed and need to be updated.
- `make secrets-unencrypted.yaml` will decrypt secrets. To be used to have a copy of decrypted secrets in a local environment. This should be done before adding new secrets to make sure all old secrets are also available (if they are still in use).

## Debugging

For debugging of K8s I can use `kubectl`. Example to check K8s is working:

```sh
kubectl version
```

For debugging of libvirt I can use `virsh`. Example to check libvirt is working:

```sh
virsh -c 'qemu+tls://10.42.0.1/system' version
```

I can also use SSH to access Tesseract directly.

## SELinux and VirtioFS for K8s Pods

An important architectural point is how SELinux contexts are handled when sharing directories from the host into Kubernetes pods running within VMs.

- **The Challenge**: K8s pods (running with the `container_t` SELinux context) need to access storage shared from the host via `virtiofs`. The Fedora CoreOS kernel inside the VM automatically labels the contents of any `virtiofs` mount with the `virtiofs_t` context. The default SELinux policy on the VM does not allow a `container_t` process to write to a `virtiofs_t` directory, leading to "Permission denied" errors.

- **The Solution**: We use the VM's Ignition configuration to install a custom SELinux policy module on first boot. This module adds a specific rule that allows processes with the `container_t` context to have full read/write/create/delete access to files and directories labeled with the `virtiofs_t` context. This is handled in `vms/vm/ignition/base/selinux.tf`. This process requires the `selinux-policy-devel` package, which is also installed via Ignition.

## Additional instructions

When encountering new important information that might be useful in subsequent re-runs please add it to GEMINI.md

## TODO

There is a list of things I want to improve in `TODO.md`. Also some TODO statements are spread across in the codebase. When asked about TODO list make sure to find all `TODO:` comments in the codebase.