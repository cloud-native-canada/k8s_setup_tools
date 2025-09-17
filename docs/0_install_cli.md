## 1. Gemini CLI Installation

Before you do the setup and run Gemini CLI, let us create a folder that you will be using as our home folder for all the projects that you may create inside of it. This is a starting point for the Gemini CLI to work with, though it will also reference some other folders on your system and which you will come to later, as needed.

Go ahead and create a sample folder (`gemini-cli-projects`) and navigate to that via the commands shown below. If you prefer to use some other folder name, please do so.

```bash
mkdir gemini-cli-projects
```

Let's navigate to that folder:

```bash
cd gemini-cli-projects
```

**Note**: If you are using Google Cloud Shell, the Gemini CLI is already installed. You can directly launch Gemini CLI via the `gemini` command. Please navigate directly to the next section (Gemini CLI configuration via settings.json).

If you want to install Gemini CLI locally, follow the instructions given below.

### Install Node 20 +

The first step is to install Node 20+ on your machine. Once this is complete, you can install and run Gemini CLI via any one of the following methods:

### Install Gemini CLI

You can install Gemini CLI globally on your system first. You may need Administrator access to perform this step.

```bash
# Install Gemini CLI
npm install -g @google/gemini-cli
```


Login with Google (OAuth login using your Google Account)

**✨ Important step:** For anyone who has a Gemini Code Assist License, make sure project with licenses is set

=== "Apple Mac OsX / Linux"

```bash
# Set your Google Cloud Project
export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_NAME"
```

=== "Windows"

```bash
# Set your Google Cloud Project
set GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_NAME"
```

**Note**: Make sure update "YOUR_PROJECT_NAME" wit project with Gemini Code Assist License

```bash
# .. and then run
gemini
```

You can confirm the CLI is installed by running:

```bash
gemini --version
```

Assuming that you have launched Gemini CLI first time you should see the following screen that asks you about choosing a a theme. Go ahead and select one that you like:

![Theme selection screen](https://codelabs.developers.google.com/static/gemini-cli-hands-on/img/9b02bd0bf1c670d_1920.png)

Once you select that, it will ask for the Authentication method. If you are using Gemini Code Assist License, it is recommended that you use 
`1. Login with Google`.

![Authentication method selection](https://codelabs.developers.google.com/gemini-cli-hands-on/img/afce8d90e20adb6.png)

Go ahead and click on Enter. This will open up a Google Authentication page in the browser. Go ahead with the authentication with your Google Account, accept the terms and once you are successfully authenticated, you will notice that the Gemini CLI is ready and waiting for your command. A sample screenshot is given below:

![Gemini CLI ready screen](https://codelabs.developers.google.com/gemini-cli-hands-on/img/ffd8ddfede565612.png)

## 2. Gemini CLI configuration via settings.json

If you choose Cloud Shell to run Gemini, a default theme for Gemini CLI and the authentication method is already selected and configured for you.

If you installed Gemini CLI on your machine and launched it for the first time, you selected a theme and then an authentication method.

Now, on subsequent runs of Gemini CLI, you will not be asked to select a theme and authentication method again. This means that it is getting persisted somewhere and the file that it uses is called `settings.json` and it is the way to customize Gemini CLI.

Settings are applied with the following precedence (Cloud Shell only makes User settings available):


=== "Linux"

*   **System**: `/etc/gemini-cli/settings.json` (applies to all users, overrides user and workspace settings).
*   **Workspace**: `.gemini/settings.json` (overrides user settings).
*   **User**: `~/.gemini/settings.json`.

=== "Windows"

*   **Windows**
    *   User: `%USERPROFILE%\.gemini\settings.json` (which typically expands to `C:\Users\<YourUsername>\.gemini\settings.json`)
    *   System: `%ProgramData%\gemini-cli\settings.json` (which typically expands to `C:\ProgramData\gemini-cli\settings.json`)

=== "Apple Mac OsX "

    *   User: `~/.gemini/settings.json` (which expands to `/Users/<YourUsername>/.gemini/settings.json`)
    *   System: `/etc/gemini-cli/settings.json`

If you recollect, at the time of selecting the theme, you selected for the settings to be saved in the User Settings. So visit the `~/.gemini` folder and you will notice the `settings.json` file.

My `settings.json` file is shown below. If you had selected another theme, you would see the name there.

```json
{
  "theme": "Default",
  "selectedAuthType": "oauth-personal"
}
```
