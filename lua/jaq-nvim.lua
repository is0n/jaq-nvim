local M = {}
local vim = vim

local defaults = {
	mapping = "<Leader>r",
	run_on_save = false,
	cmds = { lua = "!lua %", python = "!python3 %", javascript = "!node %", typescript = "!node %", markdown = "Glow", vim = "source %", sh = "!sh %"}
}

function M.setup(user_options) defaults = vim.tbl_deep_extend('force', defaults, user_options) end

function M.jaq()
	for lang, cmds in next, defaults.cmds, nil do vim.cmd ("autocmd FileType " .. lang .. " :command! -buffer Jaq :" .. cmds) end
	if defaults.run_on_save == true then vim.cmd("autocmd BufWritePost * Jaq") end
	vim.api.nvim_set_keymap("n", defaults.mapping, ":Jaq<CR>", { silent = true } )
end
return M
