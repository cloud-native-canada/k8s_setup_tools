# Gemini CLI Tutorial Series — Part 2: Gemini CLI Command line parameters

*By Romin Irani on Jun 30, 2025*

Welcome to Part 2 of the Gemini CLI Tutorial series. In this part, we are going to look at a few configuration options while launching Gemini CLI at the command line. This tutorial will also help us understand various other features of Gemini CLI like checkpointing, getting debug information, a look at how Gemini CLI sets up the context and more.

This is by no means an exhaustive exploration of each and every flag or command, but it gets our foundation in place to understand what goes on behind the tool and to use a few configuration options as we need.

## Gemini CLI Tutorial Series:

*   Part 1 : Installation and Getting Started
*   Part 2 : Gemini CLI Command line options (this post)
*   Part 3 : Configuration settings via settings.json and .env files
*   Part 4 : Built-in Tools
*   Part 5: Using Github MCP Server
*   Part 6: More MCP Servers : Firebase, Google Workspace, Google Gen AI Media Services and MCP Toolbox for Databases
*   Part 7: Custom slash commands
*   Part 8: Building your own MCP Server
*   Part 9: Understanding Context, Memory and Conversational Branching
*   Part 10: Gemini CLI and VS Code Integration
*   Part 11: Gemini CLI Extensions
*   Part 12: Gemini CLI GitHub Actions
*   ➡️ Codelab : Hands-on Gemini CLI

### Blog post updates:

**September 10, 2025**
*   Validated the commands, updated screenshots for Gemini CLI v0.4.0.
*   Removed the section of Telemetry from this part. It will be republished as a separate article.
*   Expanded the Checkpointing coverage to include the files where checkpointing data is stored.

A gentle reminder that Gemini CLI with its open-source nature, releases versions frequently. So if you already have Gemini CLI setup, do remember to upgrade it. Here's the command:

```
npm upgrade -g @google/gemini-cli
```

In the first part, we simply launched Gemini CLI via the `gemini` command at the terminal, but there are several options that we can tweak. To understand the range of options, simply give the following command `gemini --help` to see the list of options:

Ready for some fun?

Let's have a bit of fun first. Check out the `-y` option, which is the YOLO mode. Ideally you may not want to run Gemini CLI in this fashion, since it will automatically accept all actions. Actions like we saw in the first part, could be things like writing to files, etc — which you might want to acknowledge and permit. But this is not the fun part. The fun part is how the Gemini CLI Engineers have provided a super useful link in the above help instructions for `--yolo` mode. It has a URL, a Youtube video in fact, for you to see the details on this wonderful feature. Please go to that URL and come back with your responses to that :-)

I hope this useful URL continues to be there in future releases too!

### Which version of Gemini CLI are you running?

Let's get back to the options. The `-v` or `--version` is straightforward and we did check that out in the first part. Currently, at the time of writing, here is my Gemini CLI version.

```
gemini -v
0.4.0
```

So, if you are an older version, go ahead and do that upgrade, the instruction is repeated below:

```
npm upgrade -g @google/gemini-cli
```

### Specifying a Gemini model for the Gemini CLI to use

Currently, I know of 2 models that one can specify to the Gemini CLI while starting up: `gemini-pro-2.5` and `gemini-flash-2.5` . This is specified via the `-m` or `--model` parameter as shown below:

```
gemini -m "gemini-flash-2.5"
```

The above command starts up the Gemini CLI and if all goes well you will notice the specific model listed in the status bar at the bottom.

While this is good, here is what I have seen happen and its understandable in the free tier. If you are using the free tier of Gemini CLI with your personal Google account, you will find that even if you choose the `gemini-2.5-pro` model, the CLI adjusts to the `gemini-2.5-flash` model due to quota issues. So be prepared for that. This can be addressed to the best of my knowledge by switching over to using your own Gemini API Key.

### One prompt at a time

How about executing Gemini CLI in a way that it does not bring up the terminal interface. Instead, it just takes your prompt, executes it and gives back the result. This is known as the non-interactive mode.

