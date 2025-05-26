#!/bin/env bash
set -xeu -o pipefail

source "${SCRIPT_DIR:-$(dirname "$0")}/_common.sh"

existing_uncompressed_path=""
if [ -f "${UNCOMPRESSED_LOCAL_PATH}" ]; then
    existing_uncompressed_path="${UNCOMPRESSED_LOCAL_PATH}"
    verify_sha256 "${UNCOMPRESSED_SHA256_SUM}" "${UNCOMPRESSED_LOCAL_PATH}"
fi

cat << EOF
{
    "path": "${existing_uncompressed_path}"
}
EOF
