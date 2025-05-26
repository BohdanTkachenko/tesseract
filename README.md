# Tesseract

## Prerequisites

### Service Account

In order for Terraform to be able to access the main host by SSH, it needs a service account with passwordless sudo access. To make it secure, we will need to generate a password-protected SSH key.

## Installation

To install everything:

```bash
$ terragrunt apply --all
```
