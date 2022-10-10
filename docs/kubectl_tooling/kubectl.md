# Kubectl

You may not expect to see Kubectl in the `tooling` section, as it, well, the basic. 

But maybe you're using it wrong ? Or you're not using it to its full potential ? 

We're not going to dive in too much, but here are some cool usage of `kubectl`.

```bash
k create deployment sample_app --image=alpine --dry-run=client -o yaml > sample_yaml.yaml
```

Which will result in the following deployment to be saved:

```yaml title="sample_app.yaml"
--8<-- "docs/yaml/sample_app.yaml"
```