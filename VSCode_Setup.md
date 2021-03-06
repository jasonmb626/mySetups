### Configure VS Code

#### Install VS Code extensions

TODO: Do we need Prettier extension if ESLint is configured to use prettier?

General:
- Nord (arcticicestudio)
- vscode-icons (VSCode Icons Team)
- Camel Case Navigation (maptz)
- REST Client (Huachao Mao)
- Docker (Microsoft)
Python:
- Python (Microsoft)
- Pylance (Microsoft) (Should install automically with above Python)
Javascript:
- Prettier (Prettier)
- ESLint (Microsoft)
- Jest Runner (firsttris)

Here are the install commands for ctrl+p

```
ext install arcticicestudio.nord-visual-studio-code
```

```
ext install vscode-icons-team.vscode-icons
```

```
ext install maptz.camelcasenavigation
```

```
ext install humao.rest-client
```

```
ext install ms-azuretools.vscode-docker
```

```
ext install ms-python.python
```

```
ext install esbenp.prettier-vscode
```

```
ext install dbaeumer.vscode-eslint
```

```
ext install firsttris.vscode-jest-runner
```

### Update the comment colors in nord theme
Open ~/.vscode/extensions/arcticicestudio.nord-visual-studio-code-0.19.0/themes/nord-color-theme.json

Find two entries "name": "Comment" & "Punctuation Definition Comment"
Update their "foreground": entry to "#B48EAD"

#### Configure settings.json

Feel free to delete the javascript, python entries if you aren't using those languages.

```json
{
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "Nord",
  "editor.fontFamily": "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'",
  "terminal.integrated.fontFamily": "Courier, 'MesloLGS NF'",
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.bracketPairColorization.enabled": true,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.vscode-pylance"
  }
}
```

#### Configure keybindings.json (Probably only necessary on Linux. Linux defaults are weird. Make them better match Windows.)
```json
  {
    "key": "shift+alt+down",
    "command": "editor.action.copyLinesDownAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  {
    "key": "shift+alt+up",
    "command": "editor.action.copyLinesUpAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  {
    "key": "shift+alt+down",
    "command": "-editor.action.insertCursorBelow",
    "when": "editorTextFocus"
  },
  {
    "key": "shift+alt+up",
    "command": "-editor.action.insertCursorAbove",
    "when": "editorTextFocus"
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

Go ahead and restart VSCode before continuting

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