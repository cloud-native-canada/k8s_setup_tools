## What is Vibecoding?

Vibe coding refers to the practice of instructing AI agents to write code based on natural language prompts.

It's not about being lazy—it's about focusing your time and energy on the creative aspects of app development rather than getting stuck in technical details.

At its core, vibe coding is about communicating with AI in natural language to build apps. Instead of writing code, you describe what you want your app to do, and AI tools handle the technical implementation. 


## Vibe coding task

Let's give Gemini CLI our first task and ask it to build a web application that displays the content of a current RSS feed. Say I follow Cricket with keen interest and for some reason, I am interested in viewing live scores of any match that is going on. Not sure why, but let's leave that here.

Cricinfo.com provides a live feed of cricket scores over here: `https://static.cricinfo.com/rss/livescores.xml`. Let's put Gemini CLI to the test and see how well it does on a sample web application that I'd like to create. Let's go step by step.

Paste following prompt example to Gemini CLI:

```
I would like to create a Python Flask Application that shows me a list of live scores of cricket matches.
There is a RSS Feed for this that is available over here: `https://static.cricinfo.com/rss/livescores.xml`. Let's use that.
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

As we progress through this lavs, we will see a lot more of configuration, context setting and then when we come to various use cases, we will look at developing applications from scratch, migrating current applications, adding a feature or two to an existing application and more. So stay tuned.
