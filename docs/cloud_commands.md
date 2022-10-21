# Cloud Commands

Most people uses some flavour of Cloud hosted K8s clusters. This section is about the main K8s Cloud Providers.

## Gcloud

With Google, everything goes throu the `gcloud` command.

### Install

=== "Apple Mac OSX"
    ```bash
    brew install --cask google-cloud-sdk
    ```

=== "Linux"
    Refer to [the official doc](https://cloud.google.com/sdk/docs/install?hl=fr#linux).

    ```bash
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-405.0.1-linux-x86_64.tar.gz
    tar -xf google-cloud-cli-405.0.1-linux-x86.tar.gz
    ./google-cloud-sdk/install.sh
    ```

=== "Windows"
    TODO

### Setup

Once the `gcloud` command is installed, we have to init and configure it:

```bash
# Install kubectl if you don't already have it
# gcloud components install kubectl # Optional

gcloud init
gcloud auth login

gcloud config set compute/region us-east1

gcloud config list
```
```bash title="output"
[compute]
region = us-central1
zone = us-central1-a
[core]
account = prune@not-your-business.zap
disable_usage_reporting = False
project = my-dev-project
```

List clusters:

```bash
gcloud container clusters  list
```
```bash title="output"
NAME                         LOCATION       MASTER_VERSION    MASTER_IP       MACHINE_TYPE   NODE_VERSION       NUM_NODES  STATUS
my-dev-us-central-cluster    us-central1-a  1.24.3-gke.2100   34.70.94.2      e2-standard-2  1.23.8-gke.1900 *  136        RUNNING
```

Add your `GKE` clusters to your `kubectl` context (you can always find this command in the `Connect` tab in the Gcloud Web Console):

```bash
gcloud container clusters get-credentials <cluster> --project <project>
```

!!! note

    It is not necessary to add the `--project <project>` section if only one project is used and is the default. 
### Completion

Add those lines to enable completion:

=== "Apple Mac OSX ZSH"
    ```bash linenums="1" title="~/.zshrc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    ```

=== "Apple Mac OSX BASH"
    ```bash linenums="1" title="~/.bashrc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
    ```

=== "Linux ZSH"
    ```bash linenums="1" title="~/.zshrc"
    # path may vary depending on where you installed gcloud command
    $HOME/kubernetes/google-cloud-sdk/path.zsh.inc
    $HOME/kubernetes/google-cloud-sdk/completion.zsh.inc
    ```

=== "Linux BASH"
    ```bash linenums="1" title="~/.bashrc"
    # path may vary depending on where you installed gcloud command
    $HOME/kubernetes/google-cloud-sdk/path.bash.inc
    $HOME/kubernetes/google-cloud-sdk/completion.bash.inc
    ```

## AWS CLI

### Install

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

### Setup

Setup SSO ans default AWS profile. This is not mandatory but is a great helper if you're using SSO:

```bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
aws configure sso
aws sso login --profile profile_xxxxxx
export AWS_PROFILE=profile_xxxxxx
```

Add your `EKS` clusters to your `kubectl` context:

```bash
aws eks update-kubeconfig \ 
    --region us-east-1    \
    --name <cluster_name> \
    --alias <friendly_name>

```

### Completions

Add those lines to your shell startup script:

=== "ZSH"
    ```bash linenums="1" title="~/.zshrc"
    export AWS_DEFAULT_REGION=us-east-1 # update to your preference
    export AWS_PAGER="" # prevent aws cli to auto-page = display inline
    export BROWSER=echo # Do not open a browser, let you choose which browser to open
    # AWS CLI completions
    complete -C '/usr/local/bin/aws_completer' aws
    ```

=== "BASH"
    ```bash linenums="1" title="~/.bashrc"
    export AWS_DEFAULT_REGION=us-east-1 # update to your preference
    export AWS_PAGER="" # prevent aws cli to auto-page = display inline
    export BROWSER=echo # Do not open a browser, let you choose which browser to open
    # AWS CLI completions
    complete -C '/usr/local/bin/aws_completer' aws
    ```

### Azure

    TODO

## Next

Tired of typing ? [Let's use a UI](interfaces/k9s.md) !