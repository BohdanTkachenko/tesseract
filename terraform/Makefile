DIRS := 10_metal 30_vms 45_k8s_crds 50_k8s
SECRETS := $(realpath ../secret.tfvars)

ifeq (,$(shell which terraform))
	$(error Terraform is not installed. Please install it.)
endif

define terraform_cmd
	terraform -chdir="$1" "$2" -var-file="$(SECRETS)"
endef

$(foreach dir,$(DIRS),$(eval apply-$(dir):; terraform -chdir="$(dir)" apply -var-file="$(SECRETS)"))
$(foreach dir,$(DIRS),$(eval upgrade-$(dir):; terraform -chdir="$(dir)" init --upgrade))
$(foreach dir,$(DIRS),$(eval destroy-$(dir):; terraform -chdir="$(dir)" destroy -var-file="$(SECRETS)"))

apply: $(addprefix apply-,$(DIRS))
upgrade: $(addprefix upgrade-,$(DIRS))
destroy: $(addprefix destroy-,$(lastword $(subst  , ,$(DIRS)))) $(addprefix destroy-,$(filter-out $(lastword $(subst  , ,$(DIRS))),$(DIRS)))

.PHONY: apply destroy $(addprefix apply-,$(DIRS)) $(addprefix destroy-,$(DIRS))