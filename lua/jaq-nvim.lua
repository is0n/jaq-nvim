local M = {}

local config = {
	cmds = {
		default  = "float",
		internal = {},
		external = {},
	},
	ui = {
		startinsert = false,
		wincmd      = false,
		float = {
			border    = "none",
			height    = 0.8,
			width     = 0.8,
			x         = 0.5,
			y         = 0.5,
			border_hl = "FloatBorder",
			float_hl  = "Normal",
			blend     = 0
		},
		terminal = {
			position = "bot",
			line_no  = false,
			size     = 10
		},
		toggleterm = {
			position = "horizontal",
			size     = 10
		},
		quickfix = {
			position = "bot",
			size = 10
		}
	}
}

local function floatingWin(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<C-\\><C-n>:lua vim.api.nvim_win_close(win, true)<CR>', { silent = true })
	vim.api.nvim_buf_set_option(buf, 'filetype', 'Jaq')
	local win_height = math.ceil(vim.api.nvim_get_option("lines") * config.ui.float.height - 4)
	local win_width = math.ceil(vim.api.nvim_get_option("columns") * config.ui.float.width)
	local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) * config.ui.float.y - 1)
	local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) * config.ui.float.x)
	local opts = { style = "minimal", relative = "editor", border = config.ui.float.border, width = win_width, height = win_height, row = row, col = col }
	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.fn.termopen(cmd)
	if config.ui.startinsert then vim.cmd("startinsert") end
	if config.ui.wincmd then vim.cmd("wincmd p") end
	vim.api.nvim_win_set_option(win, 'winhl', 'Normal:' .. config.ui.float.float_hl .. ',FloatBorder:' .. config.ui.float.border_hl)
	vim.api.nvim_win_set_option(win, 'winblend', config.ui.float.blend)
end

function M.setup(user_options) config = vim.tbl_deep_extend('force', config, user_options) end

local function internal()
	local cmd = config.cmds.internal[vim.bo.filetype]
	if cmd ~= nil then
		cmd = cmd:gsub("%%", vim.fn.expand('%')); cmd = cmd:gsub("$fileBase", vim.fn.expand('%:r')); cmd = cmd:gsub("$filePath", vim.fn.expand('%:p')); cmd = cmd:gsub("$file", vim.fn.expand('%')); cmd = cmd:gsub("$dir", vim.fn.expand('%:p:h')); cmd = cmd:gsub("$moduleName", vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand("%:r"), ":~:."), "/", ".", "g"), "\\", ".", "g")); cmd = cmd:gsub("$altFile", vim.fn.expand('#'))
		vim.cmd(cmd)
	else
		vim.cmd("echohl ErrorMsg | echo 'Error: Invalid command' | echohl None")
	end
end

local function run(type)
	local cmd = config.cmds.external[vim.bo.filetype]
	if cmd ~= nil then
		cmd = cmd:gsub("%%", vim.fn.expand('%')); cmd = cmd:gsub("$fileBase", vim.fn.expand('%:r')); cmd = cmd:gsub("$filePath", vim.fn.expand('%:p')); cmd = cmd:gsub("$file", vim.fn.expand('%')); cmd = cmd:gsub("$dir", vim.fn.expand('%:p:h')); cmd = cmd:gsub("$moduleName", vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand("%:r"), ":~:."), "/", ".", "g"), "\\", ".", "g")); cmd = cmd:gsub("$altFile", vim.fn.expand('#'))
		if type == "float" then
			floatingWin(cmd)
		elseif type == "bang" then
			vim.cmd("!" .. cmd)
		elseif type == "quickfix" or type == "qf" then
			vim.cmd('cex system("' .. cmd .. '") | ' .. config.ui.quickfix.position .. ' copen ' .. config.ui.quickfix.size)
			if config.ui.wincmd then vim.cmd("wincmd p") end
		elseif type == "term" or type == "terminal" then
			local buf = vim.cmd(config.ui.terminal.position .. " " .. config.ui.terminal.size .. "new | term " .. cmd)
			vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<C-\\><C-n>:bdelete!<CR>', { silent = true })
			vim.api.nvim_buf_set_option(buf, 'filetype', 'Jaq')
			if config.ui.startinsert then vim.cmd("startinsert") end
			if config.ui.wincmd then vim.cmd("wincmd p") end
			if not config.ui.terminal.line_no then vim.cmd("setlocal nonumber") vim.cmd("setlocal norelativenumber") end
		elseif type == "toggleterm" then
			vim.cmd('TermExec cmd="' .. cmd .. '" size=' .. config.ui.toggleterm.size .. " direction=" .. config.ui.toggleterm.position)
			if config.ui.startinsert then vim.cmd("startinsert") end
			if config.ui.wincmd then vim.cmd("wincmd p") end
		elseif type == "fterm" then
			require("FTerm"):new({
				cmd = cmd,
				blend = config.ui.float.blend,
				auto_close = false,
				dimensions = { height = config.ui.float.height, width = config.ui.float.width, x = config.ui.float.x, y = config.ui.float.y },
				border = config.ui.float.border,
				hl = config.ui.float.float_hl
			}):open()
		end
	else
		vim.cmd("echohl ErrorMsg | echo 'Error: Invalid command' | echohl None")
	end
end

function M.Jaq(type)
	type = type or config.cmds.default
	if type == "internal" then
		internal()
	else
		run(type)
	end
end

return M
