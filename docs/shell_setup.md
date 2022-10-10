# Shell Setup

Ok, now you have installed `kubectl` and you have two working local clusters. You will soon realize that you're type `kubectl` (7 letters) quite often. Too often.

You may also wonder *which cluster am I connected to ?* or *what is my default namespace ?*.

You can east this pain by configuring your shell. 


## completion

Add those commands to your respecting shell config file. Note you have to restart your shell for it to take effect:

=== "zsh"
    ```bash linenums="1" title="~/.zshrc"
    alias k=kubectl
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
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

Mac OSX shell is now `zsh` by default. So we'll focus on ZSH now. ZSH is also widely available in Linux and may somtimes be the default too.

!!! note "ZSH deprecation warning"
    To get rid of the deprecation warning in OSX, export this variable in your shell. I recommend adding it to your `.zshrc` file:

    ```bash linenums="1" title="~/.zshrc"
    export BASH_SILENCE_DEPRECATION_WARNING=1
    ```
### Oh My ZSH !

#### install

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Theme

The best theme I found is called `PowerLevel10k`. It's easy to install and provide a ton of tooling in your shell. It's available in a git repo that you have to clone in your `.oh-my-zsh` custom folder.

!!! note "Fonts"
    If you are using iTerm2 or Termux, p10k configure can install the recommended font for you. Simply answer Yes when asked whether to install Meslo Nerd Font.

    Else, re [the docs](https://github.com/romkatv/powerlevel10k#manual-font-installation) to learn how to install the needed fonts.

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

When opening a new ZSH shell for the first time (done by calling `zsh` above), you'll be asked a lot of questions to setup your shell to your convenience.

You can re-enter this setup phase anytime with the command `p10k configure`

tricky questions and my usual answers:

- `prompt style`: I usually use `rainbow` (3)
- `Character Set`: `Unicode` (1)
- `Show current time`: use 24h (2)
- `Prompt Separators`: Angled (1)
- `Prompt Heads`: Sharp (1)
- `Prompt Tails`: Flat (1)
- `Prompt Height`: I think using only one is better to copy/paster (1)
- `Prompt Connection`: (if `Prompt Height` is set to 2): Disconnected (1)
- `Prompt Frame`: (if `Prompt Height` is set to 2): No Frame (1)
- `Prompt Spacing`: Compact (1)
- `Icons`: Many (2)
- `Prompt Flow`: Concise (1)
- `Enable Transient Prompt?`: Yes (y)
- `Instant Prompt Mode`: speed up slow scripts... set to Verbose as recommended (1)
- `Apply changes to ~/.zshrc`: Damn YES (y)

#### Plugins

ZSH uses plugins that extend the shortcuts and other behaviours for default apps. Here's the list I usually use:

```yaml
plugins=(brew kubectl git python tmux vault terraform)
```

Once you relad you shell, you have a ton of new Aliases. Use `alias` command to list them all. Here are a few:

```bash
alias | grep git

g=git
ga='git add'
gaa='git add --all'
gam='git am'

alias | grep kubectl

k=kubectl
kaf='kubectl apply -f'
kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'
kccc='kubectl config current-context'
...
```