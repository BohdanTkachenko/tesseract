#!/usr/bin/env bash
set -xeu -o pipefail

LOCK_FILE="$1"; shift
SSH_HOST="$1"; shift
SSH_PORT="$1"; shift
SSH_USERNAME="$1"; shift
SSH_IDENTITY_PATH="$1"; shift
SCRIPT="$1"; shift

echo "${SCRIPT}" | ssh "${SSH_USERNAME}@${SSH_HOST}" -p "${SSH_PORT}" -i "${SSH_IDENTITY_PATH}" bash -e
touch "${LOCK_FILE}"