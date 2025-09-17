##  Gemini CLI - Command Parameters

There are a few command line parameters that one can provide when you start Gemini CLI. To get a full list of options, you can use the `--help` as shown below.

```bash
gemini --help
```

This should show the full range of options available. You are encouraged to go through the [documentation here](https://github.com/google-gemini/gemini-cli/blob/main/docs/command-line-options.md).

Let us take a look at a few of them. The first one is to configure Gemini CLI to use either the Pro or the Flash model. Currently, at the time of writing this lab, these are the only two models supported. By default the Gemini 2.5 Pro model is used, but if you would like to use the Flash Model, you can do that at the time of starting Gemini CLI via the `-m` parameter as shown below:

```bash
gemini -m "gemini-2.5-flash"
```

You will notice that if you start in the above manner, you can check the model at the bottom right of the Gemini CLI terminal as shown below:

![Flash model indicator](https://codelabs.developers.google.com/gemini-cli-hands-on/img/6e662d03b61b2b3f.png)

### Non-interactive mode

An interesting option is to run Gemini CLI in a non-interactive mode. This means that you directly provide it the prompt and it will go ahead and respond to it, without the Gemini CLI interactive terminal opening up. This is very useful if you plan to use Gemini CLI in an automated fashion as part of the script or any other automation process. You use the `-p` parameter to provide the prompt to Gemini CLI as shown below:

```bash
gemini -p "What is the gcloud command to deploy to Cloud Run"
```

Do keep in mind that there is no scope to continue the conversation with follow up questions. This mode also does not allow you to authorise tools (including `WriteFile`) or to run shell commands.
