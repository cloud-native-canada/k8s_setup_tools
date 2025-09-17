## Gemini CLI configuration via settings.json

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
