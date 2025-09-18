# Gemini CLI Tutorial Series

**By Romin Irani on Google Cloud - Community**
*11 min read · Jun 27, 2025*

Welcome to the Gemini CLI Tutorial Series. It is an open-source AI agent that brings the power of Gemini directly into your terminal. You can use it for both coding related tasks as well as other tasks, it comes integrated with various tools, plus support for MCP servers and most importantly, its open source and comes with a generous free tier (60 requests/min and 1,000 requests/day with personal Google account).

You can read about the announcement blog post and bookmark the Github page for the project, that contains the latest documentation.

- [Announcement blog post](https://medium.com/google-cloud/gemini-cli-tutorial-series-77da7d494718)
- [Github Project](https://github.com/google/gemini-cli)

You would have definitely come to this series after reading/hearing about it and hence we will dive straight into putting it to work.

Let's go.

---

### Gemini CLI Tutorial Series:

- **Part 1 : Installation and Getting Started (this post)**
- Part 2 : Gemini CLI Command line options
- Part 3 : Configuration settings via settings.json and .env files
- Part 4 : Built-in Tools
- Part 5: Using Github MCP Server
- Part 6: More MCP Servers : Firebase, Google Workspace, Google Gen AI Media Services and MCP Toolbox for Databases
- Part 7: Custom slash commands
- Part 8: Building your own MCP Server
- Part 9: Understanding Context, Memory and Conversational Branching
- Part 10: Gemini CLI and VS Code Integration
- Part 11: Gemini CLI Extensions
- Part 12: Gemini CLI GitHub Actions
- ➡️ **Codelab : Hands-on Gemini CLI**

---

### Blog post updates:

**September 10, 2025**
- Screenshots as of Gemini CLI version 0.4.0. Prerequisite for Node version bumped to 20+.
- Validated content and output based on the commands used in the article
- Clearer and added explanations in a few places.

---

## Installation and Getting Started

In the first part of the tutorial series, we will look at setting up our machine for Gemini CLI. Additionally, we will look at getting started with a basic prompt or two and see how it all works. We will dive deeper into configuration, context and lot more settings for this tool, but in this part, we will keep things light and just go through a few initial steps.

![Cloud Shell comes with Gemini CLI](https://miro.medium.com/v2/resize:fit:1400/1*3Y5nZ_jY9A5M5wXwXwXwXw.png)

If you are not looking to install this, consider using Gemini CLI from Cloud Shell. Cloud Shell comes preinstalled with Gemini CLI. You will need to have a Google Cloud Project with billing enabled and know how to navigate your way through Google Cloud console and can launch the Cloud Shell.

If you prefer this method, simply skip the next section i.e. **Installation and setup**.

### Installation and setup

The steps to install Gemini CLI are straightforward. You require Node.js version 20 or higher installed on your machine first. Visit the link and go through with the suggested steps for your Operating System. A sample screenshot for that is shown below:

![Node.js download page](https://miro.medium.com/v2/resize:fit:1400/1*a_v8F2mY3a7L5r4Y_xXwXw.png)

Ensure that the versions are correct and then install Gemini CLI as per the command given below:

```bash
npm install -g @google/gemini-cli
```

Once done, I suggest that you check the Gemini CLI version as follows:

```bash
gemini -v
```

On my system (at the time of writing), it shows the following: `0.4.0`

Go ahead and launch Gemini CLI via the `gemini` command. Keep in mind that this is a client running in your terminal, so be comfortable with using the keyboard (Arrow keys, etc).

It would first ask you about choosing a theme. Go ahead and select one that you like:

![Gemini CLI theme selection](https://miro.medium.com/v2/resize:fit:1400/1*Q_xXwXwXwXwXwXwXwXwXw.png)

Once selected, it asks you to select the Authentication method as shown below:

![Gemini CLI authentication method selection](https://miro.medium.com/v2/resize:fit:1400/1*r_XwXwXwXwXwXwXwXwXwXw.png)

Go with the Google login, which will provide you access to the free tier of Gemini CLI, which allows for 60 requests/minute, 1000 model requests per day. This will invoke the browser, where you will need to login with your Google credentials for the account that you wish to use here. Once done, you should see `Gemini CLI` waiting for your command.

![Gemini CLI waiting for command](https://miro.medium.com/v2/resize:fit:1400/1*C_XwXwXwXwXwXwXwXwXwXw.png)

Alternately, if you need higher quota, feel free to provide your Gemini API Key or even Vertex AI, where you may have a Google Cloud Project with billing enabled. Do refer to the [Authentication section of the documentation](https://github.com/google/gemini-cli#authentication).

---

## Gemini CLI Terminal Interface

Few things to immediately notice in the `Gemini CLI` terminal interface:

1.  **Observe the bottom status bar.** It has the currently folder shown to the left. The model (`gemini-2.5-pro`) which the CLI will use and the amount of context that is remaining. It is not running in a sandbox, which is a mechanism to isolate potentially dangerous operations (such as shell commands or file modifications) from your host system, providing a security barrier between AI operations and your environment.
2.  **Type `/help` (forward slash)** and you will see a variety of commands, keyboard shortcuts and how to use `@` to specific files/folders that you would like to have in the context: Notice that you have the `auth` and the `theme` command that you will be familiar with since you did actually execute that at the time of installation. In case you wish to change the theme or the authentication method, you can invoke them anytime.

![Gemini CLI help command](https://miro.medium.com/v2/resize:fit:1400/1*s_XwXwXwXwXwXwXwXwXwXw.png)

3.  Need to refer the Gemini CLI documentation page, use the `/docs` command.
4.  If you'd like to learn about your current session statistics like `total tokens`, `duration`, etc — you can use the `/stats` command.

If you'd like to quit Gemini CLI, you can use the `/quit` command or press `Ctrl-C` twice.

### Our first words with Gemini CLI

Notice that you can simply type in your message now and see `Gemini CLI` come to work for you. Let's do that.

Let's ask for help first and you guessed it correct, just give `help` without the forward slash. It did satisfactorily well to come up with this response, even though we did not provide it much context:

![Gemini CLI help response](https://miro.medium.com/v2/resize:fit:1400/1*L_XwXwXwXwXwXwXwXwXwXw.png)

As you would know by now, that Gemini CLI is an AI Agent integrated into your terminal, which means that it will be interacting with your environment to complete some of the tasks. This would include having access to your file system, reading/writing files and a lot more. We will be covering more of the tools that Gemini CLI comes wih, but for now you can get a list of all the tools (not MCP Server tools) that are available to Gemini. Just give the `/tools` command, the output of which is given below:

![Gemini CLI tools list](https://miro.medium.com/v2/resize:fit:1400/1*d_XwXwXwXwXwXwXwXwXwXw.png)

What this means is that Gemini CLI will use any of these tools as required but do not worry at this point about it going all crazy with these tools without your permission to do things. You will notice that a tool usage will first result in Gemini prompting you for your permission to invoke the tool. We shall see this later in the series.

These tools are likely to increase in number or undergo changes in the way they work. Note that these are tools that come inbuilt with Gemini CLI. You can further expand Gemini CLI's capabilities by integrating MCP Servers into the CLI and also writing your own custom commands. We shall look at those later in the series.

Out of curiosity, I ask it what the `GoogleSearch` tool does:

![Gemini CLI GoogleSearch tool description](https://miro.medium.com/v2/resize:fit:1400/1*H_XwXwXwXwXwXwXwXwXwXw.png)

Let's give that a try with finding the latest news on India Cricket:

![Gemini CLI GoogleSearch for India Cricket](https://miro.medium.com/v2/resize:fit:1400/1*g_XwXwXwXwXwXwXwXwXwXw.png)

Before we go ahead and give a command to Gemini CLI to create some content/application, it helps to understand the current working directory/folder again. Notice that at the bottom of the status bar to the left is the current folder. Not sure, what it is, you can swap to Shell mode by simply typing in `!`, this will toggle to shell mode as shown below.

The Shell or passthrough command is very interesting and it allow you to interact with your system's shell directly from within Gemini CLI.

```bash
! pwd
```

It says shell mode enabled and I am typing the `pwd` command to understand where I am. The output is shown as below:

![Gemini CLI shell mode](https://miro.medium.com/v2/resize:fit:1400/1*j_XwXwXwXwXwXwXwXwXwXw.png)

You can come out of the terminal mode, by hitting `ESC` key.

You can quit Gemini CLI via the `/quit` command and then ensure that you are in the folder that you would like to be and then launch `gemini` from there.

#### Start Gemini CLI from the folder you'd like to start with

Gemini CLI is a project based tool and expects that you typically start it from a folder in which you want to work in. So ideally you do not want to be in the home folder or at the root of some tree and then expect to go down into another folder. So be cognizant of this and launch Gemini CLI from a folder that you want to work from.

. I have created a root folder named `/gemini-cli-projects` in this folder. I then have multiple other folders that are like mini-projects that I am working on. For e.g. for this series I have created a folder inside of that named `/cli-series` and I am working off that.

---

## Vibe coding task

Let's give Gemini CLI our first task and ask it to build a web application that displays the content of a current RSS feed. Say I follow Cricket with keen interest and for some reason, I am interested in viewing live scores of any match that is going on. Not sure why, but let's leave that here.

Cricinfo.com provides a live feed of cricket scores over here: `https://static.cricinfo.com/rss/livescores.xml`. Let's put Gemini CLI to the test and see how well it does on a sample web application that I'd like to create. Let's go step by step.

Paste following prompt example:

```
I would like to create a Python Flask Application that shows me a list of live scores of cricket matches. There is a RSS Feed for this that is available over here: `https://static.cricinfo.com/rss/livescores.xml`. Let's use that.
```

Gemini CLI responds with the following:

![Gemini CLI response to prompt](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*pqAGuOLdWMEhvw8pDKy5Fg.png)

You can see that it is planning to use one of the tools to create a directory, for which it needs permission to run the `mkdir` command. This is a recurrent pattern that you will see, where you can either allow the tool once, always allow and so on. I am going to allow these tools for now since it is being transparent with what it is going to create, i.e. a sub-folder named `cricket-scores-app` in my `gemini-cli-projects/cli-series`, which is the folder from which I launched the Gemini CLI.

Once it created the folders and touched the files required, it is now beginning to generate code for the application and is using the `WriteFile` tool to create the file + contents, for which it needs permission too.

![Gemini CLI WriteFile tool permission](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*7OKm19f7d12sqo57qfJXHg.png)

Its then gone ahead and created the Python file, HTML file, its identified the Python requirements (`Flask`, `requests` and `feedparser` packages) and is now asking me if it can install the Python packages via `pip`.

![Gemini CLI pip install permission](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*4dgJIGTaUTBaUVaqA9QvqQ.png)

It then goes ahead and creates a virtual environment in Python to setup the dependencies. I give it the permissions and it goes about merrily with the next steps to install the dependencies in the environment and starting the Flask Server on port 5000. It gave an error saying that port 5000 is already in use, so I hit `ESC` and asked it to modify the server code to run on port 7000 instead.

![Gemini CLI port in use error](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*zxGUvksgPGB8fu8DfhEumA.png)

Once the changes were done, it was able to launch the server successfully.

![Gemini CLI server started successfully](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*NlNAJJ-PJm6fjsVtZNlNMQ.png)

I visit the application locally at `http://127.0.0.1:7000`, a screenshot of which is shown below:

![Live Cricket Scores web application](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*fCp7LA_mPYCexsfiT5rrKg.png)

The code generated for the Flask Application was simple and straightforward:

**app.py**
```python
import flask
import feedparser
import requests

app = flask.Flask(__name__)

def get_live_scores():
  """Fetches and parses live cricket scores from the RSS feed."""
  rss_url = "https://static.cricinfo.com/rss/livescores.xml"
  try:
    response = requests.get(rss_url)
    response.raise_for_status() # Raise an exception for bad status codes
    feed = feedparser.parse(response.content)
    return feed.entries
  except requests.exceptions.RequestException as e:
    print(f"Error fetching RSS feed: {e}")
    return []

@app.route('/')
def index():
  """Renders the index page with live scores."""
  scores = get_live_scores()
  return flask.render_template('index.html', scores=scores)

if __name__ == '__main__':
  app.run(debug=True, port=7000)
```

**templates/index.html**
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Live Cricket Scores</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
  <div class="container">
    <h1 class="mt-5">Live Cricket Scores</h1>
    <ul class="list-group mt-3">
      {% for score in scores %}
        <li class="list-group-item">{{ score.title }}</li>
      {% endfor %}
    </ul>
  </div>
</body>
</html>
```

We have hardly scratched the surface here but feel free to take it for a spin. Try out some tasks or an application or two that you would like to see getting generated. It's early days, so be ready for some surprises. I have found that I usually end up prompting again with more context or asking it to do better and more.

As we progress through this series, we will see a lot more of configuration, context setting and then when we come to various use cases, we will look at developing applications from scratch, migrating current applications, adding a feature or two to an existing application and more. So stay tuned.

---

Please consider leaving feedback.