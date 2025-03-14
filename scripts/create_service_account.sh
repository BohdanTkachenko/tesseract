#!/usr/bin/env bash
set -xeu -o pipefail

# SERVICE_ACCOUNT_PUB_KEY=""
SERVICE_ACCOUNT_NAME=terraform
SERVICE_ACCOUNT_HOME="/var/lib/${SERVICE_ACCOUNT_NAME}"
SERVICE_ACCOUNT_SSH_DIR="${SERVICE_ACCOUNT_HOME}/.ssh"
SERVICE_ACCOUNT_SSH_AUTH_KEYS="${SERVICE_ACCOUNT_SSH_DIR}/authorized_keys"
SERVICE_ACCOUNT_EXTRA_GROUPS=("libvirt")

for i in ${!SERVICE_ACCOUNT_EXTRA_GROUPS[@]}; do
    if ! grep -q "^${SERVICE_ACCOUNT_EXTRA_GROUPS[$i]}:" /etc/group; then
        grep -E "^${SERVICE_ACCOUNT_EXTRA_GROUPS[$i]}:" /usr/lib/group | sudo tee -a /etc/group
    fi
done

sudo useradd -u 9999 -m -d "${SERVICE_ACCOUNT_HOME}" -G "${SERVICE_ACCOUNT_EXTRA_GROUPS}" "${SERVICE_ACCOUNT_NAME}"
sudo mkdir -p "${SERVICE_ACCOUNT_SSH_DIR}"
sudo chmod 700 "${SERVICE_ACCOUNT_SSH_DIR}"
echo "${SERVICE_ACCOUNT_PUB_KEY}" | sudo tee -a "${SERVICE_ACCOUNT_SSH_AUTH_KEYS}"
sudo chown -R "${SERVICE_ACCOUNT_NAME}:${SERVICE_ACCOUNT_NAME}" "${SERVICE_ACCOUNT_SSH_DIR}"
sudo chmod 600 "${SERVICE_ACCOUNT_SSH_AUTH_KEYS}"
echo "%terraform ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/terraform
