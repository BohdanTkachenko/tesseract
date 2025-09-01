
# TODO

## Known Issues

Everything from `KNOWN_ISSUES.md`

## Ansible

### Kernel args

I made the following changes to kernel args that allow me to use my NVIDIA card and pass it through to `gpu` VM. I need to move this to Ansible.

```
rd.driver.blacklist=nouveau modprobe.blacklist=nouveau intel_iommu=on iommu=pt rd.driver.pre=vfio_pci vfio-pci.ids=10de:1c82,10de:0fb9
```

### Boot notification

I manually set up ntfy to send a push to my phone when Tesseract boots. I need to move this to a proper Ansible config.

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

## Backups and snapshots

I have BTRFS and I want to make sure that all data is snapshotted on a regular basis

Also I need to have regular backups. All snapshots from SSDs must be backed up to HDDs. Also all SSD data and **some** HDD data need to be backed up to GCloud on a regular basis.

# OpenTofu/Terragrunt

## Custom FCOS image for VMs

Currently I use a base image and then layer a bunch of packages on top of it. This makes VM provision slow (2-3 minutes). Ideally I need a custom base image with these packages already pre-layered. It also needs to be in sync with the official FCOS image and get all latest updates. Further read:

- https://coreos.github.io/coreos-assembler/working/
- https://github.com/GuiltyDoggy/ostree-container
