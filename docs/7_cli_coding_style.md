

The `GEMINI.md` file is a crucial component for tailoring the instructional context, or "memory," provided to the Gemini model.

This file enables you to supply:

* Pproject-specific instructions
* Coding style guidelines
* Any relevant background information to the AI

Resulting in responses that are more accurate and customized to your needs.

The `GEMINI.md` file is in markdown format and is loaded hierarchically from multiple locations. The loading order is as follows:

1.  **Global Context:** `~/.gemini/GEMINI.md` (for instructions that apply to all your projects).
2.  **Project/Ancestor Context:** The CLI searches from your current directory up to the project root for `GEMINI.md` files.
3.  **Sub-directory Context:** The CLI also scans subdirectories for `GEMINI.md` files, allowing for component-specific instructions.

You can use the `/memory show` command to see the final combined context being sent to the model.[1][2]

Here is an example of a `GEMINI.md` file:

```markdown
# Project: My Awesome TypeScript Library

## General Instructions:

- When generating new TypeScript code, please follow the existing coding style.
- Ensure all new functions and classes have JSDoc comments.
- Prefer functional programming paradigms where appropriate.
- All code should be compatible with TypeScript 5.0 and Node.js 20+.

## Coding Style:

- Use 2 spaces for indentation.
- Interface names should be prefixed with `I` (e.g., `IUserService`).
- Private class members should be prefixed with an underscore (`_`).
- Always use strict equality (`===` and `!==`).

## Specific Component: `src/api/client.ts`

- This file handles all outbound API requests.
- When adding new API call functions, ensure they include robust error handling and logging.
- Use the existing `fetchWithRetry` utility for all GET requests.

## Regarding Dependencies:

- Avoid introducing new external dependencies unless absolutely necessary.
- If a new dependency is required, please state the reason.
```

You can also add to the `GEMINI.md` file during your interactive session with Gemini CLI using the `/memory add <some instruction/rule>` command.
