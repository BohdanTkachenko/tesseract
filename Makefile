DIR ?= .
ANSIBLE_SKIP_TAGS =
TF_LOG ?= ERROR

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

install: ansible terragrunt

ansible:
	ansible-playbook -i metal/inventory/production --skip-tags="$(ANSIBLE_SKIP_TAGS)" metal/site.yaml

terragrunt-init:
	TF_LOG="$(TF_LOG)" TF_CLI_CONFIG_FILE="$(mkfile_dir)metal/roles/local_libvirt_workaround/.terraformrc" terragrunt --working-dir="$(DIR)" init -all -non-interactive

terragrunt:
	TF_LOG="$(TF_LOG)" TF_CLI_CONFIG_FILE="$(mkfile_dir)metal/roles/local_libvirt_workaround/.terraformrc" terragrunt --working-dir="$(DIR)" apply -all -non-interactive -auto-approve

secrets-unencrypted.yaml: secrets.yaml
	sops --output secrets-unencrypted.yaml --decrypt secrets.yaml

secrets.yaml: secrets-unencrypted.yaml
	sops --output secrets.yaml --encrypt secrets-unencrypted.yaml

destroy: destroy-terragrunt destroy-ansible

destroy-ansible:
	ansible-playbook -i metal/inventory/production metal/destroy.yaml

destroy-terragrunt:
	TF_LOG="$(TF_LOG)" TF_CLI_CONFIG_FILE="$(mkfile_dir)metal/roles/local_libvirt_workaround/.terraformrc" terragrunt --working-dir="$(DIR)" destroy -all -non-interactive -auto-approve

clean:
	rm secrets-unencrypted.yaml

.PHONY: install ansible terragrunt destroy destroy-ansible destroy-terragrunt clean
