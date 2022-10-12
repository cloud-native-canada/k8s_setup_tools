# Shell Setup

Ok, now you have installed `kubectl` and you have two working local clusters. You will soon realize that you're type `kubectl` (7 letters) quite often. Too often.

You may also wonder *which cluster am I connected to ?* or *what is my default namespace ?*.

You can ease this pain by configuring your shell. 


## Completion

Add those commands to your respecting shell config file. Note you have to restart your shell for it to take effect:

=== "zsh"
    ```bash linenums="1" title="~/.zshrc"
    alias k=kubectl
    source <(kubectl completion zsh)
    ulimit -n 2048          # kubectl opens one cnx (file) per resource
    ```

=== "bash"
    ```bash linenums="1" title="~/.bashrc"
    alias k=kubectl
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
    ulimit -n 2048          # kubectl opens one cnx (file) per resource
    ```

OK This is the basic:

1) instead of typing `kubectl`, just type `k`. It's 6 less characters !

2) add completion to your shell. So you can type `k <tab>` to get help or `k po<tab>` to get completion to `k port-forward`

3) make `k` also use completion

4) increase the number of open files to 2048. This is needed in some cases when you're dealing with a lot of resources and `kubectl` open many connexions against the cluster.

## Cloud commands

### Gcloud

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

### AWS CLI

=== "ZSH"
    ```bash linenums="1" title="~/.zshrc"
    complete -C '/usr/local/bin/aws_completer' aws
    ```

=== "BASH"
    ```bash linenums="1" title="~/.bashrc"
    complete -C '/usr/local/bin/aws_completer' aws
    ```

## ZSH

Mac OSX default shell is now `zsh` so we'll focus on ZSH now on. ZSH is also widely available in Linux and may somtimes be the default too.

!!! note "ZSH deprecation warning"
    To get rid of the deprecation warning in OSX, export this variable in your shell. Add it to your `.zshrc` file for persistance:

    ```bash linenums="1" title="~/.zshrc"
    export BASH_SILENCE_DEPRECATION_WARNING=1
    ```
### Oh My ZSH !

Oh My Zsh is a delightful, open source, community-driven framework for managing your Zsh configuration. It comes bundled with thousands of helpful functions, helpers, plugins, themes, and a few things that make you shout... `"Oh My ZSH!"`

#### Install

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

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

#### Plugins

ZSH uses plugins that extend the shortcuts and other behaviours for default apps. Here's some that are worth using:

```yaml
plugins=(brew kubectl git python tmux vault terraform)
```

Once those plugins are installed and the shell is reloaded, a ton of new Aliases are created. Use `alias` command to list them all. Here are a few:

```bash
alias | grep git

g=git
ga='git add'
gaa='git add --all'
gam='git am'
```

##### kubectl plugin

This plugin ads a ton of aliases specific to `kubectl`, usually based on the action to take, like `kgp` for `Kubectl Get Pods`.

``` bash
alias | grep kubectl

k=kubectl
kaf='kubectl apply -f'
kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'
kccc='kubectl config current-context'
...
```

Because the plugin `kubectl` already create the alias `k=kubectl`, we don't need it explicitely in our `.zshrc` file. You can safely remove it.
Note that the aliases are all calling `kubectl` explicitelly.

##### zsh-autosuggestions plugin

TBD

##### zsh-syntax-highlighting plugin

TBD

#### Dynamic Prompt

Oh My ZSH! now have an eat feature called the dynamic prompt. Instead of having a prompt line which actually takes 3 lines and display your Git repo, Kubernetes Context, AWS or GCP account all the time, the needed information can be displayed only when needed.

In the case of Kubernetes, it means only when using the `kubectl` command, or any associated or similar commands like `k`.

It is possible to add more commands that will trigger the display of the prompt section by editing the `~/.p10k.zsh` file. Search for the variable `POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND` and edit the line.

```bash
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|kubecolor|skaffold'
```

## Reference

- [Oh My ZSH !](https://ohmyz.sh/)
- [PowerLevel10k](https://github.com/romkatv/powerlevel10k)