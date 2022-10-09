# Welcome to MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## code test

!!! note "code highlight"
    Code highlight is using a special extension

    Check [how to use notes](https://squidfunk.github.io/mkdocs-material/reference/admonitions/#supported-types)

??? note "code highlight 2"
    Code highlight is using a special extension

This is an inline command: `:::bash for i in * ; do echo $i ; done`.
```bash title="bash test script" hl_lines="2 2"
cd /tmp
ls -l
du -sh *
```

=== "json"

    ```json
    {
        "kind": "Deployment",
        "apiVersion": "apps/v1",
        "metadata": {
            "name": "test",
            "creationTimestamp": null,
            "labels": {
                "app": "test"
            }
        },
        "spec": {
            "replicas": 1,
            "selector": {
                "matchLabels": {
                    "app": "test"
                }
            },
            "template": {
                "metadata": {
                    "creationTimestamp": null,
                    "labels": {
                        "app": "test"
                    }
                },
                "spec": {
                    "containers": [
                        {
                            "name": "alpine",
                            "image": "alpine",
                            "resources": {}
                        }
                    ]
                }
            },
            "strategy": {}
        },
        "status": {}
    }
    ```

=== "yaml"

    ```yaml linenums="1"
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    creationTimestamp: null
    labels:
        app: test
    name: test
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: test
    strategy: {}
    template:
        metadata:
        creationTimestamp: null
        labels:
            app: test
        spec:
        containers:
        - image: alpine
            name: alpine
            resources: {}
    status: {}
    ```

## Tables

| Method      | Description                          |
| ----------- | ------------------------------------ |
| `GET`       | :material-check:     Fetch resource  |
| `PUT`       | :material-check-all: Update resource |
| `DELETE`    | :material-close:     Delete resource |
