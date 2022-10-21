# Setup your Shell for Kubernetes and get productive quickly

This site is the companion to the KubeCon 2022 NA talk:

[Set Up Your Shell For Kubernetes Productivity And Be Efficient Quickly - Sebastien “Prune” Thomas, Wunderkind & Archy Ayrat Khayretdinov, Google](https://kccncna2022.sched.com/event/182F7/tutorial-set-up-your-shell-for-kubernetes-productivity-and-be-efficient-quickly-sebastien-prune-thomas-wunderkind-archy-ayrat-khayretdinov-google)

Follow this website to run the demos on your own laptop.

to get access to some larger `yaml` files, you can clone the repo using `git`:

```bash 
git clone git@github.com:cloud-native-canada/k8s_setup_tools.git

# if you don't have a git account, you can clone anonymously with:
# git clone https://github.com/cloud-native-canada/k8s_setup_tools.git

cd k8s_setup_tools
```

## agenda

- [`kubectl`](kubectl.md)

    Install of the `kubectl` command and basic usage

- [Getting rid of Docker-For-Desktop](local_cluster/colima.md)

    Docker For Desktop is now a paid software for enterprise users. The [price was bumped again on October 27th 2022](https://www.docker.com/pricing/october-2022-pricing-change-faq) !

    Learn how to replace Docker For Desktop once and for all.

- [Alternative Docker replacement](local_cluster/podman.md)

    Install the tooling to use `docker` (without docker).

- [Local Kubernetes cluster for development](local_cluster/kind.md)

    You don't always have a real (remote) Kubernetes cluster, or you have one, but you can't *play* with it.
    Learn how to create a local `Kubernetes` cluster for local development, a cluster that you can
    re-create many times a day to test things.

    Later on a sample application including a failed deployment will be installed to give some meat to the demos

- [Install a sample application](app_deployment.md)

    Quickly use `kubectl` command to create some resources.

- [I'm typing too much `kubectl`](shell_setup.md#im-typing-too-much-kubectl-commands)

    Type less by using some `alias` commands

- [`kubectl` arguments are too long](shell_setup.md#kubectl-arguments-are-too-long)

    Enhance `kubectl` experience by setting up the shell Completion. Stop typing everything and use `tab` key !

- [ZSH and Oh My ZSH! framework](shell_setup.md#zsh-shell)

    Oh My ZSH! is a sort of framework for your shell that pre-configure and extend your shell with a ton of features. 

- [I'm still typing too much `kubectl`](shell_setup.md#im-still-typing-too-much-kubectl)

    Using the `kubectl` plugin for Oh My ZSH! to even shorten the typing

- [How do I use all those `kubectl` shorthands ?](kubectl_tooling/kubectl.md)

    Let's demo some of the `kubectl` command and their associated alias

- [There's too many output from `kubectl` I can't read it](kubectl_tooling/kubecolor.md)

    Here again there's some tooling to help. Let's introduce `kubecolor` !

- [I want to extend `kubectl`](kubectl_tooling/krew.md)

    Kubectl is already a complex command, but what if I want to extend it ? 

- [Switching Cluster Context is a pain](kubectl_tooling/krew.md#manage-kubernetes-context)

    `kubectl` uses a notion of `context` to manage the many servers you can connect to. Switching from one to the other can quickly be a pain. We have some tools for that too !

- [I want multiple context at the same time](kubectl_tooling/kubie.md)

    The current default `context` and `namespace` are global to your shells. 
    
    While more dangerous, it is possible to change this behaviour so each shell target a different `context` or `namespace`
    
- [I have too many `context`](kubectl_tooling/kubie.md#i-dont-know-which-context-im-using)

- [I need to read my logs](kubectl_tooling/stern.md)
- 
- `Kubernetes interfaces`

    We will quickly dive into some usefull interfaces to get an overview of your cluster

- `Development tooling`

    Finaly we will go through some of the helpers that you can install when you're developing for Kubernetes
    or extensively working with json and yaml files