This can be very useful in scenarios where you want to integrate Gemini CLI in automated pipelines or schedule something at a specific time, without the need for any human interface. This is flexibility of the Gemini CLI interface where its not just about running something inside of a terminal but can be integrated in various other scenarios and execution modes too.

So coming back to what we wanted to try? In case you have a need to simply prompt the Gemini CLI and do not require the terminal interface to come up, try the `-p` or the `--prompt` option, as shown below:

```
gemini -p "What is the gcloud command to deploy an application to Google Cloud Run"
```

or

```
gemini -p "What is the command line syntax for doing a GET call to myhost.com via curl"
```

This might be a good way to get some quick answers but do keep in mind that there is be no scope to continue the conversation with follow up questions.

### Positional Prompt instead of prompt parameter

From what I understand at the time of writing (v0.4.0), this is being deprecated in favour of positional prompt. This means that we can simply give the prompt words after `gemini`.

For example, just try this:

```
gemini "What is the gcloud command to deploy an application to Google Cloud Run"
```

or

```
gemini "What is the command line syntax for doing a GET call to myhost.com via curl"
```

### d stands for debug

You might not need this option ideally but in case you are reporting an issue or even to understand a bit about what is going on, its helpful to see what happens when we use the debug flag i.e. `-d` or `--debug`

First, let me show you the `-d` option while a single prompt (using `-p` ) at the command line. Before I go into launching the Gemini CLI and its output, let me describe the current folder that I am in and its contents. This is important for you too.

I am launching Gemini CLI from `/Users/romin/gemini-cli-projects` folder. This folders has several folders, which contain apps that I have generated using Gemini CLI itself.

So, I go ahead and give the following command below.

```
gemini -d -p "What is the Linux command to move files recursively from one folder to another. Give me an example or two"
```

This results in the following output. I have truncated some of the file listings, so that we keep the focus on what is going on. A better understanding of this output is critical so that you can understand the hierarchy in which Gemini CLI looks at certain files to load in order to setup the context (hint : `GEMINI.md` )

You will notice that the Gemini CLI starts building up a context and tries to find the `GEMINI.md` file. It keeps looking recursively till it has reached the root. At the moment, I do not have any `GEMINI.md` file and hence it could not find that. But if it did, it would have found all the `GEMINI.md` files and concatenated them to create, as the documentation states “instructional context (also referred to as “memory”) provided to the Gemini model. This powerful feature allows you to give project-specific instructions, coding style guides, or any relevant background information to the AI, making its responses more tailored and accurate to your needs”.

We will get to the `GEMINI.md` file a bit later, but here are a couple of things that I believe you should understand if using the Gemini CLI tool.

### What is GEMINI.md and why do I need it?

Let's relook at the high level information around `GEMINI.md` as mentioned in the documentation over here. Its actually quite well written and hence I do not wish to recreate it in some other way. I have highlighted key things in bold.

While not strictly configuration for the CLI's behavior, context files (defaulting to `GEMINI.md` but configurable via the `context.fileName` setting) are crucial for configuring the instructional context (also referred to as "memory") provided to the Gemini model. This powerful feature allows you to give project-specific instructions, coding style guides, or any relevant background information to the AI, making its responses more tailored and accurate to your needs. The CLI includes UI elements, such as an indicator in the footer showing the number of loaded context files, to keep you informed about the active context.

**Purpose**: These Markdown files contain instructions, guidelines, or context that you want the Gemini model to be aware of during your interactions. The system is designed to manage this instructional context hierarchically.

There are a lot of articles that cover how best to write `GEMINI.md` files and it will continue to be something that keeps getting covered. For the moment, it is sufficient to understand that this is one of the key mechanisms by which we can instruct the Gemini CLI to follow our rules/recommendations in how code is generated, any versions, how dependencies should be managed, coding guidelines, etc. You get the gist of where this is going.

