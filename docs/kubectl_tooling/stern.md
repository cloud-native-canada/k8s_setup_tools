# Stern

[Stern](https://github.com/stern/stern) allows you to tail multiple pods on Kubernetes and multiple containers within the pod. Each result is color coded for quicker debugging.

## Install

!!! warning
    Note that the [original Stern repo](https://github.com/wercker/stern) was forked at [https://github.com/stern/stern](https://github.com/stern/stern) as the other one is not maintained anymore.

=== "Apple MacOsX"

    ```bash
    brew install stern
    ```

=== "Go"

    ```bash
    go install github.com/stern/stern@latest
    ```

=== "Krew"

    ```bash
    kubectl krew install stern
    ```

## Dumping the logs with kubectl

First let's add a new `deployment` which generate some logs:

```bash
cat > multi-deployment.yaml << EOF
--8<-- "docs/kubectl_tooling/stern.yaml"
EOF

k apply -n default -f multi-deployment.yaml
```

Two new pods are created, each with two containers:

```bash
kgp -l app=multi-deployment
```
```bash title="output"
NAME                                READY   STATUS    RESTARTS   AGE
multi-deployment-6f4fd4f8b8-lg2b8   2/2     Running   0          4m52s
multi-deployment-6f4fd4f8b8-vnqbx   2/2     Running   0          4m49s
```

Here is a command to access the logs:

```bash
k logs -n default -l app=multi-deployment
```
```bash title="output"
Defaulted container "first" out of: first, second
Defaulted container "first" out of: first, second
starting first container
starting first container
```

`kubectl` is complaining that our pods have multiple `containers`, and is only dumping the logs from the first one.

Using the `--all-containers` argument allows to dump them all:

```bash
k logs -n default -l app=multi-deployment --all-containers
```
```bash title="output"
starting first container
starting second container
starting first container
starting second container
```

As you can see, there's multiple things to complain about:

- it's not easy to read
- it is based on `label` selectors
- you have to select one container if there are many in the pod
- when dumping all containers, we have no idea which one logged what
- we have to select a namespace or use the current one

!!! warning

    By default, `kubectl logs` displays the logs and stop. The `--follow` (`-f`) option must be set to `tail` the logs .

## Using Stern

[Stern](https://github.com/stern/stern) is a small app that extend how logs are dumped, adding the name of the pod, the container inside the pod, and using colors to differentiate which is which. It also add an easier way to select the pods to display.

`stern` does not have to use `label` selectors (but you can). By default it use the argument as a regular-expression to search for matching pods. Ex:

```bash
stern multi
```
```bash title="output"
+ multi-deployment-6f4fd4f8b8-vnqbx › first
+ multi-deployment-6f4fd4f8b8-vnqbx › second
+ multi-deployment-6f4fd4f8b8-lg2b8 › second
+ multi-deployment-6f4fd4f8b8-lg2b8 › first
multi-deployment-6f4fd4f8b8-lg2b8 second starting second container
multi-deployment-6f4fd4f8b8-vnqbx second starting second container
multi-deployment-6f4fd4f8b8-lg2b8 first starting first container
multi-deployment-6f4fd4f8b8-vnqbx first starting first container
```

Here's a detailed explanation:

![stern detailed](img/stern-detailed.png)

Stern is really versatile, and here are some command examples, based on the previous `multi-deployment` logs:

- search pods per labels (as with `k logs`)

    ```bash
    stern -n default -l app=multi-deployment
    ```
    ```bash title="output"
    + multi-deployment-6f4fd4f8b8-vnqbx › first
    + multi-deployment-6f4fd4f8b8-vnqbx › second
    + multi-deployment-6f4fd4f8b8-lg2b8 › second
    + multi-deployment-6f4fd4f8b8-lg2b8 › first
    multi-deployment-6f4fd4f8b8-lg2b8 second starting second container
    multi-deployment-6f4fd4f8b8-vnqbx second starting second container
    multi-deployment-6f4fd4f8b8-lg2b8 first starting first container
    multi-deployment-6f4fd4f8b8-vnqbx first starting first container
    ```
- search pods in all namespaces

    ```bash
    k ns kube-system
    stern multi --all-namespaces
    ```
    ```bash title="output"
    + multi-deployment-6f4fd4f8b8-vnqbx › first
    + multi-deployment-6f4fd4f8b8-vnqbx › second
    + multi-deployment-6f4fd4f8b8-lg2b8 › second
    + multi-deployment-6f4fd4f8b8-lg2b8 › first
    multi-deployment-6f4fd4f8b8-lg2b8 second starting second container
    multi-deployment-6f4fd4f8b8-vnqbx second starting second container
    multi-deployment-6f4fd4f8b8-lg2b8 first starting first container
    multi-deployment-6f4fd4f8b8-vnqbx first starting first container
    ```
- Exclude some logs with a matching pattern

    ```bash
    # exclude logs with [INFO]
    stern -ndefault multi --exclude "second"
    ```
    ```bash title="output"
    + multi-deployment-6f4fd4f8b8-zswfr › first
    + multi-deployment-6f4fd4f8b8-zswfr › second
    + multi-deployment-6f4fd4f8b8-lg2b8 › second
    + multi-deployment-6f4fd4f8b8-lg2b8 › first
    multi-deployment-6f4fd4f8b8-lg2b8 first starting first container
    multi-deployment-6f4fd4f8b8-zswfr first starting first container
    ```
- Tail only the latest logs (drop old logs)

    ```bash
    stern -n kube-system coredns --tail 1
    ```
    ```bash title="output"
    + coredns-6d4b75cb6d-plpj9 › coredns
    + coredns-6d4b75cb6d-cw498 › coredns
    coredns-6d4b75cb6d-cw498 coredns linux/amd64, go1.17.1, 13a9191
    coredns-6d4b75cb6d-plpj9 coredns linux/amd64, go1.17.1, 13a9191
    ```
- Tail logs in Json

    This is great as you can use `jq` to pretty-print the logs, or apply some complex `json` filtering:

    !!!note 
        The real log message is in the `message` field, and is encoded. In the case your logs are already JSON, they will be double-encoded, and not pure JSON.

        The latest version of Stern (`1.22.0` or newer) inclused two other `--ouptput` modes: 
        - `extjson`
            This is an extended JSON output, used when your logs are already JSON. In this case, they will not be double-encoded.
        - `ppextjson`
            This is the same as above but keeping the stern colors to identify pods and adding pretty-print indentation so it not necessary to use `jq`

    Here is an updated deployment that logs in json:

    ```bash
    cat > multi-deployment.yaml << EOF
    --8<-- "docs/kubectl_tooling/stern-json.yaml"
    EOF

    k apply -n default -f multi-deployment.yaml
    ```

    dumping the logs in `json` format still encodes the real logs as a `message`:

    ```bash 
    stern multi -o json | jq '.'
    ```
    ```bash title="output"
    + multi-deployment-6f9fb8c49d-l4tzx › second
    + multi-deployment-6f9fb8c49d-l4tzx › first
    {
      "message": "{\"level\":\"info\",\"message\":\"starting\",\"container\":\"second\"}",
      "nodeName": "demo-worker",
      "namespace": "default",
      "podName": "multi-deployment-6f9fb8c49d-l4tzx",
      "containerName": "second"
    }
    {
      "message": "{\"level\":\"warn\",\"message\":\"Redrum. Redrum. REDRUM!\",\"container\":\"second\"}",
      "nodeName": "demo-worker",
      "namespace": "default",
      "podName": "multi-deployment-6f9fb8c49d-l4tzx",
      "containerName": "second"
    }
    {
      "message": "{\"level\":\"info\",\"message\":\"starting\",\"container\":\"first\"}",
      "nodeName": "demo-worker",
      "namespace": "default",
      "podName": "multi-deployment-6f9fb8c49d-l4tzx",
      "containerName": "first"
    }
    {
      "message": "{\"level\":\"warn\",\"message\":\"something is not quite right\",\"container\":\"first\"}",
      "nodeName": "demo-worker",
      "namespace": "default",
      "podName": "multi-deployment-6f9fb8c49d-l4tzx",
      "containerName": "first"
    }
    ```

    Stern can now dump real `json` when you already have `json` logs by using the `extjson` output:

    ```bash 
    stern multi -o extjson | jq '.'
    ```
    ```bash title="output"
    + multi-deployment-6f9fb8c49d-l4tzx › second
    + multi-deployment-6f9fb8c49d-l4tzx › first
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "first",
      "message": {
        "level": "info",
        "message": "starting",
        "container": "first"
      }
    }
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "first",
      "message": {
        "level": "warn",
        "message": "something is not quite right",
        "container": "first"
      }
    }
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "second",
      "message": {
        "level": "info",
        "message": "starting",
        "container": "second"
      }
    }
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "second",
      "message": {
        "level": "warn",
        "message": "Redrum. Redrum. REDRUM!",
        "container": "second"
      }
    }
    ```

    This is far more readable.

    The last `stern` option is the `ppextjson` json, which will pretty-print and colorize the output so it is not needed to use `jq`:

    ```bash 
    stern multi -o ppextjson | jq '.'
    ```
    ```bash title="output"
    + multi-deployment-6f9fb8c49d-l4tzx › second
    + multi-deployment-6f9fb8c49d-l4tzx › first
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "second",
      "message": {"level":"info","message":"starting","container":"second"}
    }
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "second",
      "message": {"level":"warn","message":"Redrum. Redrum. REDRUM!","container":"second"}
    }
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "first",
      "message": {"level":"info","message":"starting","container":"first"}
    }
    {
      "pod": "multi-deployment-6f9fb8c49d-l4tzx",
      "container": "first",
      "message": {"level":"warn","message":"something is not quite right","container":"first"}
    }
    ```