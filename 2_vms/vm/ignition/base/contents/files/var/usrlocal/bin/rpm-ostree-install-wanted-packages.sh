#!/usr/bin/env bash
set -eu

packages=$(find /etc/rpm/packages.wants -maxdepth 1 -type f | cut -d '/' -f 5 | tr '\n' ' ')
if [ -n "$packages" ]; then
    echo "Attempting to install packages: $packages"
    /usr/bin/rpm-ostree refresh-md
    /usr/bin/rpm-ostree install --assumeyes --allow-inactive $packages
else
    echo "No packages found in /etc/rpm/packages.wants to install."
fi