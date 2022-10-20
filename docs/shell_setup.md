# Shell Setup

As of now, `kubectl` is installed and can reach two working local clusters. Still, we are required to type the `kubectl` command (7 letters) quite often. Too often.

We also have no knowledge of *which cluster am I connected to ?* or *what is my default namespace ?*.

Let's now configure the `shell` to solve all of those problems.

## I'm typing too much `kubectl` commands 

First trick is to use `k` as an alias to `kubectl`.

This is 6 less caracteres to type for every command !

=== "zsh"
    ```bash linenums="1" title="~/.zshrc"
    alias k=kubectl
    ```

=== "bash"
    ```bash linenums="1" title="~/.bashrc"
    alias k=kubectl
    ```

Open a new Shell and start using `k` command:

```bash
k get namespaces
k get pods -A
k get services -A
```

### Bonus

Most Kubernetes resources have a short-name. You can save few keystrokes here again. 

Resources are also defined as `plural` by default (with an `s` at the end, like `services`), 
but using the `singular` works the same ! It's one less keystroke again:

```bash
k api-resources
```
```bash
NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
pods                              po           v1                                     true         Pod
deployments                       deploy       apps/v1                                true         Deployment
ingresses                         ing          networking.k8s.io/v1                   true         Ingress
services                          svc          v1                                     true         Service
namespaces                        ns           v1                                     false        Namespace
...
```

Let's try it:

```bash
k get ns
k get po -A
k get svc -A
```

## `kubectl` arguments are too long

`kubectl port-forward` is one example of a long argument. So is `kubectl get deployment --context=my-cluster`. 

`completion` is the term used in UNIX™ shells when it comes to empowering the shell with better knowledge of the commands we use.

With Completion setup, you can type `kubectl <tab>` or `k <tab>` to get help. `k po<tab>` will get completed to `k port-forward`

Let's add those commands to the shell config file. A restart of the shell is needed for it to take effect:

=== "zsh"
    ```bash linenums="1" title="~/.zshrc"
    autoload -Uz compinit
    compinit
    source <(kubectl completion zsh)
    ```

=== "bash"
    ```bash linenums="1" title="~/.bashrc"
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
    ```


`bash` requires the use of the `complete` command to make `k` also use completion.

Let's try it, type `k <tab>` then `k port<tab>` then `k get po -n <tab>`:

```bash
k <tab>
alpha          -- Commands for features in alpha
annotate       -- Update the annotations on a resource
api-resources  -- Print the supported API resources on the server
api-versions   -- Print the supported API versions on the server, in the form of "group/version"
apply          -- Apply a configuration to a resource by file name or stdin
attach         -- Attach to a running container
auth           -- Inspect authorization
autoscale      -- Auto-scale a deployment, replica set, stateful set, or replication controller
certificate    -- Modify certificate resources.
cluster-info   -- Display cluster information
...

k port<tab>
k port-forward

k get po -n <tab>
default             kube-node-lease     kube-public         kube-system         local-path-storage
```

## My `kubectl` commands are failing

Some OS, including MacOsX, comes with a really low value for the number of concurrent Open File Descriptors.

This low limit may break some `kubectl` commands or some other tools using the Kubernetes Go client like `helm`. 

To solve that, increase your File Descriptors to at lease 2048:

=== "zsh"
    ```bash linenums="1" title="~/.zshrc"
    ulimit -n 2048          # kubectl opens one cnx (file) per resource
    ```

=== "bash"
    ```bash linenums="1" title="~/.bashrc"
    ulimit -n 2048          # kubectl opens one cnx (file) per resource
    ```

## ZSH shell

Mac OSX default shell is now `zsh` so we'll focus on ZSH now on. ZSH is also widely available in Linux and may somtimes be the default too.

!!! note "ZSH deprecation warning"
    To get rid of the deprecation warning in OSX, export this variable in your shell. Add it to your `.zshrc` file for persistance:

    ```bash linenums="1" title="~/.zshrc"
    export BASH_SILENCE_DEPRECATION_WARNING=1
    ```

### Oh My ZSH !

A lot of tools exist to configure and enhence any Shell to make it more productive, add colors, change the prompt.

Oh My ZSH! is a delightful, open source, community-driven framework for managing your Zsh configuration. It comes bundled with thousands of helpful functions, helpers, plugins, themes, and a few things that make you shout... `"Oh My ZSH!"`

There is so much in Oh My ZSH! that nobody use it all. But even if using only 10% of it, that is already a giant benefit for productivity.
As everything comes bundles in one package with good documentation and community support, it is faster to use it than manage each aspect of the configuration by hand or with different tools.

When you start using Oh My ZSH! you can't go back.

