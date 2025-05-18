#!/bin/env bash
set -xeu -o pipefail

source "${SCRIPT_DIR:-$(dirname "$0")}/_common.sh"

if [ -f "${COMPRESSED_LOCAL_PATH}" ]; then
    curl -L -z "${COMPRESSED_LOCAL_PATH}" -o "${COMPRESSED_LOCAL_PATH}" "${REMOTE_URL}"
else
    curl -L -o "${COMPRESSED_LOCAL_PATH}" "${REMOTE_URL}"
fi

verify_sha256 "${COMPRESSED_SHA256_SUM}" "${COMPRESSED_LOCAL_PATH}"

if [ ! -f "${UNCOMPRESSED_LOCAL_PATH}" ]; then
    xz -dkc "${COMPRESSED_LOCAL_PATH}" > "${UNCOMPRESSED_LOCAL_PATH}"
fi

verify_sha256 "${UNCOMPRESSED_SHA256_SUM}" "${UNCOMPRESSED_LOCAL_PATH}"
