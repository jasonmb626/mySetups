# Configure VS Code/VSCodium/VS Code OOS

## Enable extensions gallery \(VSCodium/VS Code OOS\) Only

From their [gighub](https://github.com/VSCodium/vscodium/blob/master/DOCS.md#extensions-marketplace)

For the Open Source packaged distrubutions of VSCode \(VSCodium/VS Code OOS\), by default only extensions available on open-vsx.org are shown.

If you want all of the extensions available in vanilla VS Code then you will need to edit product.json and add the following:
```json
{
  "extensionsGallery": {
    "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
    "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
    "itemUrl": "https://marketplace.visualstudio.com/items",
    "controlUrl": "",
    "recommendationsUrl": ""
  }
}
```
product.json should be placed in one of the following locations:

Windows: %APPDATA%\VSCodium\product.json or %USERPROFILE%\AppData\Roaming\VSCodium\product.json
macOS: ~/Library/Application Support/VSCodium/product.json
Linux: $XDG_CONFIG_HOME/VSCodium/product.json or ~/.config/VSCodium/product.json
Linux \(Flatpak\): $XDG_CONFIG_HOME/.var/app/com.vscodium.codium/config/VSCodium/product.json

#### Install VS Code extensions

TODO: Do we need Prettier extension if ESLint is configured to use prettier?

- vim (vscodevim)
- Nord (arcticicestudio)
- vscode-icons (VSCode Icons Team)
- Docker (Microsoft)
- Remote - Containers (Microsoft)
- Git Graph (mhutchie)

Here are the install commands for ctrl+p

```
ext install vscodevim.vim
```

```
ext install arcticicestudio.nord-visual-studio-code
```

```
ext install vscode-icons-team.vscode-icons
```

```
ext install ms-azuretools.vscode-docker
```

```
ext ms-vscode-remote.remote-containers
```

```
ext mhutchie.git-graph
```

### Update the comment colors in nord theme
Open ~/.vscode/extensions/arcticicestudio.nord-visual-studio-code-0.19.0/themes/nord-color-theme.json

Find two entries "name": "Comment" & "Punctuation Definition Comment"
Update their "foreground": entry to "#B48EAD"

### Configure settings.json

Feel free to delete the javascript, python entries if you aren't using those languages.

```json
{
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "Nord",
  "editor.fontFamily": "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'",
  "terminal.integrated.fontFamily": "Courier, MesloLGS NF",
  "vim.camelCaseMotion.enable": true,
  "vim.surround": true,
  "vim.easymotion": true,
  "vim.leader": "<space>",
  "vim.replaceWithRegister": true,
  "vim.useSystemClipboard": true,
  "vim.useCtrlKeys": true,
  "vim.smartRelativeLine": true,
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.bracketPairColorization.enabled": true,
  "vim.normalModeKeyBindingsNonRecursive": [
    {
      "before": ["<leader>", "s"],
      "commands": ["workbench.action.toggleSidebarVisibility"]
    },
    {
      "before": ["<leader>", "z"],
      "commands": ["workbench.action.focusSideBar"]
    },
    {
      "before": ["<leader>", "f"],
      "commands": [ "revealInExplorer" ],
    },
    {
      "before": ["<leader>", "d", "b"],
      "commands": [ "editor.debug.action.toggleBreakpoint" ]
    },
    {
      "before": ["<leader>", "d", "B"],
      "commands": [ "editor.debug.action.conditionalBreakpoint" ]
    },
    {
      "before": ["<leader>", "d", "C"],
      "commands": [ "editor.debug.action.runToCursor" ]
    },
    {
      "before": ["<leader>", "d", "d"],
      "commands": [ "workbench.action.debug.continue" ]
    },
    {
      "before": ["<leader>", "d", "j"],
      "commands": [ "workbench.action.debug.stepOver" ]
    },
    {
      "before": ["<leader>", "d", "l"],
      "commands": [ "workbench.action.debug.stepInto" ]
    },
    {
      "before": ["<leader>", "d", "h"],
      "commands": [ "workbench.action.debug.stepOut" ]
    },
    {
      "before": ["<leader>", "d", "p"],
      "commands": [ "workbench.action.debug.pause" ]
    },
    {
      "before": ["<leader>", "d", "r"],
      "commands": [ "workbench.action.debug.restart" ]
    },
    {
      "before": ["<leader>", "d", "s"],
      "commands": [ "workbench.action.debug.stop" ]
    },
    {
      "before": ["<leader>", "d", "c"],
      "commands": [ "workbench.panel.repl.view.focus" ]
    },
    {
      "before": ["<leader>", "d", "t"],
      "commands": [ "terminal.focus" ]
    },
    {
      "before": ["<leader>", "d", "o"],
      "commands": [ "workbench.panel.output.focus" ]
    },
    {
      "before": [ "<leader>", "g", "g" ],
      "commands": [ "git-graph.view" ]
    },
    {
      "before": ["<leader>", "m"],
      "commands": [ "workbench.action.togglePanel" ]
    },
    {
      "before": [ "d", "i", "l" ],
      "after": [ "^", "d", "g", "_" ]
    },
    {
      "before": [ "y", "i", "l" ],
      "after": [ "^", "y", "g", "_" ]
    },
    {
      "before": [ "d", "a", "l" ],
      "after": [ "0", "d", "$" ]
    },
    {
      "before": [ "y", "a", "l" ],
      "after": [ "0", "y", "$" ]
    },
    {
      "before": ["K"],
       "commands": "editor.action.showHover",
       "when": "editorTextFocus"
    },
    {
      "before": ["K"],
      "commands": "editor.debug.action.showDebugHover",
      "when": "editorTextFocus && inDebugMode"
    },
    {
      "before": ["u"],
      "commands": ["undo"]
    },
    {
      "before": ["<C-r>"],
      "commands": ["redo"]
    }
  ],
  "vim.visualModeKeyBindingsNonRecursive": [
    {
      "before": [">"],
      "after": [">", "g", "v"]
    },
    {
      "before": ["<"],
      "after": ["<", "g" ,"v"]
    },
    {
      "before": ["ctrl+r", "m"],
      "commands": [ {
        "command": "editor.action.codeAction",
        "args": {
          "kind": "refactor.extract.function"
        },
      }]
    },
    {
      "before": ["ctrl+r", "c"],
      "commands": [ {
        "command": "editor.action.codeAction",
        "args": {
          "kind": "refactor.extract.constant",
          "preferred": true,
          "apply": "ifsingle"
        },
      }]
    },
    {
      "before": ["ctrl+r", "g"],
      "commands": [ {
        "command": "editor.action.codeAction",
        "args": {
          "kind": "refactor.extract.constant",
          "preferred": false,
          "apply": "ifsingle"
        },
      }]
    },
  ],
}
```

If using Flatpak and zsh you'll need to change terminal settings or zsh won't work

```json
    "terminal.integrated.defaultProfile.linux": "bash",
    "terminal.integrated.profiles.linux": {
      "bash": {
        "path": "/usr/bin/flatpak-spawn",
        "args": ["--host", "--env=TERM=xterm-256color", "zsh"]
      }
    },
```

#### Configure keybindings.json (Probably only necessary on Linux. Linux defaults are weird. Make them better match Windows.)

Because vim has taken over normal Cut/Copy/Pase use these if you need non-vim cut/copy/paste and you're having trouble with Ctrl+C/X/V (though there's an entry below to compensate). 

