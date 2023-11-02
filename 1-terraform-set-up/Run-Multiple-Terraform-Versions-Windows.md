# How to Run Multiple Versions of Terraform on a Windows Workstation

## Objective

As an IaC engineer, I'd like to be able to switch easily between Terraform versions on my local Windows 10 workstation as and when required e.g. when preparing for a version upgrade.

----

### Option One

### The tfenv Application

<https://github.com/tfutils/tfenv>

tfenv is a version manager for Terraform that has a good reputation amongst Linux users, but it's not currently (fully) supported on Windows at the time of writing.

To work around this, I'm going to make use of WSL under Windows 10.

### Install Windows Subsystem for Linux on Windows 10

To install Terraform directly within WSL and interact with it via Visual Studio Code, reference the article below.
  
<https://techcommunity.microsoft.com/t5/azure-developer-community-blog/configuring-terraform-on-windows-10-linux-sub-system/ba-p/393845>

NOTE: There's no need to follow this article 100%.  Just focus on the following steps.

- 1 - Install VS Code
- 2 - Install Windows Subsystem for Linux and update to WSL 2
  - <https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps>
- 2.1 - Update Ubuntu distro
- 3 - Install VS Code extension for Terraform
- 5 - Install Azure CLI on Ubuntu distro
  - <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt&view=azure-cli-latest>
- 6 - Login to Azure subscription via Azure CLI

### Install Windows Subsystem for Linux on Windows 11

Well, time and operating systems move on, so here's the link for how to install WSL on a Windows 11 system.

<https://learn.microsoft.com/en-us/windows/wsl/install>

Alas, the "one stop shop command" approach didn't work for me and I spent quite a bit of time troubleshooting (see below)

Here's my summary of the steps to take and my notes are inline.

- 1 - Install Visual Studio Code
- 2 - Start a PowerShell terminal
- 3 - Check which Ubuntu distros are available
  - `wsl --list --online`
- 4 - Install the required distro
  - I'm choosing Ubuntu 22.04 LTS
    - `wsl --install -d Ubuntu-22.04`
- 5 - Reboot the system

```plaintext
PS D:> wsl --install -d Ubuntu-22.04
Installing: Virtual Machine Platform
Virtual Machine Platform has been installed.
Installing: Windows Subsystem for Linux
Windows Subsystem for Linux has been installed.
Installing: Ubuntu 22.04 LTS
Ubuntu 22.04 LTS has been installed.
The requested operation is successful. Changes will not be effective until the system is rebooted.
```

- 6 - Resolve _WslRegisterDistribution failed with error: 0x80370109_
  - _Error: 0x80370109 The operation timed out because a response was not received from the virtual machine or container._
    - Tried many suggestions from various forum threads but this is the command that (eventually..!) got it working for me
      - `wsl --update --pre-release`
        - I also removed the original distro installed in step 4 (see above)
          - `wsl --unregister -d Ubuntu-22.04`
- 7 - Enable Virtual Machine Platform in Windows Features
  - This feature is required to support WSL 2
    - Restart the system after the feature's been installed (when prompted)
- 8 - Confirm WSL 2 is set as the default version
  - `wsl --status`
    - Should see, _Default Version: 2_
- 9 - Install the default distro which is called "Ubuntu" and, luckily for my use case, is 22.04 LTS
  - `wsl --install`
- 10 - Specify the username and pass word to use in the Ubuntu distro
  - They don't have to match up with your Windows credentials but makes life a bit easier if they do..!
- 11 - Confirm your distro is up-and-running
  - `wsl --list -v`

```plaintext
PS E:\> wsl --list -v
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

- 12 - Update your Ubuntu distro with the latest available updates
  - `sudo apt update`
  - `sudo apt upgrade`
- 13 - Install the "WSL" extension in Visual Studio Code
- 14 - Install the "HashiCorp Terraform" extension in Visual Studio Code
- 15 - Install Azure CLI on Ubuntu distro
  - <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt&view=azure-cli-latest>
    - I chose the "step-by-step installation" approach
- 16 - Login to Azure subscription via Azure CLI

----

### Troubleshooting the WSL Installation on Windows 10

#### Not Able to Connect to Microsoft Store

The WSL installation may impact on your ability to run Microsoft Store i.e. it may not allow you to sign-in and will grumble about, "you don't seem to be connected to the Internet".  

You may (also) see a "no Internet access" icon in the systray.  This is a false positive.

To resolve this issue, follow the steps below.

```plaintext
Enable active probing by setting the following registry key.

  [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet]
 
  "EnableActiveProbing" = dword:00000001 

  Restart the nlasvc (Network Location Awareness) service.

  NOTE: If this service doesn't cooperate, restart your workstation.
