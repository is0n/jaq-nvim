[![GitHub Stars](https://img.shields.io/github/stars/is0n/jaq-nvim.svg?style=social&label=Star&maxAge=2592000)](https://github.com/is0n/jaq-nvim/stargazers/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Last Commit](https://img.shields.io/github/last-commit/is0n/jaq-nvim)](https://github.com/is0n/jaq-nvim/pulse)
[![GitHub Open Issues](https://img.shields.io/github/issues/is0n/jaq-nvim.svg)](https://github.com/is0n/jaq-nvim/issues/)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed/is0n/jaq-nvim.svg)](https://github.com/is0n/jaq-nvim/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub Contributors](https://img.shields.io/github/contributors/is0n/jaq-nvim.svg)](https://github.com/is0n/jaq-nvim/graphs/contributors/)
[![GitHub](https://img.shields.io/github/license/is0n/jaq-nvim?logo=GNU)](https://github.com/is0n/jaq-nvim/blob/master/LICENSE)

# jaq-nvim
`jaq-nvim` is just another quickrun plugin for Neovim that's written in less than **20 lines of Lua**. Inspired by [quickrun.vim](https://github.com/D0n9X1n/quickrun.vim).

## Demo:
![Demo](Demo.gif)

## Installation:
* [packer.nvim](https://github.com/wbthomason/packer.nvim):
	```lua
	use {'is0n/jaq-nvim'}
	```
* [vim-plug](https://github.com/junegunn/vim-plug):
	```vim
	Plug 'is0n/jaq-nvim'
	```
* [Vundle](https://github.com/VundleVim/Vundle.vim)
	```vim
	Plugin 'is0n/jaq-nvim'
	```
* [NeoBundle](https://github.com/Shougo/neobundle.vim)
	```vim
	NeoBundle 'is0n/jaq-nvim'
	```

## Configuration:
```lua
require('jaq-nvim').setup{
	-- Mapping used to run :Jaq
	mapping = "<Leader>r",

	-- Set to true if you want Jaq to run after :w
	run_on_save = false

	-- Put the name of the language first and then the commands you want to use
	cmds = {
		-- Example
		ruby = "!ruby %"
	}
}
```

## Usage:
You can either use the default mapping `<Leader>r` to run Jaq or simply type in `:Jaq`.

<div align="center" id="madewithlua">
	
[![Lua](https://img.shields.io/badge/Made%20with%20Lua-blue.svg?style=for-the-badge&logo=lua)](#madewithlua)
	
</div>
