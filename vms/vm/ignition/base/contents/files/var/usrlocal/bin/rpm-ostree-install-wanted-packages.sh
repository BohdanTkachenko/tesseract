#!/usr/bin/env bash
set -eu

packages=$(find /etc/rpm/packages.wants -maxdepth 1 -type f -print0 | xargs -0 sh -c 'for f in "$@"; do cat "$f"; echo ""; done' _ | sort -u | tr '\n' ' ')
if [ -n "$packages" ]; then
    echo "Attempting to install packages: $packages"
    /usr/bin/rpm-ostree refresh-md
    /usr/bin/rpm-ostree install --assumeyes --allow-inactive $packages
else
    echo "No packages found in /etc/rpm/packages.wants to install."
fi