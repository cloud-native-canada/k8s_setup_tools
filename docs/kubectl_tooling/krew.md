# Extending `kubectl`

Couple years ago K8s community introduced an easy way to extend kubectl via `plugins`.

Plugins are in fact "applications" (executable files) named `kubectl-<plugin_name>`, that are executed when you call `kubectl plugin_name`.

`Krew` is the plugin manager for `kubectl` command-line tool and it's  maintained by the Kubernetes SIG CLI community.

Krew helps you:

- discover kubectl plugins,
- install them on your machine,
- and keep the installed plugins up-to-date.
There are 207 kubectl plugins currently distributed on Krew.

## Krew

`Krew` is an example of such a kubectl plugin that act as a plugin manager for kubectl. It pre-dates the plugin addition in kubectl and may seem useless now, but it still has it's role to play.

### Install

Please refer to the [official install doc](https://krew.sigs.k8s.io/docs/user-guide/setup/install/).

=== "Apple Mac"

    ```bash title="krew install"
    brew install krew
    ```

=== "Using Krew"

    This one is using `krew` itself to install `krew`.

    !!! note

        `krew` installs plugins in `$KREW_ROOT` if you set it or `$HOME/.krew`. You have to then ensure `$HOME/.krew` is in your path.

        Add this to your `.zshrc` or `.bashrc`:

        ```bash
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        ```

    ```bash
    (
      set -x; cd "$(mktemp -d)" &&
      OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
      ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
      KREW="krew-${OS}_${ARCH}" &&
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
      tar zxvf "${KREW}.tar.gz" &&
      ./"${KREW}" install krew
    )
    ```

=== "Windows"

    - Make sure git is installed.
    - Download `krew.exe` from the [Releases](https://github.com/kubernetes-sigs/krew/releases) page to a directory.
    - Launch a command prompt (`cmd.exe`) with administrator privileges (since the installation requires use of symbolic links) and navigate to that directory.
    - Run the following command to install krew:
        ```bash
        .\krew install krew
        ```
    - Add the `%USERPROFILE%\.krew\bin` directory to your `PATH` environment variable (how?)
    - Launch a new command-line window.
    - Run `kubectl krew` to check the installation.
    
### Usage

```
kubectl krew update
``` 

```bash
kubectl krew list
```
```bash title="output"
PLUGIN  VERSION
ctx     v0.9.4
krew    v0.4.1
ns      v0.9.4
whoami  v0.0.36
```
```bash
kubectl krew search
```
```bash title="output"
NAME                            DESCRIPTION                                         INSTALLED
access-matrix                   Show an RBAC access matrix for server resources     no
blame                           Show who edited resource fields.                    no
cert-manager                    Manage cert-manager resources inside your cluster   no
ctx                             Switch between contexts in your kubeconfig          yes
...
```

### Krew Plugins

Install plugins that will be used in the tutorial:

- ctx: current cluster `Context` and quick context changes
- ns: current `Namespace` and quick namespace changes
- [whoami](https://github.com/rajatjindal/kubectl-whoami): who the cluster thinks you are from your authentication
- [who-can](https://github.com/aquasecurity/kubectl-who-can): RBAC rules introspection
- view-secret: directly view secret content without having to decode

Install them with this command:

```bash
kubectl krew install neat ctx ns whoami who-can view-secret
```

## Generating the application manifest

The GoWebApp application was previously deployed with a hardcoded password for Mysql. This is not optimal and not recommended. It was done like this because it's a DEMO, and not real production cluster.

!!! note
    Usually all application's deployment files (the YAML) should be managed in a versioned repository and should never be modified directly on the cluster.

    For this DEMO, still, we are going to use the currently deployed application and modify it.

Now that the application is running and everything is fine, it is a good idea to store the resulting yaml in our own repo.

First dump the `gowebapp` deployment into a file. By using the `--output yaml` (`-o yaml`) option, `kubectl` will dump the full file, including some fields internal to the current deployment that are not needed:

```bash
k get deploy gowebapp --output yaml
```

```yaml title="output"
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"labels":{"run":"gowebapp"},"name":"gowebapp","namespace":"default"},"spec":{"replicas":1,"selector":{"matchLabels":{"run":"gowebapp"}},"template":{"metadata":{"labels":{"run":"gowebapp"}},"spec":{"containers":[{"env":[{"name":"DB_PASSWORD","value":"rootpasswd"}],"image":"ghcr.io/cloud-native-canada/k8s_setup_tools:app","livenessProbe":{"httpGet":{"path":"/register","port":9000},"initialDelaySeconds":15,"timeoutSeconds":5},"name":"gowebapp","ports":[{"containerPort":9000}],"readinessProbe":{"httpGet":{"path":"/register","port":9000},"initialDelaySeconds":25,"timeoutSeconds":5},"resources":{"limits":{"cpu":"50m","memory":"100Mi"},"requests":{"cpu":"20m","memory":"10Mi"}}}]}}}}
  creationTimestamp: "2022-10-25T16:32:28Z"
  generation: 1
  labels:
    run: gowebapp
  name: gowebapp
  namespace: default
  resourceVersion: "2662"
  uid: c0085020-845c-468e-a95e-9bb2e908dc2b
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      run: gowebapp
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: gowebapp
    spec:
      containers:
      - env:
        - name: DB_PASSWORD
          value: rootpasswd
        image: ghcr.io/cloud-native-canada/k8s_setup_tools:app
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /register
            port: 9000
            scheme: HTTP
          initialDelaySeconds: 15
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
        name: gowebapp
        ports:
        - containerPort: 9000
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /register
            port: 9000
            scheme: HTTP
          initialDelaySeconds: 25
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
        resources:
          limits:
            cpu: 50m
            memory: 100Mi
          requests:
            cpu: 20m
            memory: 10Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2022-10-25T16:33:09Z"
    lastUpdateTime: "2022-10-25T16:33:09Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2022-10-25T16:32:28Z"
    lastUpdateTime: "2022-10-25T16:33:09Z"
    message: ReplicaSet "gowebapp-5994456fcb" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 1
  readyReplicas: 1
  replicas: 1
  updatedReplicas: 1
```

Here, the `status` section is useless, as it relates to the current deployment. So are the `UID` or `creationTimestamp` fields. It is not recommended to store these values in your GitOps repo.

Krew has a little plugin to trim off the un-needed parts of exported resources: [Neat](https://github.com/itaysk/kubectl-neat).

To use Neat, just add the `neat` keyword between `kubectl` and the `get` command:

```bash
k neat get deploy gowebapp --output yaml
```
```yaml title="output"
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  labels:
    run: gowebapp
  name: gowebapp
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      run: gowebapp
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: gowebapp
    spec:
      containers:
      - env:
        - name: DB_PASSWORD
          value: rootpasswd
        image: ghcr.io/cloud-native-canada/k8s_setup_tools:app
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /register
            port: 9000
            scheme: HTTP
          initialDelaySeconds: 15
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
        name: gowebapp
        ports:
        - containerPort: 9000
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /register
            port: 9000
            scheme: HTTP
          initialDelaySeconds: 25
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
        resources:
          limits:
            cpu: 50m
            memory: 100Mi
          requests:
            cpu: 20m
            memory: 10Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      terminationGracePeriodSeconds: 30
```

When needed, you can then save the file for backup or later use:

```bash
# k neat get deploy gowebapp --output yaml > neat-app-deployment.yaml
```

## manage Kubernetes `namespaces`

Kubernetes has the notion of `namespaces` to organize the resources and manage access control (RBACs). 

When a cluster is first created, some `namespaces` are created by default:

```bash
kubectl get namespaces
```
```bash title="output" hl_lines="1 1"
default
kube-node-lease
kube-public
kube-system
```

The `default` namespace is, well, the default. `kube-system` namespace is a really specific namesapce hosting all the mandatory cluster resources. 

The Krew `ns` plugin is used to switch context and set it as the new default. This change is actually persisted in the `~/.kube/config` file.

As `kubectl get namespaces`, the `k ns` command will dump the existing `namespaces` from the cluster.

Switch to `kube-system` namespace:

```bash
k ns kube-system
```
```bash title="output" hl_lines="7 7"
Context "kind-dev" modified.
Active namespace is "kube-system".
```

![krew ns](img/krew-ns.png)

### Deploy aplication in a new `namespace`

- k8s context

```bash
kubectl config current-context
```
```bash
kind-dev
```

- All contexts

We can list all Kubernetes `context` using `kubectl`:

```bash
kubectl config  get-contexts
```
```bash
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-dev    kind-dev    kind-dev
```


Before we deploy a new application, remove the application from the `default` namespace:

```bash
k delete -f ~/demo/base
```

Now create a new namespace:

```bash
k create namespace gowebapp
```

Then switch to this new namespace:

```bash
k ns gowebapp
```

Now install the GoWebApp application into this new namespace:

```bash
k apply -f app-deployment.yaml
k apply -f mysql-deployment.yaml
k apply -f app-service.yaml
k apply -f mysql-service.yaml
k apply -f mysql-secret.yaml
```

## manage Kubernetes `context`



- k8s context

```bash
kubectl config current-context
```
```bash
kind-dev
```

- All contexts

We can list all Kubernetes `context` using `kubectl`:

```bash
kubectl config  get-contexts
```
```bash
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-dev    kind-dev    kind-dev
```



`kubectl` is using the notion of `contexts` to define which cluster you know and which one is actuvelly being used. 

All this is defined in the `$HOME/.kube/config` file. This file can get quite large and difficult to work with.

`kubectl` has a default command to change context:

```bash
kubectl config get-contexts
```
```bash title="output"
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-dev    kind-dev    kind-dev    default
          kind-stg    kind-stg    kind-stg
```

Switch context to the `stg` cluster:

```bash
kubectl config use-context kind-stg
```

While this is not that long to type, we can do better with `ctx` plugin. Also, when using `kubecolor`, the current context will be highlighted:

```bash
k ctx
```
```bash  title="output" hl_lines="1 1"
kind-dev
kind-stg
```

You can also change context quickly by just appending the name of the target context to the same command:

```bash
k ctx kind-stg
```
```bash title="output" hl_lines="2 2"
kind-dev
kind-stg
```

Finaly you can delete a context (but don't do it right now):

```bash
k ctx -d kind-stg
```

![krew ctx](img/krew-ctx.png)

## View Secrets

Secrets in Kubernetes are an enhenced version of ConfigMaps: they are base64 encoded !

First, create a secret:

```bash
k create secret generic my-secret --from-literal=key1=supersecret --from-literal=key2=topsecret -o yaml --dry-run=true
```
```yaml title="output"
apiVersion: v1
data:
  key1: c3VwZXJzZWNyZXQ=
  key2: dG9wc2VjcmV0
kind: Secret
metadata:
  creationTimestamp: null
  name: my-secret
```

the values are un readable because they are `base64` encoded.

Apply that to the cluster:

```bash
k create secret generic my-secret \
  --from-literal=key1=supersecret \
  --from-literal=key2=topsecret \
  -o yaml --dry-run=true | k apply -n default -f -
```

It is possible to read a `secret` value by using a templated output option:

```bash
kubectl get secret -n default my-secret --output=go-template={{.data.key1}} | base64 --decode
```
```bash title="output"
supersecret
```

The Krew plugin `view-secret` does all that in one simple call:

```bash
k view-secret my-secret key1
```
```bash title="output"
supersecret
```

## Next

Continue to [Multi Context](kubie.md)