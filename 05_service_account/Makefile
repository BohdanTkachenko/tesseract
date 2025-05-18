KEY_FILE := $(HOME)/.ssh/terraform
PUB_KEY_FILE := $(KEY_FILE).pub
SCRIPT_TEMPLATE := create_service_account.sh
OUTPUT_SCRIPT := create_service_account_with_pub_key.sh

SHELL := /bin/bash

.ONESHELL:
.PHONY: all

all: $(OUTPUT_SCRIPT)

clean:
	rm $(OUTPUT_SCRIPT)

$(KEY_FILE):
	ssh-keygen -t ed25519 -f $(KEY_FILE) -N ""

$(OUTPUT_SCRIPT): $(KEY_FILE)
	export SERVICE_ACCOUNT_PUB_KEY=`cat $(PUB_KEY_FILE)`
	if [ -z "$$SERVICE_ACCOUNT_PUB_KEY" ]; then
		echo "Error: Cannot load public key from $(PUB_KEY_FILE)" >&2
		exit 1
	fi
	envsubst '$$SERVICE_ACCOUNT_PUB_KEY' < create_service_account.sh > "$@"
	chmod +x "$@"
