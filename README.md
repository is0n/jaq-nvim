<img src="https://img.shields.io/github/stars/is0n/jaq-nvim.svg?style=for-the-badge&label=stars" align="left"/>
<img src="https://img.shields.io/github/license/is0n/jaq-nvim?style=for-the-badge&logo=GNU" align="right"/>

<h1 align='center'>jaq-nvim</h1>

`jaq-nvim` is **J**ust **A**nother **Q**uickrun plugin for Neovim that was inspired by [quickrun.vim](https://github.com/D0n9X1n/quickrun.vim). In short, it is a plugin that lets you run the code of any language with a single command.

## Demo:

| Type Info                                                                      | Demonstration                                                                                                      |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| <ins>Internal:</ins> <br/> Runs a vim command using `:`.                       | ![Internal](https://user-images.githubusercontent.com/57725322/178857660-6e0f9eff-cef2-47c6-85f0-4696697e95d7.png) |
| <ins>Float:</ins> <br/> Opens a floating window with `vim.api.nvim_open_win()` | ![Float](https://user-images.githubusercontent.com/57725322/178857665-a771d37c-b705-4bd2-99f6-9812bb37a898.png)    |
| <ins>Terminal:</ins> <br/> Opens a terminal with `:terminal`                   | ![Terminal](https://user-images.githubusercontent.com/57725322/178857666-8536e793-3977-4a10-a611-a3aaec975870.png) |
| <ins>Bang:</ins> <br/> Opens a small window with `:!`                          | ![Bang](https://user-images.githubusercontent.com/57725322/178857662-fe4d133f-24d2-4298-89fd-fd9fc3fbf326.png)     |
| <ins>Quickfix:</ins> <br/> Command output is placed in a quickfix window       | ![Quickfix](https://user-images.githubusercontent.com/57725322/178857664-1d6593be-2ea6-4a00-9531-36b3a097a02a.png) |

## Installation:

#### [packer.nvim](https://github.com/wbthomason/packer.nvim):
  ```lua
  use {"is0n/jaq-nvim"}
  ```

## Example Lua Config:
```lua
require('jaq-nvim').setup{
  cmds = {
    -- Uses vim commands
    internal = {
      lua = "luafile %",
      vim = "source %"
    },

    -- Uses shell commands
    external = {
      markdown = "glow %",
      python   = "python3 %",
      go       = "go run %",
      sh       = "sh %"
    }
  },

  behavior = {
    -- Default type
    default     = "float",

    -- Start in insert mode
    startinsert = false,

    -- Use `wincmd p` on startup
    wincmd      = false,

    -- Auto-save files
    autosave    = false
  },

  ui = {
    float = {
      -- See ':h nvim_open_win'
      border    = "none",

      -- See ':h winhl'
      winhl     = "Normal",
      borderhl  = "FloatBorder",

      -- See ':h winblend'
      winblend  = 0,

      -- Num from `0-1` for measurements
      height    = 0.8,
      width     = 0.8,
      x         = 0.5,
      y         = 0.5
    },

    terminal = {
      -- Window position
      position = "bot",

      -- Window size
      size     = 10

      -- Disable line numbers
      line_no  = false,
    },

    quickfix = {
      -- Window position
      position = "bot",

      -- Window size
      size     = 10
    }
  }
```

## Example JSON Config:
```json
{
  "internal": {
    "lua": "luafile %",
    "vim": "source %"
  },

  "external": {
    "markdown": "glow %",
    "python": "python3 %",
    "go": "go run %",
    "sh": "sh %"
  }
}
```

In the current working directory, `Jaq` will search for a file called `.jaq.json`.

This config file will be used for running commands, both external and internal.

## Usage:

`:Jaq` by default uses the `float` type to run code. The default can be changed (see `Example Lua Config`).

To use any other type, provide any of the arguments seen in `Demonstration`.

Example: `:Jaq bang`

The commands for `:Jaq` also have certain variables that can help in running code.

You can put any of the following in `require('jaq-nvim').setup()` or `.jaq.json` ...
- `%` / `$file`    • Current File
- `#` / `$altFile` • Alternate File
- `$dir`           • Current Working Directory
- `$filePath`      • Path to Current File
- `$fileBase`      • Basename of File (no extension)
- `$moduleName`    • Python Module Name

<div align="center" id="madewithlua">

[![Lua](https://img.shields.io/badge/Made%20with%20Lua-blue.svg?style=for-the-badge&logo=lua)](#madewithlua)

</div>
