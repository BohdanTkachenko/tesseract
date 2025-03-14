.ONESHELL:

DIRS := 10_metal

ifeq (,$(shell which terraform))
  $(error Terraform is not installed. Please install it.)
endif

define terraform_cmd
	@if [ ! -d "$1" ]; then \
		echo "Error: Directory '$1' does not exist." >&2; \
		exit 1; \
	fi
	cd "$1" && terraform $2
endef

$(foreach dir,$(DIRS),$(eval apply-$(dir):; $(call terraform_cmd,$(dir),apply)))
$(foreach dir,$(DIRS),$(eval destroy-$(dir):; $(call terraform_cmd,$(dir),destroy)))

apply: $(addprefix apply-,$(DIRS))
destroy: $(addprefix destroy-,$(DIRS))

.PHONY: apply destroy $(addprefix apply-,$(DIRS)) $(addprefix destroy-,$(DIRS))