I reproduce again, a part of the documentation, that shows a sample `GEMINI.md` file for a Typescript project. Even if you are not a Typescript person, this is a good template to take, customize it for your preferences, language, frameworks and more.

If you have been working with LLMs for a while, you will know by now that these instructions are provided in good faith to the model and the exact results might not be what you want. It may require significant tuning of `GEMINI.md` , some additional parameters and more. Hence we should ideally be looking out for articles where Gemini CLI users will share what's worked best for them and learn together.

Having said that, you can use Gemini CLI without a `GEMINI.md` file too. But you will quickly notice that eventually it would be good to have these files, which may provide overall global instructions for anything you do with Gemini CLI and then have project or task specific `GEMINI.md` files too. That's just a pattern that I believe will emerge. But don't fret too much on that at the moment. I just mentioned multiple `GEMINI.md` files and that brings us to the next question.

### Where should my GEMINI.md files reside?

We have quickly established the fact that we may want multiple `GEMINI.md` files and earlier, we have highlighted that Gemini CLI will find all of them and concatenate them together into a single instructional set that it will use. Content from files lower in this list (more specific) typically overrides or supplements content from files higher up (more general).

So whats, the order in which the `GEMINI.md` will be searched? I summarize it precisely for you, from the documentation:

Context is loaded from three main levels, moving from broadest to most specific:

1.  **Global Context File**: A `GEMINI.md` file in your home directory for rules across all projects. This is a special directory named `~/.gemini`.
2.  **Project and Ancestors Context Files**: Files in the project's root directory for project-wide rules.
3.  **Local Context Files**: Files in sub-directories for highly specific instructions about a particular module or component.

That brings us back to the output that we got from the `-d` (debug) command and do note that while I did not have any `GEMINI.md` , you can see how it went about searching for it.

Let's see what happens when we launch the Gemini CLI without the `-p` option but with just the `-d` option. We launch it as follows:

```
gemini -d
```

This brings up the CLI as shown below:

Notice a few additional things in the debug mode. It displayed what the authentication method was ( `vertex-ai` ), which is what I have used on my system but in your case, if you are using your Google personal account, it would be `oauth-personal` . There is the `--debug` flag shown below. Additionally you also see now the memory usage (for e.g. 198 MB).

At this point, if I do a `/memory show` command, I can see the current context, what files were loaded, etc. This is very useful to understand if the context was loaded correctly. While I do not have a `GEMINI.md` file at the moment, due to which there is nothing available as per the output below.

If you happen to have a `GEMINI.md` file, modify it outside, you can always refresh it via the `/memory refresh` command. Try that command right now and see the similar debug statements that come up.

Whew ! That was a lot of discussion just for `debug` . But do keep this option handy. In case you are reporting any specific issues that you find, it might be handy to turn on the debug mode and see what is going on.

### Let's have a checkpoint

This is an interesting but an essential feature. Imagine you are going on with the Gemini CLI and it has used tools to write to file, etc. But something goes wrong and you would like to get back to the previous good state. That's the checkpointing feature, which as the documentation states “automatically saves a snapshot of your project's state before any file modifications are made by AI-powered tools. This allows you to safely experiment with and apply code changes, knowing you can instantly revert back to the state before the tool was run. ”

By default, when you launch the Gemini CLI, checkpointing is not enabled and you will need to enable it via the `-c` or `--checkpointing` flag, when you launch it.

Let's see this feature in action. First up, I have a small Go project. It is a command line utility that takes a sample text file and it provides the number of characters, words and lines in the text file. So I am in that current folder that has a `main.go` file and a sample file to test `test.txt` . This is also a Git enabled folder and I have committed `main.go` , `test.txt` and `go.mod` .

I launch Gemini CLI with the checkpointing and debugging enabled as given below:

```
gemini -c -d
```

This brings up the Gemini CLI as shown below:

The status bar clearly shows that I am in `--debug` mode and the folder along with the Git branch are shown.

Let's run a shell command via the `!` to just validate a few things.

So I have run two commands, the `pwd` and the `ls` command:

