local M = {}

local config = {
  cmds = {},

  behavior = {
    default     = "float",
    startinsert = false,
    wincmd      = false,
    autosave    = false
  },

  ui = {
    float = {
      border   = "none",
      winhl    = "Normal",
      borderhl = "FloatBorder",
      height   = 0.8,
      width    = 0.8,
      x        = 0.5,
      y        = 0.5,
      winblend = 0
    },

    terminal = {
      position = "bot",
      line_no  = false,
      size     = 10
    },

    quickfix = {
      position = "bot",
      size     = 10
    }
  }
}

function M.setup(user_opts)
  config = vim.tbl_deep_extend("force", config, user_opts)
end

local function dimensions(opts)
  local cl = vim.o.columns
  local ln = vim.o.lines

  local width = math.ceil(cl * opts.ui.float.width)
  local height = math.ceil(ln * opts.ui.float.height - 4)

  local col = math.ceil((cl - width) * opts.ui.float.x)
  local row = math.ceil((ln - height) * opts.ui.float.y - 1)

  return {
    width = width,
    height = height,
    col = col,
    row = row
  }
end

local function resize()
  local dim = dimensions(config)
  vim.api.nvim_win_set_config(M.win, {
    style    = "minimal",
    relative = "editor",
    border   = config.ui.float.border,
    height   = dim.height,
    width    = dim.width,
    col      = dim.col,
    row      = dim.row
  })
end

local function float(cmd)
  local dim = dimensions(config)

  function M.VimResized()
    resize()
  end

  M.buf = vim.api.nvim_create_buf(false, true)
  M.win = vim.api.nvim_open_win(M.buf, true, {
    style    = "minimal",
    relative = "editor",
    border   = config.ui.float.border,
    height   = dim.height,
    width    = dim.width,
    col      = dim.col,
    row      = dim.row
  })

  vim.api.nvim_win_set_option(M.win, "winhl", ("Normal:%s"):format(config.ui.float.winhl))
  vim.api.nvim_win_set_option(M.win, "winhl", ("FloatBorder:%s"):format(config.ui.float.borderhl))
  vim.api.nvim_win_set_option(M.win, "winblend", config.ui.float.winblend)

  vim.api.nvim_buf_set_option(M.buf, "filetype", "Jaq")
  vim.api.nvim_buf_set_keymap(M.buf, 'n', '<ESC>', '<cmd>:lua vim.api.nvim_win_close(' .. M.win .. ', true)<CR>',
    { silent = true })

  vim.fn.termopen(cmd)

  vim.cmd("autocmd! VimResized * lua require('jaq-nvim').VimResized()")

  if config.behavior.startinsert then
    vim.cmd("startinsert")
  end

  if config.behavior.wincmd then
    vim.cmd("wincmd p")
  end
end

local function term(cmd)
  vim.cmd(config.ui.terminal.position .. " " .. config.ui.terminal.size .. "new")

  vim.fn.termopen(cmd)

  M.buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_option(M.buf, "filetype", "Jaq")
  vim.api.nvim_buf_set_keymap(M.buf, 'n', '<ESC>', '<cmd>:bdelete!<CR>', { silent = true })

  if config.behavior.startinsert then
    vim.cmd("startinsert")
  end

  if not config.ui.terminal.line_no then
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end

  if config.behavior.wincmd then
    vim.cmd("wincmd p")
  end
end

local function quickfix(cmd)
  vim.cmd(
    'cex system("' .. cmd .. '") | ' ..
    config.ui.quickfix.position ..
    ' copen ' ..
    config.ui.quickfix.size)

  if config.behavior.wincmd then
    vim.cmd("wincmd p")
  end
end

-- HUUUUUUUUUUUUUUUUUUUUUUUGE kudos and thanks to
-- https://github.com/hown3d for this function <3
local function substitute(cmd)
  cmd = cmd:gsub("%%", vim.fn.expand('%'));
  cmd = cmd:gsub("$fileBase", vim.fn.expand('%:r'));
  cmd = cmd:gsub("$filePath", vim.fn.expand('%:p'));
  cmd = cmd:gsub("$file", vim.fn.expand('%'));
  cmd = cmd:gsub("$dir", vim.fn.expand('%:p:h'));
  cmd = cmd:gsub("$moduleName",
    vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand("%:r"), ":~:."), "/", ".", "g"), "\\", ".",
      "g"));
  cmd = cmd:gsub("#", vim.fn.expand('#'))
  cmd = cmd:gsub("$altFile", vim.fn.expand('#'))

  return cmd
end

local function run(type, cmd)
  cmd = cmd or config.cmds[vim.bo.filetype]

  if not cmd then
    error("Jaq-nvim: Invalid command")
  end

  if config.behavior.autosave then
    vim.cmd("silent write")
  end

  -- Check if the command is an internal command
  -- by looking if the first character is a ':'
  if cmd:sub(1, 1) == ":" then
    type = "internal"
  end

  cmd = substitute(cmd)

  if type == "float" then
    float(cmd)
  elseif type == "bang" then
    vim.cmd("!" .. cmd)
  elseif type == "quickfix" then
    quickfix(cmd)
  elseif type == "terminal" then
    term(cmd)
  elseif type == "internal" then
    vim.cmd(cmd)
  else
    error("Jaq-nvim: Invalid type")
  end
end

local function project(type, file)
  local json = file:read("*a")
  local status, table = pcall(vim.fn.json_decode, json)
  io.close(file)

  if not status then
    error("Jaq-nvim: Invalid json")
    return
  end

  local cmd = table.cmds[vim.bo.filetype]
  cmd = substitute(cmd)

  run(type, cmd)
end

function M.Jaq(type)
  local file = io.open(vim.fn.expand('%:p:h') .. "/.jaq.json", "r")

  type = type or config.behavior.default

  if file then
    project(type, file)
    return
  end

  run(type)
end

return M