- Ctrl+Insert instaed of Ctrl+C
- Shift+Insert instead of Ctrl+V
- Shift+Delete instead of Ctrl+X

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

If using vscode-vim, put in some keybindings to make it work better
```json
   {
        "key": "r",
        "command": "renameFile",
        "when": "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus"
    },
    {
        "key": "d",
        "command": "deleteFile",
        "when": "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus"
    },
    {
        "key": "c",
        "command": "filesExplorer.copy",
        "when": "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus"
    },
    {
        "key": "p",
        "command": "filesExplorer.paste",
        "when": "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus"
    },
    {
        "key": "a",
        "command": "workbench.files.action.createFileFromExplorer",
        "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
    },
    {
        "key": "shift+a",
        "command": "workbench.files.action.createFolderFromExplorer",
        "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
    },
    {
        "key": "shift+y",
        "command": "copyFilePath",
        "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
    },
    {
        "key": "ctrl+y",
        "command": "copyRelativeFilePath",
        "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
    },
    {
      "key": "shift+w",
      "command": "workbench.files.action.collapseExplorerFolders",
      "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
    },
    {
        "key": "ctrl+k",
        "command": "workbench.action.navigateUp"
    },
    {
        "key": "ctrl+j",
        "command": "workbench.action.navigateDown"
    },
    {
        "key": "ctrl+h",
        "command": "workbench.action.navigateLeft"
    },
    {
        "key": "ctrl+l",
        "command": "workbench.action.navigateRight"
    },
    {
      "key": "shift+l",
      "command": "workbench.action.nextEditor",
      "when": "editorFocus && vim.mode == 'Normal'"
    },
    {
      "key": "shift+h",
      "command": "workbench.action.previousEditor",
      "when": "editorFocus && vim.mode == 'Normal'"
    },
    {
        "key": "alt+k",
        "command": "editor.action.moveLinesUpAction",
        "when": "editorTextFocus && !editorReadonly && vim.mode == 'Visual'"
    },
    {
        "key": "alt+k",
        "command": "editor.action.moveLinesUpAction",
        "when": "editorTextFocus && !editorReadonly && vim.mode == 'VisualLine'"
    },
    {
        "key": "alt+k",
        "command": "editor.action.moveLinesUpAction",
        "when": "editorTextFocus && !editorReadonly && vim.mode == 'VisualBlock'"
    },
    {
        "key": "alt+j",
        "command": "editor.action.moveLinesDownAction",
        "when": "editorTextFocus && !editorReadonly && vim.mode == 'Visual'"
    },
    {
        "key": "alt+j",
        "command": "editor.action.moveLinesDownAction",
        "when": "editorTextFocus && !editorReadonly && vim.mode == 'VisualLine'"
    },
    {
        "key": "alt+j",
        "command": "editor.action.moveLinesDownAction",
        "when": "editorTextFocus && !editorReadonly && vim.mode == 'VisualBlock'"
    },
    {
        "key": "shift+win+i",
        "command": "workbench.action.inspectContextKeys"
    },
    {
      "key": "ctrl+c",
      "command": "editor.action.clipboardCopyAction",
      "when": "editorTextFocus && vim.mode != 'Normal'"
    },
    {
      "key": "ctrl+v",
      "command": "editor.action.clipboardPasteAction",
      "when": "editorTextFocus && vim.mode != 'Normal'"
    },
    {
      "key": "ctrl+x",
      "command": "editor.action.clipboardCutAction",
      "when": "editorTextFocus && vim.mode != 'Normal'"
    },
    {
      "key": "ctrl+a",
      "command": "editor.action.selectAll",
      "when": "editorTextFocus && vim.mode != 'Normal'"
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

If you want a generic sample click the Remote Status bar icon (lower left) and choose "Try Development Container Sample" and choose Node

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