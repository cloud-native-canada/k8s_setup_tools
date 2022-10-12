# Kubectl

`kubectl` may not be expected to appear in the `tooling` section as it's, well, the basic tool.

But maybe there's some commands and tricks that are worth mentioning to use it at its full potential ? 

So here are some cool usage of `kubectl`:

```bash
k create deployment sample_app --image=alpine --dry-run=client -o yaml > sample_yaml.yaml
```

Which will result in the following deployment to be saved:

```yaml title="sample_app.yaml"
--8<-- "docs/yaml/sample_app.yaml"
```