```

#### Unable to Get Ubuntu VM to Run Under WSL 2

You may encounter the following error message.

```plaintext
Installing, this may take a few minutes...
WslRegisterDistribution failed with error: 0x80370102
Error: 0x80370102
The virtual machine could not be started because a required feature is not installed.  
Press any key to continue...
```

This appears to result from a known issue which has no verified fix at present.  

- See <https://github.com/microsoft/WSL/issues/4120> for more details

The current workaround is to set WSL 1 as your default e.g. by running this PowerShell command.

```powershell
wsl --set-default-version 1
```

----

### Install tfenv on the Linux VM

To install tfenv on Ubuntu - this is the Linux distro I've decided to use within WSL - reference the following article.

<https://opensource.com/article/20/11/tfenv>

I've double-checked these installation instructions by cross-referencing them with another helpful article at <https://jhooq.com/install-terrafrom/> (sic)

Here's a summary for easier reference.

- Clone tfenv repo
  - `git clone https://github.com/tfutils/tfenv.git ~/.tfenv`
- Add ~/.tfenv/bin to your $PATH
  - `echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile`
- Create symlink for ~/.tfenv/bin/*
  - `mkdir -p ~/.local/bin/`
  - `. ~/.profile`
  - `ln -s ~/.tfenv/bin/* ~/.local/bin`
  - `which tfenv`
- Verify installation
  - `tfenv` (returns version number plus available commands)
    - Or `tfenv -v` (returns just version number)

```plaintext
UPDATE: 

These instructions are valid for installing tfenv on Ubuntu 22.04 LTS running in WSL on Windows 11 (tested 2023-11-02)
``````

----

### Troubleshooting the tfenv Installation

#### Unzip Command Not Found

My first attempt at `tfenv install 0.13.5` generated an error as follows.

```shell
/home/sking/.tfenv/libexec/tfenv-install: line 260: unzip: command not found
Tarball unzip failed
```

This was resolved by installing the 'unzip' command (makes sense!)

```shell
sudo apt install unzip
```

----

### Use tfenv on the Linux VM

The following operations will (tend to be) the most frequently used.

- List available versions for Terraform
  - `tfenv list -remote`
- Install a specific version of Terraform
  - `tfenv install 0.13.5`
- List your local versions of Terraform
  - `tfenv list`
- Run tfenv with your desired version
  - `tfenv use 0.13.5`

----

### Troubleshooting Use of tfenv on Linux VM

#### All Files in the Git Repository Show As Modified

Running `git status` on the Linux VM shows that all files in the repository have been modified and will need to be committed.

Uh oh!

```shell
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   .gitignore
        modified:   .pre-commit-config.yaml
        modified:   README.md
        [here follows a list of every file in the repo!]
        .
        .
        .
no changes added to commit (use "git add" and/or "git commit -a")        
```

This is a false positive (phew!)

Why is this happening?

_If you are working with the same repository folder between Windows, WSL, or a container, be sure to set up consistent line endings._

_Since Windows and Linux use different default line endings, Git may report a large number of modified files that have no differences aside from their line endings._

- Source: <https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-line-endings>
- Further details: <https://stackoverflow.com/questions/53900839/git-repo-gives-contradictory-info-from-wsl-than-from-standard-windows>

To resolve this issue, create a `.gitattributes` file at the root of your Git repository as described in the following articles.

- <https://code.visualstudio.com/docs/remote/troubleshooting#_resolving-git-line-ending-issues-in-containers-resulting-in-many-modified-files>
- <https://rehansaeed.com/gitattributes-best-practices/#gitattributes>

#### Unable to Access the Remote Git Repository

The first attempt at a remote operation e.g. `git pull origin master` fails with a prompt for credentials (password)

```plaintext
fatal: Cannot determine the organization name for this 'dev.azure.com' remote URL. Ensure the `credential.useHttpPath` configuration value is set, or 
set the organization name as the user in the remote URL '{org}@dev.azure.com'.
Password for 'https://organisation_name@dev.azure.com':
```

NOTE: My Windows (AD) account password was _not_ accepted at this point.

Run the following command to use Git Credential Manager to authenticate to the remote Git server as per <https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup>.

```shell
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
```

This didn't fix it, alas, so this issue seems to be more about the remote URL than the password.

To resolve this issue, locate the `.gitconfig` file that controls the Git installation on your Linux VM.  

Mine is in my home directory (`cd ~`)

Edit this file so it includes the following setting.

`credential.useHttpPath = true`

- Source: <https://github.com/microsoft/vscode/issues/121420>
- Further details: <https://github.com/microsoft/Git-Credential-Manager-Core/blob/main/docs/configuration.md#credentialusehttppath>

Just to clarify, the .gitconfig file should look (something!) like this.

```plaintext
[user]
        name = Your_Name
        email = your_email_address
[credential]
        helper = /mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe
        useHttpPath = true
```

----

### Option Two

### Run Terraform in Docker Containers

Another option could be to run (each version of) Terraform in a (separate) Docker container.

The interaction with Visual Studio Code should be straightforward, but it will presumably need to establish access from the container to local directories and ARM subscriptions.

<https://morethancertified.com/terraform-in-docker/>

It could be interesting to try this approach, but my gut feel is that it will be less straight forward than interacting with a Linux VM under WSL for standard day-to-day workflow.

Watch this space!

----