#### Install

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

!!! note "updates"

    Oh My ZSH! checks for the latest version and will warn if the version is outdated every time a new shell is started

#### Theme

##### PowerLevel10k

There are many great themes out there to help developers to become more productive and make the Terminal look cool.
On such theme is `PowerLevel10k`. It's easy to install and provides a ton of tooling in your shell. It's available in a git repo that you have to clone in your `.oh-my-zsh`  custom folder.

!!! note "Fonts"
    When using iTerm2 or Termux, p10k configure can install the recommended font automatically. Simply answer Yes when asked whether to install Meslo Nerd Font.

    Else, [read the docs](https://github.com/romkatv/powerlevel10k#manual-font-installation) to learn how to install the needed fonts.

=== "OSX"

    ```bash
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i ' ' -e 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g'  ~/.zshrc
    zsh
    ```

=== "Linux"

    ```bash
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' -i ~/.zshrc
    zsh
    ```

When opening a ZSH shell for the first time (done by calling `zsh` above), a menu will appear and ask some questions to setup the shell to your convenience.

This setup phase can be restarted anytime with the command `p10k configure`

Here are the answers to get a cool but productive shell:

- `prompt style`: `rainbow` is generally the best look(3)
- `Character Set`: `Unicode` (1)
- `Show current time`: use 24h (2)
- `Prompt Separators`: Angled (1)
- `Prompt Heads`: Sharp (1)
- `Prompt Tails`: Flat (1)
- `Prompt Height`: using only one line is better when copy/pasting (1)
- `Prompt Connection`: (if `Prompt Height` is set to 2): Disconnected (1)
- `Prompt Frame`: (if `Prompt Height` is set to 2): No Frame (1)
- `Prompt Spacing`: Compact (1)
- `Icons`: Many (2)
- `Prompt Flow`: Concise (1)
- `Enable Transient Prompt?`: Yes (y)
- `Instant Prompt Mode`: speed up slow scripts... set to Verbose as recommended (1)
- `Apply changes to ~/.zshrc`: Damn YES (y)

##### Agnoster

[Agnoster](https://github.com/agnoster/agnoster-zsh-theme) is another cool theme, but less powerful than PowerLevel10k.

Agnoster is a lighter theme, less intrusive by default, but lack some of the cool stuff.

#### Plugins

ZSH uses plugins that extend the shortcuts and other behaviours for default apps. Here's some that are worth using:

```yaml
plugins=(brew git python tmux vault terraform)
```

Once those plugins are installed and the shell is reloaded, a ton of new Aliases are created. Use `alias` command to list them all. Here are a few:

```bash
alias | grep git

g=git
ga='git add'
gaa='git add --all'
gam='git am'
```

## I'm still typing too much `kubectl`

When working with Kubernetes, some commands are regularily used, like `k get po`. Even if it is faster to type than `kubectl get pods`, it's still 8 characters long (including spaces).

Oh My ZSH! includes a plugin for `kubectl` that ads a ton of aliases specific to `kubectl`

Those alias are usually based on the first letters of each components of the command to execute, like `kgp` for `Kubectl Get Pods`.

Simply add `kubectl` to the list of plugins in `.zshrc` file:

```yaml
plugins=(brew git python tmux vault terraform kubectl)
```

Check that all the new aliases are created after starting a new shell:

``` bash
alias | grep kubectl
```
```bash
k=kubectl
kaf='kubectl apply -f'
kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'
kccc='kubectl config current-context'
...
```

Because the plugin `kubectl` already create the alias `k=kubectl`, we don't need it explicitely in our `.zshrc` file. 

Oh My ZSH! also initialize the completion system, so you can also remove it. Comment those lines in the `.zshrc` file:

```bash
# k=kubectl
# autoload -Uz compinit
# compinit

```

Note that the aliases are all calling `kubectl` explicitelly.

## zsh-autosuggestions plugin

TBD

## zsh-syntax-highlighting plugin

TBD

## Dynamic Prompt

Oh My ZSH! now includes a neat feature called the `dynamic prompt`. Instead of having a prompt line which actually takes 3 lines and display your Git repo, Kubernetes Context, AWS or GCP account all the time, the needed information can be displayed only when needed.

In the case of Kubernetes, it means only when using the `kubectl` command, or any associated or similar commands like `k`.

It is possible to add more commands that will trigger the display of the prompt section by editing the `~/.p10k.zsh` file. Search for the variable `POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND` and edit the line.

```bash
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|kubecolor|skaffold'
```

## Reference

- [Oh My ZSH !](https://ohmyz.sh/)
- [PowerLevel10k](https://github.com/romkatv/powerlevel10k)