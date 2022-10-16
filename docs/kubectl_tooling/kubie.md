# Kubie

[Kubie](https://github.com/sbstp/kubie) offers context switching, namespace switching and prompt modification in a way that makes each shell independent from others.

This is an alternative to `k ctx` and `k ns` in a way where instead os switching your `context` back and forth and use the same `context` in all your `terminals` (all your `shells`), you pin one `context` per `terminal`.

Under the hood, it automates the use of the KUBECONFIG env variable to allow each shell to be configured differently.

!!! note
    The `KUBECONFIG` variable, if set, will tell `kubectl` to use a specific `config` file instead of the default `~/.kube/config` file.

!!! warning
    It can be dangerous to use `kubie` as you may just enter a command in the wrong shell. It requires a little bit more of attention. Same thing as running `rm -rf *` and using `ssh` toward a production server.

    It is easier to control when all your shells targets only one cluster and you need to use the –context parameter to switch.
    
    At least, if you use Kubie, ensure your shell’s prompt is clearly displaying the cluster/namespace you’re in !

Then, it works almost the same as `ctx`/`ns`, except the selection is only for the current shell.

The cool feature is that you can execute a command in some (or all) of the contexts base on a regexp… it can be handy sometimes

## Install

=== "Apple MacOsX"

    ```bash
    brew install kubie
    ```

=== "Linux"

    You can download a binary for Linux or OS X on the [GitHub releases page](https://github.com/sbstp/kubie/releases).
    
    Use `curl` or `wget` to download it. Don't forget to `chmod +x` the file:

    ```bash
    wget https://github.com/sbstp/kubie/releases/download/v0.19.0/kubie-linux-amd64
    chmod 755 kubie-linux-amd64
    sudo mv kubie-linux-amd64 /usr/local/bin/kubie
    ```

=== "Windows"

    TODO

## Usage

- display a selectable menu of contexts
    ```bash 
    kubie ctx
    ```

- display a selectable menu of namespaces
    ```bash
    kubie ns
    ```

- execute a command in all contexts matched by the wildcard and in the given namespace
    ```bash
    kubie exec <wildcard> <namespace> <cmd> <args>
    ```