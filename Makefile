.PHONY: all scripts install uninstall

all: scripts

scripts:
	make -C scripts

install:
	make -C terraform apply

uninstall:
	make -C terraform destroy