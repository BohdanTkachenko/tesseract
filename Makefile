.PHONY: all scripts install upgrade uninstall tf-apply tf-upgrade tf-destroy

all: scripts

scripts:
	make -C scripts

install: tf-apply
uninstall: tf-destroy

tf-apply:
	make -C terraform apply

tf-upgrade:
	make -C terraform upgrade

tf-destroy:
	make -C terraform destroy
