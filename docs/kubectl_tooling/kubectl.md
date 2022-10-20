# Kubectl

`kubectl` may not be expected to appear in the `tooling` section as it's, well, the basic tool.

But maybe there's some commands and tricks that are worth mentioning to use it at its full potential ? 

So here are some cool usage of `kubectl`:

## Create a vanilla resource

```bash
k create deployment sample_app \
  --image=alpine \
  --dry-run=client \
  --output yaml > sample_deployment.yaml
```

Which will result in the following deployment to be saved:

```yaml title="sample_app.yaml"
cat > /tmp/toto <<EOF
--8<-- "docs/yaml/sample_app.yaml"
EOF
```

Then it's easy to edit the yaml file and fill the voides.

## Edit a resource in the cluster

The command `kubectl edit` can be used to edit a resource directly in the cluster. 

While it's better to manage your resources `as code`, versioned in a `git` repo (#Gitops), it's sometimes faster
to directly edit the resource. Such case is changing the `replicas` value of a deployment or updating a label, or removing a `Finalizer` so the resource can be deleted. 

Let's edit our `simple-deployment` and scale it to 3:

```bash
kubectl edit deployment simple-deployment
```

Then go to the line with `  replicas: 2` and change it to `  replicas: 3`.

By default, `kubectl` is using `vi` as an editor. This can be changed by setting a value to the `KUBE_EDITOR` env variable. You can add it to your `.zshrc` or `.bashrc` to make it permanent.

If you're using `vi`, highlight the number `2`, type `r` then `3` then `:wq`

If you made a mistake, just exit without saving using `:q!`

If you prefer to change the editor, set the `KUBE_EDITOR` variable:

=== "MacOsX"

    ```bash title="Use SublimeText"
    export KUBE_EDITOR="/Applications/Sublime.app/Contents/SharedSupport/bin/subl -w"
    ```
    ```bash title="Use VsCode"
    export KUBE_EDITOR="code --wait"
    ```

=== "Linux"

    ```bash
    export KUBE_EDITOR="ed"
    ```

=== "Windows"

    ```bash
    KUBE_EDITOR=code -w
    ```

Of course, there is a `kubectl` command to change the number of `replicas`: 

```bash
kubectl scale --replicas=3 deployment/simple-deployment
kubectl get pods
```
```bash title="output"
NAME                                 READY   STATUS             RESTARTS       AGE
simple-deployment-57d9ccc7f8-2m97j   0/1     CrashLoopBackOff   7 (73s ago)    12m
simple-deployment-57d9ccc7f8-bm8jp   0/1     CrashLoopBackOff   5 (119s ago)   4m48s
simple-deployment-57d9ccc7f8-bqnxs   0/1     CrashLoopBackOff   9 (5m ago)     26m
simple-pod                           1/1     Running            0              26m
```

## I'm still bored to use `kubectl`

And this is right. We added a ton of stuff in our shell to be faster. Let's revisit what we did previously:

- List the pods
    ```bash
    kgp
    ```
    ```bash title="output"
    NAME                                 READY   STATUS             RESTARTS       AGE
    simple-deployment-57d9ccc7f8-2m97j   0/1     CrashLoopBackOff   7 (73s ago)    12m
    simple-deployment-57d9ccc7f8-bm8jp   0/1     CrashLoopBackOff   5 (119s ago)   4m48s
    simple-deployment-57d9ccc7f8-bqnxs   0/1     CrashLoopBackOff   9 (5m ago)     26m
    simple-pod                           1/1     Running            0              26m
    ```

- change the replicas of the deployment
    ```bash
    ksd --replicas=2 simple-deployment
    ```
    ```bash title="output"
    deployment.apps/simple-deployment scaled
    ```