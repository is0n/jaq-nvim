[![GitHub Stars](https://img.shields.io/github/stars/is0n/jaq-nvim.svg?style=social&label=Star&maxAge=2592000)](https://github.com/is0n/jaq-nvim/stargazers/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Last Commit](https://img.shields.io/github/last-commit/is0n/jaq-nvim)](https://github.com/is0n/jaq-nvim/pulse)
[![GitHub Open Issues](https://img.shields.io/github/issues/is0n/jaq-nvim.svg)](https://github.com/is0n/jaq-nvim/issues/)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed/is0n/jaq-nvim.svg)](https://github.com/is0n/jaq-nvim/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub License](https://img.shields.io/github/license/is0n/jaq-nvim?logo=GNU)](https://github.com/is0n/jaq-nvim/blob/master/LICENSE)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?logo=lua&logoColor=white)](https://github.com/is0n/fm-nvim/search?l=lua)

<h1 align='center'>jaq-nvim</h1>

`jaq-nvim` is **J**ust **A**nother **Q**uickrun plugin for Neovim that was inspired by [quickrun.vim](https://github.com/D0n9X1n/quickrun.vim). In short, it is a plugin that lets you run the code of any language with a single command.

## Demo:

![Demo](https://user-images.githubusercontent.com/57725322/143307370-861066e8-cae0-4641-8185-25c031baafbb.gif)

<p>
<details>
<summary>Screenshots</summary>

##### Run C++ Code w/ :Jaq Bang

![Jaq Bang](https://user-images.githubusercontent.com/57725322/143304594-45df53fc-8aeb-424b-b688-70779b7c9533.png)

##### Run C++ Code w/ :Jaq Float

![Jaq Float](https://user-images.githubusercontent.com/57725322/143304610-053d2593-53a9-4839-9bb3-c61e0de66022.png)

##### Run C++ Code w/ :Jaq Term

![Jaq Term](https://user-images.githubusercontent.com/57725322/143304617-b0d13aa6-368a-4968-8b89-909d6ddbcf60.png)

</details>
</p>

## Installation:

- [packer.nvim](https://github.com/wbthomason/packer.nvim):
  ```lua
  use {'is0n/jaq-nvim'}
  ```

## Configuration:

The following is an example config...

```lua
require('jaq-nvim').setup{
	-- Commands used with 'Jaq'
	cmds = {
		-- Default UI used (see `Usage` for options)
		default = "float",

		-- Uses external commands such as 'g++' and 'cargo'
		external = {
			typescript = "deno run %",
			javascript = "node %",
			markdown = "glow %",
			python = "python3 %",
			rust = "rustc % && ./$fileBase && rm $fileBase",
			cpp = "g++ % -o $fileBase && ./$fileBase",
			go = "go run %",
			sh = "sh %",
		},

		-- Uses internal commands such as 'source' and 'luafile'
		internal = {
			lua = "luafile %",
			vim = "source %"
		}
	},

	-- UI settings
	ui = {
		-- Start in insert mode
		startinsert = false,

		-- Switch back to current file
		-- after using Jaq
		wincmd      = false,

                -- Auto-save the current file
                -- before executing it
                autosave    = true,

		-- Floating Window / FTerm settings
		float = {
			-- Floating window border (see ':h nvim_open_win')
			border    = "none",

			-- Num from `0 - 1` for measurements
			height    = 0.8,
			width     = 0.8,
			x         = 0.5,
			y         = 0.5,

			-- Highlight group for floating window/border (see ':h winhl')
			border_hl = "FloatBorder",
			float_hl  = "Normal",

			-- Floating Window Transparency (see ':h winblend')
			blend     = 0
		},

		terminal = {
			-- Position of terminal
			position = "bot",

			-- Open the terminal without line numbers
			line_no = false,

			-- Size of terminal
			size     = 10
		},

		toggleterm = {
			-- Position of terminal, one of "vertical" | "horizontal" | "window" | "float"
			position = "horizontal",

			-- Size of terminal
			size     = 10
		},

		quickfix = {
			-- Position of quickfix window
			position = "bot",

			-- Size of quickfix window
			size     = 10
		}
	}
}
```

## Usage:

`:Jaq` by default uses the `float` option to run code, however, both `bang` and `term` are appropriate terms. Append any of the following terms to the end of `:Jaq` to override the default value.

- `float` • opens a floating window with `:lua vim.api.nvim_open_win()`
- `quickfix` / `qf` • command output is placed in a quickfix
- `term` • opens a terminal with `:terminal`
- `fterm` •  opens a terminal using a new FTerm from [numToStr/FTerm.nvim](https://github.com/numToStr/FTerm.nvim)
- `toggleterm` • opens a terminal using :TermExec from [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- `bang` • opens a small window with `:!`
- `internal` • runs a vim command

Example: `:Jaq bang`

The commands for `:Jaq` also have certain variables that can help in running code. You can put any of the following in your `require('jaq-nvim').setup()`...

- `%` • Current File
- `$file` • Current File
- `$filePath` • Path to Current File
- `$fileBase` • Basename of File (no extension)
- `$altFile` • Alternate File
- `$dir` • Current Working Directory (CWD)
- `$moduleName` • Python Module Name

## Similar Plugins:

- [pianocomposer321/yabs.nvim](https://github.com/pianocomposer321/yabs.nvim) • "Yet Another Build System for Neovim, written in Lua."
- [CRAG666/code_runner.nvim](https://github.com/CRAG666/code_runner.nvim) • "The best code runner you could have [...]"

<div align="center" id="madewithlua">

[![Lua](https://img.shields.io/badge/Made%20with%20Lua-blue.svg?style=for-the-badge&logo=lua)](#madewithlua)

</div>
