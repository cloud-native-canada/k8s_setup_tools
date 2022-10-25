# Application Deployment

`kubectl` can be used to generate YAML manifests and help you build your own:

- `kubectl create <resource>` to create a resource (`kubectl run` for pods)
- `-–output yaml` (`-o yaml`) to dump the yaml
- `-–dry-run=client` to simulate the resource and not create it in the cluster
- `kubectl explain <resource>` to get more informations on a resource type

## Create a Pod

Before starting, ensure the `kind-dev` is the current cluster:

```bash
kubectl config use-context kind-dev
```

Then run the deployment command:

```yaml title="simple_pod"
kubectl run \
  --image=alpine:latest \
  -o yaml \
  --dry-run=client \
  simple-pod \
  --command -- tail -f /dev/null > simple-pod.yaml

kubectl apply -f simple-pod.yaml
```

Use `kubectl get po` to list the resulting pod:

```bash
kubectl get pods
```
```bash title="output"
NAME                                 READY   STATUS      RESTARTS      AGE
simple-pod                           1/1     Running     0             23s
```

Using `kubectl describe` can give even more infos:
```bash
kubectl describe pods simple-pod
```
```bash title="output"
Name:             simple-pod
Namespace:        default
Priority:         0
Service Account:  default
Node:             dev-worker/10.89.0.3
Start Time:       Thu, 20 Oct 2022 17:16:19 -0400
Labels:           run=simple-pod
Annotations:      <none>
Status:           Running
IP:               10.244.1.5
IPs:
  IP:  10.244.1.5
Containers:
  simple-pod:
    Container ID:  containerd://ef45ec5ea986965ef51da85b8d157c590f68b252114248f4339d0be35feeccfd
    Image:         alpine:latest
    Image ID:      docker.io/library/alpine@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
    Port:          <none>
    Host Port:     <none>
    Command:
      tail
      -f
      /dev/null
    State:          Running
      Started:      Thu, 20 Oct 2022 17:16:21 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-p2mpj (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-p2mpj:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  6m10s  default-scheduler  Successfully assigned default/simple-pod to dev-worker
  Normal  Pulling    6m9s   kubelet            Pulling image "alpine:latest"
  Normal  Pulled     6m8s   kubelet            Successfully pulled image "alpine:latest" in 422.571559ms
  Normal  Created    6m8s   kubelet            Created container simple-pod
  Normal  Started    6m8s   kubelet            Started container simple-pod
```

## Create a Deployment

`kubectl` can be used to create sample resources, like we just did with `pods`. Usually you can't deploy the generated resource directly to a cluster. It is needed to update the resource to configure some aspects that can't be configures in the CLI.

For example, generate a basic deployment:
```bash
kubectl create deployment \
  --image=alpine:latest \
  --replicas=2 \
  -o yaml \
  --dry-run=client \
  simple-deployment 
```
```yaml title="output"
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: simple-deployment
  name: simple-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: simple-deployment
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: simple-deployment
    spec:
      containers:
      - image: alpine:latest
        name: alpine
        resources: {}
status: {}
```

Here the container is missing a real command to execute, like the `tail -f /dev/null` that we added in the `pod`.

Now deploy this manifest:

```bash
kubectl create deployment \
  --image=alpine:latest \
  --replicas=2 \
  -o yaml \
  --dry-run=client \
  simple-deployment > simple-deployment.yaml

kubectl apply -f simple-deployment.yaml
```

Use `kubectl get deployment` to see the result:

```bash
kubectl get deployments
```
```bash title="output"
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
simple-deployment   0/2     2            0           1m1s
```

In Kubernetes, Deployments creates ReplicaSets, which in turn creates Pods:
```bash
kubectl get pods
```
```bash title="output"
NAME                                 READY   STATUS      RESTARTS      AGE
NAME                                 READY   STATUS             RESTARTS      AGE
simple-deployment-5cff76596f-clgl7   0/1     CrashLoopBackOff   5 (86s ago)   1m35s
simple-deployment-5cff76596f-vhnvh   0/1     CrashLoopBackOff   5 (83s ago)   1m35s
simple-pod                           1/1     Running            0             3m30s
```

Oops, something is not quite right with our deployment.

Please, don't try to debug right now. Let's move on.

## Create a Service

Services are the entry-point to your pods. they "load-balance" the requests between all the associated pods.

Here is how to create one:

```bash
kubectl create service clusterip simple-service \
  --tcp=5678:8080 \
  -o yaml \
  --dry-run=client > simple-service.yaml

kubectl apply -f simple-service.yaml
```

Check that the service is OK:

```bash
kubectl get services
```
```bash title="output"
NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
kubernetes       ClusterIP   10.96.0.1     <none>        443/TCP    10d
simple-service   ClusterIP   10.96.94.15   <none>        5678/TCP   4s
```

The `kubernetes` service is a default service pointing to the Kubernetes API of the cluster.

Ok now we have some stuff in the `kind` cluster. 

## Deploy a real application

Now deploy a real application, composed of a Mysql database, a web application and associated services:

```bash title="mysql secret"
cat > mysql-secret.yaml << EOF
--8<-- "docs/yaml/mysql-secret.yaml"
EOF

kubectl apply -f mysql-secret.yaml
```

```bash title="mysql database"
cat > mysql-deployment.yaml << EOF
--8<-- "docs/yaml/mysql-deployment.yaml"
EOF

kubectl apply -f mysql-deployment.yaml
```

```bash title="mysql service"
cat > mysql-service.yaml << EOF
--8<-- "docs/yaml/mysql-service.yaml"
EOF

kubectl apply -f mysql-service.yaml
```

```bash
cat > app-deployment.yaml << EOF
--8<-- "docs/yaml/app-deployment.yaml"
EOF

kubectl apply -f app-deployment.yaml
```

Some spotter a problem already: the password is hardcoded. We'll get to it later.
## Next

Now we have something to play with, [let's start playing](kubectl_tooling/kubectl.md) !