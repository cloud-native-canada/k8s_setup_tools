# MCP Toolbox for Databases

If you are working with Databases, then I suggest that you look at Google project [MCP Toolbox for Databases](https://github.com/googleapis/genai-toolbox). It is an open source MCP server for databases and supports a wide variety of databases, as shown below from their official documentation:

![How Gemini CLI works with MCP](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*OPSEihAzs30FNpyE)


The MCP Toolbox for Databases provides executables depending on your operating system/architecture and you need to configure and run it locally. The database could be local or even remote (for e.g. a Cloud SQL instance running in Google Cloud).

Let's first download the MCP Toolbox for Databases. Before we download create a folder on your machine that will host the MCP Toolbox binary.

```bash
mkdir mcp-toolbox
cd mcp-toolbox
```

Check out the releases page for your Operation System and Architecture and download the correct binary. I am using a Mac machine with the ARM chip, so here is the script that I am using for the latest version of Toolbox:

```bash
export VERSION=0.14.0
curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/darwin/arm64/toolbox
chmod +x toolbox
```

Just keep the entire path to the toolbox ready, since we will need that when we configure this MCP Server in the Gemini CLI `settings.json` file. On my machine, I setup the toolbox in the `/Users/romin/mcp-toolbox` folder. So the entire path to the Toolbox binary is:

`/Users/romin/mcp-toolbox/toolbox`

You can refer to the official documentation on how to configure the various databases / data sources that you would the Toolbox to connect to. But one of the quickest ways to get started is via the `--preview` option for some of the databases that are supported. For e.g. the `--preview` mode is supported for Google Cloud BigQuery database, so let's try that out for my Google Cloud Project.

The MCP server entry that needs to go into the `settings.json` file in Gemini CLI is shown below:

```json
"BigQueryServer": {
  "command": "/Users/romin/mcp-toolbox/toolbox",
  "args": ["--prebuilt", "bigquery", "--stdio"],
  "env": {
    "BIGQUERY_PROJECT": "YOUR_GOOGLE_CLOUD_PROJECT_ID"
  }
}
```

Notice that the command parameter has the full path to the toolbox binary. When we start up Gemini CLI, we can see that additional MCP tools are available now:

Let's query to see what datasets are available in my project. A sample run is shown below:

![How Gemini CLI works with MCP](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*qdW2h2Gvb3hoeMRABsIwYg.png)

![How Gemini CLI works with MCP](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*JViqyBflebnhgWtQNnGjMA.png)


If you want to customize the tools i.e. the queries and the different options that are allowed, you will need to create a file named `tools.yaml` , in which all the data source configuration, toolsets, tools and queries will be configured. You will need to provide as a command line parameter while starting up the toolbox binary via the MCP Server option. Let's configure one of the datasource to understand that better.

Here is a configuration for the `tools.yaml` file for connecting to a public BigQuery dataset in my Google Cloud Project.

```yaml
sources:
  my-bq-source:
    kind: bigquery
    project: YOUR_PROJECT_ID
tools:
  search_release_notes_bq:
    kind: bigquery-sql
    source: my-bq-source
    statement: |
      SELECT
        product_name,description,published_at
      FROM
        `bigquery-public-data`.`google_cloud_release_notes`.`release_notes`
      WHERE
        DATE(published_at) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
      GROUP BY product_name,description,published_at
      ORDER BY published_at DESC
    description: |
      Use this tool to get information on Google Cloud Release Notes.
toolsets:
  my_bq_toolset:
    - search_release_notes_bq
```

To configure this toolset/tool in Gemini CLI, we need to provide the command to configure and start the MCP Toolbox for Databases executable and provide the `tools.yaml` as shown above:

```json
"BigQueryServer": {
  "command": "/Users/romin/mcp-toolbox/toolbox",
  "args": ["--tools-file", "/Users/romin/mcp-toolbox/tools.yaml", "--stdio"],
  "env": {
    "BIGQUERY_PROJECT": "YOUR_GOOGLE_CLOUD_PROJECT_ID"
  }
}
```

Do check out the configuration documentation page for MCP Toolbox for Databases for more information.