Hit `ESC` key to come out of the Shell mode.

So we are going to start here.

At this point, there is nothing to restore or go back to. If you need to restore back to some point, you do that via the `/restore` command. If you just use the command as is, it says that there are no restorable tool calls found. And this is fair since we have not asked Gemini to do any task, that resulted in things like creating folders, writing files, etc.

Everything looks good. Let's use the Gemini CLI to now generate a `README.md` file for this project. I give the following command:

This results in a generation of the file and its not yet written. It is asking me for permission to use the `WriteFile` tool.

I go ahead and give it permission. Everything goes fine and it tells me that the file has been created.

At this point, if I run a shell command or even use `@` to display the contents, I can get that:

If you now run the command `/restore` , you can see that there is a checkpoint that it is generated. As per the documentation “these file names are typically composed of a timestamp, the name of the file being modified, and the name of the tool that was about to be run (e.g., `2025–09–10T06–56–49_549Z-README.md-write_file` ).

So, when we run this, we see the following:

You can see that it has the `timestamp-<filename>-<toolname>`.

Before we make another change to the `README.md` file, let us see where the checkpoint data is being stored? Go to the home directory (e.g. `~` on my Mac). This will have a `.gemini/tmp` folder. Expand that to see a folder that will contain your logs, shell history and checkpoints. A sample for the above operations that we have done is shown below:

If you click on the checkpoints file ( `2025–09–10T06–56–49_549Z-README.md-write_file.json` ) you will see the details for the interaction that has happened so far.

Cool ! Let's make another change in the `README.md` file that we have. At the top, the title reads `Go Word Counter` . I would like this to be changed to `File Stats utility` .

The prompt is: `In the @README.md file, change the title to “File Stats Utility”`

We run the above prompt as shown below:

It does a good job and it's asking me to apply the change, which I am ok with. It says that it has completed the task and at this point, if I go to shell mode and ask it to print out `README.md` , I can see that it has done that:

Let's use the `/restore` command now to see if another checkpoint has been created and indeed there is one:

So we can see that we have two checkpoints, one for the `README.md` file creation and the other for the task that replaced the title.

At this point, if you observe the `.gemini/tmp/<CHECKPOINT>` specific folder as explained above, you will see that there are two checkpoints now:

Use the `/restore` command and you can now scroll through any of the checkpoints and go back to that state. So I can just go to say the second one , which only replaced the title and get it back to the original title i.e. `Go Word Counter` .

I do that and this is important, it shows me the changes that were done at this step, which I want to revert. So when it asks me for permission, I select `4. No, suggest changes` option and I am back to my previous state.

It will display a message that should include:

If I view the contents of the `README.md` file, I see the following:

Remember that Checkpointing is not available by default, so you need to provide the checkpointing flag when you start the Gemini CLI or better still, if this is a feature that you absolutely want running all the time, then you can put that in the `settings.json` file, which we shall see in the next part of this series.

Check out the documentation for more details on Checkpointing.

[gemini-cli/docs/checkpointing.md at 770f862832dfef477705bee69bd2a84397d105a8 ·…](https://github.com/gemini-cli/docs/checkpointing.md)

### Session summary

If you are looking for your session summary to be persisted, which you can then look into, you can try the `--session-summary` parameter.

Launch it as follows: `gemini --session-summary "session.txt"`

This will launch Gemini CLI and keep a track of the. A sample run for my project folder and a couple of interactions to get the list of files and to get an explanation for a file is shown below:

```json
{
  "sessionMetrics": {
    "models": {
      "gemini-2.5-pro": {
        "api": {
          "totalRequests": 1,
          "totalErrors": 0,
          "totalLatencyMs": 9119
        },
        "tokens": {
          "prompt": 7068,
          "candidates": 131,
          "total": 7816,
          "cached": 0,
          "thoughts": 617,
          "tool": 0
        }
      },
      "gemini-2.5-flash": {
        "api": {
          "totalRequests": 1,
          "totalErrors": 0,
.
.
.
```