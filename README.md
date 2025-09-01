# Tesseract

## Prerequisites

### Google Cloud Authentication

Before you can use Terragrunt to manage your infrastructure, you need to authenticate with Google Cloud. You can do this by running the following command:

```bash
gcloud auth application-default login
```

This will open a browser window and ask you to log in to your Google account. Once you have successfully logged in, your credentials will be stored locally and will be used by Terragrunt to access your Google Cloud resources.

## Installation

To install everything:

```bash
$ make install
```
