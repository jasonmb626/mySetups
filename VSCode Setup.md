### Configure VS Code

#### Install VS Code extensions

TODO: Do we need Prettier extension if ESLint is configured to use prettier?

Current:
- Bracket Pair Colorizer 2 (CoenraadS)
- ESLint (Dirk Baemuer)
- Prettier (Prettier)
- Nord Deep (Marlos Irapuan)
- vscode-icons (VSCode Icons Team)
- Docker (Microsoft)
- advanced-new-file (patbenatar)
- File Utils (Steffen Leistner)
- Thunder Client (Ranga Vadhineni)
- Jest Runner (firsttris)

If using:
- Deno

Legacy:
- Vim (vscodevim)

#### Configure settings.json
```json
{
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "Nord Deep",
  "editor.fontFamily": "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'",
  "terminal.integrated.fontFamily": "Courier, 'MesloLGS NF'",
  "editor.lineNumbers": "relative",
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

Legacy VIM:
Running a separate instance of vim or neovim on the rare occasion its robust text manipulation language is warranted is your current preferred approach, but if you want to get the vim plugin working well, here are a bunch of configuration options necessary.

```
  "vim.camelCaseMotion.enable": true,
  "vim.leader": "<space>",
  "vim.replaceWithRegister": true,
  "vim.useSystemClipboard": false,
  "vim.useCtrlKeys": true,
  "vim.handleKeys": {
    "<C-v>": false,
    "<C-d>": false,
    "<C-x>": false,
    "<C-s>": false,
    "<C-a>": false,
    "<C-c>": false,
    "<C-p>": false
  },
  "vim.normalModeKeyBindingsNonRecursive": [
    {
      "before": ["<leader>", "x"],
      "commands": ["workbench.action.toggleSidebarVisibility"]
    },
    {
      "before": ["<leader>", "z"],
      "commands": ["workbench.action.focusSideBar"]
    },
    {
      "before": ["<leader>", "f"],
      "commands": ["revealInExplorer"]
    },
    {
      "before": ["<leader>", "d", "b"],
      "commands": ["editor.debug.action.toggleBreakpoint"]
    },
    {
      "before": ["<leader>", "d", "B"],
      "commands": ["editor.debug.action.conditionalBreakpoint"]
    },
    {
      "before": ["<leader>", "d", "C"],
      "commands": ["editor.debug.action.runToCursor"]
    },
    {
      "before": ["<leader>", "<space>"],
      "commands": ["workbench.action.debug.continue"]
    },
    {
      "before": ["<leader>", "d", "j"],
      "commands": ["workbench.action.debug.stepOver"]
    },
    {
      "before": ["<leader>", "d", "l"],
      "commands": ["workbench.action.debug.stepInto"]
    },
    {
      "before": ["<leader>", "d", "h"],
      "commands": ["workbench.action.debug.stepOut"]
    },
    {
      "before": ["<leader>", "d", "p"],
      "commands": ["workbench.action.debug.pause"]
    },
    {
      "before": ["<leader>", "d", "r"],
      "commands": ["workbench.action.debug.restart"]
    },
    {
      "before": ["<leader>", "d", "s"],
      "commands": ["workbench.action.debug.stop"]
    },
    {
      "before": ["<leader>", "d", "c"],
      "commands": ["workbench.panel.repl.view.focus"]
    },
    {
      "before": ["<leader>", "d", "t"],
      "commands": ["terminal.focus"]
    },
    {
      "before": ["<leader>", "d", "o"],
      "commands": ["workbench.panel.output.focus"]
    },
    {
      "before": ["<leader>", "m"],
      "commands": ["workbench.action.closePanel"]
    },
    {
      "before": ["d", "i", "l"],
      "after": ["^", "d", "g", "_"]
    },
    {
      "before": ["y", "i", "l"],
      "after": ["^", "y", "g", "_"]
    },
    {
      "before": ["d", "a", "l"],
      "after": ["-1", "d", "$"]
    },
    {
      "before": ["y", "a", "l"],
      "after": ["-1", "y", "$"]
    }
  ],
  "vim.visualModeKeyBindingsNonRecursive": [
    {
      "before": [">"],
      "after": [">", "g", "v"]
    },
    {
      "before": ["<"],
      "after": ["<", "g", "v"]
    },
    {
      "before": ["ctrl+r", "m"],
      "commands": [
        {
          "command": "editor.action.codeAction",
          "args": {
            "kind": "refactor.extract.function"
          }
        }
      ]
    },
    {
      "before": ["ctrl+r", "c"],
      "commands": [
        {
          "command": "editor.action.codeAction",
          "args": {
            "kind": "refactor.extract.constant",
            "preferred": true,
            "apply": "ifsingle"
          }
        }
      ]
    },
    {
      "before": ["ctrl+r", "g"],
      "commands": [
        {
          "command": "editor.action.codeAction",
          "args": {
            "kind": "refactor.extract.constant",
            "preferred": false,
            "apply": "ifsingle"
          }
        }
      ]
    }
  ]
```

#### Configure keybindings.json

Legacy VIM
```json
[
  {
    "key": "ctrl+l",
    "command": "explorer.newFile",
    "when": "filesExplorerFocus"
  },
  {
    "key": "ctrl+;",
    "command": "explorer.newFolder",
    "when": "filesExplorerFocus"
  }
]
```

```
  {
    "key": "ctrl+p",
    "command": "selectPrevSuggestion",
    "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
  },
  {
    "key": "ctrl+n",
    "command": "selectNextSuggestion",
    "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
  },
  {
    "key": "ctrl+p",
    "command": "showPrevParameterHint",
    "when": "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible"
  },
  {
    "key": "ctrl+n",
    "command": "showNextParameterHint",
    "when": "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible"
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