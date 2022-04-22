### Configure VS Code

#### Install VS Code extensions

TODO: Do we need Prettier extension if ESLint is configured to use prettier?

Current:
- Bracket Pair Colorizer 2 (CoenraadS)
- ESLint (Dirk Baemuer)
- Prettier (Prettier)
- Nord Deep (Marlos Irapuan)
- vscode-icons (VSCode Icons Team)
- advanced-new-file (patbenatar)
- File Utils (Steffen Leistner)
- Thunder Client (Ranga Vadhineni)
- Jest Runner (firsttris)
- Python
- Pylance

If using:
- Deno

#### Configure settings.json
```json
{
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "Nord Deep",
  "editor.fontFamily": "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'",
  "terminal.integrated.fontFamily": "Courier, 'MesloLGS NF'",
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

#### Configure user snippets

File -> Preferences -> User Snippets -> JavaScript

```json
	"Destructure Require": {
		"prefix": ["dreq"],
		"body": ["const { $2 } = require('$1');"],
		"description": "Destructured Require"
	}
```

<details>
  <summary>For NodeJS projects</summary>
## For each project

TODO: find out if can use npm instead of npx, -D instead of --dev for eslint-config-airbnb

```sh
npm i -D eslint prettier eslint-plugin-prettier eslint-config-prettier
npx install-peerdeps --dev eslint-config-airbnb
```

### If node

```sh
npm i -D eslint-plugin-node eslint-config-node
```

### Prettier

Create .prettierrc

```json
{
  "singleQuote": true
}
```

### ESLint

Create .eslintrc.json manually OR

```sh
eslint --init
```

.eslintrc.json

```json
{
  "extends": ["airbnb", "prettier", "plugin:node/recommended"],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": "error",
    "no-unused-vars": "warn"
  }
}
```

### Configure debugger

Choose: Run->Add Configuration->NodeJS

```json
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      //these first 4 lines probably already there.
      "type": "node",
      "request": "launch",
      "name": "Launch Program",
      "program": "${workspaceFolder}/server.js", //or app.js or whatever
      "restart": true,
      "runtimeExecutable": "nodemon",
      "console": "integratedTerminal",
      //what does this do? I added it but seems unnecessary
      "skipFiles": ["<node_internals>/**"]
    }
  ]
}
```

Make sure nodemon is installed globally if you do this.
</details>