# How to Import Existing Infrastructure into Terraform IaC

WIP (2022-06-23)

## Objective

As an IaC engineer, I'd like to be able to import existing Azure resources into my IaC and bring them under Terraform control.

These existing resources can be hand-crafted or deployed via other forms of IaC e.g. ARM templates.

Either way, the goal is to make Terraform the "place of truth" for these resources going forward.

----

## Background

For quite a while, Terraform hasn't had this capability natively, which some people consider to be a significant weakness of the product.

TODO: Check if this is still the case, as things may have changed in the latest release of Terraform (1.2.x)

So...  We need to look at a third party solution.

Here are some options from my research thus far.

----

## terraformer

Caveat: I haven't tried this one (yet!) but it seems to have a decent reputation.

<https://github.com/GoogleCloudPlatform/terraformer>

<https://mateuszdzierzcki.medium.com/how-to-export-existing-infrastructure-to-terraform-code-d8bd5bc43574>

### Install on Linux

<https://github.com/GoogleCloudPlatform/terraformer#installation>

### Further Reading

- <https://www.infrakloud.com/2020/08/import-existing-resources-as-terraform-using-terraformer/>
- <https://faun.pub/terraformer-5036241f90cc>

----

## Azure Terafy (aztfy)

<https://github.com/Azure/aztfy>

I've tried this one!  

I had a bunch of Network Security Groups to migrate from Azure Stack Hub to Azure Public Cloud.  

It did the job in terms of importing the resources into Terraform code but it imposed its own naming convention on the NSG resource blocks, which included (by design) multiple inline rule blocks.  

This meant that I was looking at having to rework the code - via regex or some another method - which would have consumed a significant amount of time, so I switched to a "Plan B".  For this reason, I can't recommend aztfy but I wouldn't rule out trying it again in the future to see if it's changed / handles other ARM scenarios better / both.

### Installation

Create a suitable working directory on local disk.

```bash
cd /mnt/c/Users/user_name/Downloads
mkdir aztfy
cd aztfy/
```

Install on WSL (Ubuntu-20.04)

```bash
# Download the latest release (at time of writing)
curl -O -L https://github.com/Azure/aztfy/releases/download/v0.3.0/aztfy_v0.3.0_linux_amd64.zip

# Unzip it!
unzip aztfy_v0.3.0_linux_amd64.zip

# Install it.
# What type of file is it?  It doesn't have an extension.
# If I run 'file aztfy', it returns.
# 'aztfy: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, Go BuildID=e6kBoY10pVAHbFlMotuR/aR2MkBO0CjFUa2OzwfTC/ft6L1NG2UrYttEp0_9M1/JHr2nOPcf1h_2kbyxPdY, stripped'
#
# Ah, OK...  It's a precompiled binary, so it can be run rather than installed.

# Test for NSG import.
./aztfy -o nsg-import-1952/ rg-test-1952
```

### Acknowledgments

- <https://stackoverflow.com/questions/48873243/curl-not-working-when-downloading-zip-file-from-github>
- <https://www.maketecheasier.com/can-i-install-amd64-ubuntu-on-my-intel-64-bit-machine/>
- <https://techcommunity.microsoft.com/t5/azure-tools-blog/announcing-azure-terrafy-and-azapi-terraform-provider-previews/ba-p/3270937>

----

## JSON to HCL

I also tried this, as I had access to ARM templates for the aforementioned (bunch of) Network Security Groups.

My memory's a bit hazy as to the outcome (sorry!) but I assume from my notes below that I couldn't get it to work.

It's another one to bear in mind for the future, though.

<https://github.com/kvz/json2hcl>

Convert ARM template (JSON) to Terraform (HCL)

```bash
# Create local working directory.
cd /mnt/c/Users/user_name/Downloads
mkdir json2hcl
cd json2hcl/

# It doesn't seem to work as a standalone executable - boo!
#curl -O -L https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64
#./json2hcl_v0.0.6_linux_amd64

# Try this command as per the README.
curl -SsL https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64 \
  | sudo tee /usr/local/bin/json2hcl > /dev/null && sudo chmod 755 /usr/local/bin/json2hcl && json2hcl -version
```
