local M = {}
local vim = vim

local config = {
	cmds = {
		default  = "float",
		internal = {},
		external = {}
	},
	ui = {
		startinsert = false,
		float = {
			border    = "none",
			height    = 0.8,
			width     = 0.8,
			border_hl = "FloatBorder",
			float_hl  = "Normal",
			blend     = 0
		},
		terminal = {
			position = "bot",
			size     = 10
		}
	}
}

local function floatingWin(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<C-\\><C-n>:lua vim.api.nvim_win_close(win, true)<CR>', { silent = true })
	vim.api.nvim_buf_set_keymap(buf, 'n', 'gf', '<C-w>gf', { silent = true })
	vim.api.nvim_buf_set_option(buf, 'filetype', 'Jaq')
	local win_height = math.ceil(vim.api.nvim_get_option("lines") * config.ui.float.height - 4)
	local win_width = math.ceil(vim.api.nvim_get_option("columns") * config.ui.float.width)
	local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) / 2 - 1)
	local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) / 2)
	local opts = { style = "minimal", relative = "editor", border = config.ui.float.border, width = win_width, height = win_height, row = row, col = col }
	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.fn.termopen(cmd)
	if config.ui.startinsert then vim.cmd("startinsert") end
	vim.api.nvim_win_set_option(win, 'winhl', 'Normal:' .. config.ui.float.float_hl .. ',FloatBorder:' .. config.ui.float.border_hl)
	vim.api.nvim_win_set_option(win, 'winblend', config.ui.float.blend)
end

function M.setup(user_options) config = vim.tbl_deep_extend('force', config, user_options) end

function M.Jaq(type)
	local ran = false
	for lang, cmd in next, config.cmds.internal, nil do
		if vim.bo.filetype == lang then
			cmd = cmd:gsub("%%", vim.fn.expand('%'))
			cmd = cmd:gsub("#", vim.fn.expand('#'))
			cmd = cmd:gsub("$fileBase", vim.fn.expand('%:r'))
			cmd = cmd:gsub("$filePath", vim.fn.expand('%:p'))
			cmd = cmd:gsub("$fileAlt", vim.fn.expand('#'))
			cmd = cmd:gsub("$file", vim.fn.expand('%'))
			cmd = cmd:gsub("$dir", vim.fn.expand('%:p:h'))
			vim.cmd(cmd)
			ran = true
			break
		end
	end
	type = type or config.cmds.default
	for lang, cmd in next, config.cmds.external, nil do
		if vim.bo.filetype == lang then
			cmd = cmd:gsub("%%", vim.fn.expand('%'))
			cmd = cmd:gsub("#", vim.fn.expand('#'))
			cmd = cmd:gsub("$fileBase", vim.fn.expand('%:r'))
			cmd = cmd:gsub("$file", vim.fn.expand('%'))
			cmd = cmd:gsub("$fileAlt", vim.fn.expand('#'))
			cmd = cmd:gsub("$dir", vim.fn.expand('%:p:h'))
			if type == "float" then
				floatingWin(cmd)
				ran = true
				break
			elseif type == "bang" then
				vim.cmd("!" .. cmd)
				ran = true
				break
			elseif type == "term" then
				local buf = vim.cmd(config.ui.terminal.position .. " " .. config.ui.terminal.size .. "new | term " .. cmd)
				vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<C-\\><C-n>:bdelete!<CR>', { silent = true })
				vim.api.nvim_buf_set_option(buf, 'filetype', 'Jaq')
				if config.ui.startinsert then vim.cmd("startinsert") end
				ran = true
				break
			end
		end
	end
	if not ran then vim.cmd("echohl ErrorMsg | echo 'Error: No config for " .. vim.bo.filetype .. "' | echohl None") end
end

return M
