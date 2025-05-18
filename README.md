# Tesseract

## Prerequisites

### Service Account

In order for Terraform to be able to access the main host by SSH, it needs a service account with passwordless sudo access. To make it secure, we will need to generate a password-protected SSH key.

Run `make -C 05_service_account` to generate a new SSH key in `~/.ssh/terraform` and generate a script `scripts/create_service_account_with_pub_key.sh` which we can use to setup a service account. Next, run the following command to exectute this script:

```bash
$ ssh my-server /bin/bash < scripts/create_service_account_with_pub_key.sh
```

NOTE: You will need a working SSH connection to your server via password or your own key.

## Installation

To install everything:

```bash
$ terragrunt apply --all
```
