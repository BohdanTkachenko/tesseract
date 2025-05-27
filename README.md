# Tesseract

## Prerequisites

### Service Account

In order for Terraform to be able to access the main host by SSH, it needs a service account with passwordless sudo access. To make it secure, we will need to generate a password-protected SSH key.

## Installation

To install everything:

```bash
$ terragrunt apply --all
```

## TODO

### Custom FCOS image

https://coreos.github.io/coreos-assembler/working/
https://github.com/GuiltyDoggy/ostree-container

### Metal configuration

#### Kernel args

```
rd.driver.blacklist=nouveau modprobe.blacklist=nouveau intel_iommu=on iommu=pt rd.driver.pre=vfio_pci vfio-pci.ids=10de:1c82,10de:0fb9
```

#### Layered packages

```
bind-utils
btrfs-progs
cockpit
cockpit-files
cockpit-machines
cockpit-networkmanager
cockpit-podman
cockpit-selinux
cockpit-storaged
cri-o1.32
fish
guestfs-tools
iperf3
ipvsadm
kubernetes1.32
libvirt-daemon-config-network
libvirt-daemon-kvm
libvirt-nss
python3-libguestfs
qemu-kvm
rsync
samba
tcpdump
tree
unzip
vim
virt-install
virt-manager
virt-top
virt-viewer
```

#### Boot notification

```
$ cat /etc/systemd/system/boot-notify.service
[Unit]
Description=Notify about successful system boot
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/boot-notify.sh

[Install]
WantedBy=multi-user.target 

$ cat /usr/local/bin/boot-notify.sh
#!/usr/bin/bash

ntfy publish \
	--priority urgent \
	--tags warning \
	--title Tesseract \
	tesseract \
	"System boot successful."
```