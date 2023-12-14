local M = {}

local config = {
    cmds = {
        internal = {},
        external = {},
    },

    behavior = {
        default = "float",
        startinsert = false,
        wincmd = false,
        autosave = false,
    },

    ui = {
        float = {
            border = "none",
            winhl = "Normal",
            borderhl = "FloatBorder",
            height = 0.8,
            width = 0.8,
            x = 0.5,
            y = 0.5,
            winblend = 0,
        },

        terminal = {
            position = "bot",
            line_no = false,
            size = 10,
        },

        quickfix = {
            position = "bot",
            size = 10,
        },
    },
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
        row = row,
    }
end

local function resize()
    local dim = dimensions(config)
    vim.api.nvim_win_set_config(M.win, {
        style = "minimal",
        relative = "editor",
        border = config.ui.float.border,
        height = dim.height,
        width = dim.width,
        col = dim.col,
        row = dim.row,
    })
end

local function float(cmd)
    local dim = dimensions(config)

    function M.VimResized()
        resize()
    end

    M.buf = vim.api.nvim_create_buf(false, true)
    M.win = vim.api.nvim_open_win(M.buf, true, {
        style = "minimal",
        relative = "editor",
        border = config.ui.float.border,
        height = dim.height,
        width = dim.width,
        col = dim.col,
        row = dim.row,
    })

    vim.api.nvim_set_option_value("winhl", ("Normal:%s"):format(config.ui.float.winhl), { win = M.win })
    vim.api.nvim_set_option_value("winhl", ("FloatBorder:%s"):format(config.ui.float.borderhl), { win = M.win })
    vim.api.nvim_set_option_value("winblend", config.ui.float.winblend, { win = M.win })

    vim.api.nvim_set_option_value("filetype", "Jaq", { buf = M.buf })

    vim.api.nvim_buf_set_keymap(
        M.buf,
        "n",
        "<ESC>",
        "<cmd>:lua vim.api.nvim_win_close(" .. M.win .. ", true)<CR>",
        { silent = true }
    )

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
    vim.cmd(config.ui.terminal.position .. " " .. config.ui.terminal.size .. "new | term " .. cmd)

    M.buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value("filetype", "Jaq", { buf = M.buf })
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<ESC>", "<cmd>:bdelete!<CR>", { silent = true })

    if config.behavior.startinsert then
        vim.cmd("startinsert")
    end

    if not config.ui.terminal.line_no then
        vim.cmd("setlocal nonumber | setlocal norelativenumber")
    end

    if config.behavior.wincmd then
        vim.cmd("wincmd p")
    end
end

local function quickfix(cmd)
    vim.cmd('cex system("' .. cmd .. '") | ' .. config.ui.quickfix.position .. " copen " .. config.ui.quickfix.size)

    if config.behavior.wincmd then
        vim.cmd("wincmd p")
    end
end

-- HUUUUUUUUUUUUUUUUUUUUUUUGE kudos and thanks to
-- https://github.com/hown3d for this function <3
local function substitute(cmd)
    cmd = cmd:gsub("%%", vim.fn.expand("%"))
    cmd = cmd:gsub("$fileBase", vim.fn.expand("%:r"))
    cmd = cmd:gsub("$filePath", vim.fn.expand("%:p"))
    cmd = cmd:gsub("$file", vim.fn.expand("%"))
    cmd = cmd:gsub("$dir", vim.fn.expand("%:p:h"))
    cmd = cmd:gsub(
        "$moduleName",
        vim.fn.substitute(
            vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand("%:r"), ":~:."), "/", ".", "g"),
            "\\",
            ".",
            "g"
        )
    )
    cmd = cmd:gsub("#", vim.fn.expand("#"))
    cmd = cmd:gsub("$altFile", vim.fn.expand("#"))

    return cmd
end

local function internal(cmd)
    cmd = cmd or config.cmds.internal[vim.bo.filetype]

    if not cmd then
        vim.cmd("echohl ErrorMsg | echo 'Error: Invalid command' | echohl None")
        return
    end

    if config.behavior.autosave then
        vim.cmd("silent write")
    end

    cmd = substitute(cmd)
    vim.cmd(cmd)
end

local function execute_command(cmd_type, selected_cmd)
    if selected_cmd == nil then
        return
    end
    selected_cmd = substitute(selected_cmd)
    if cmd_type == "float" then
        float(selected_cmd)
    elseif cmd_type == "bang" then
        vim.cmd("!" .. selected_cmd)
    elseif cmd_type == "quickfix" then
        quickfix(selected_cmd)
    elseif cmd_type == "terminal" then
        term(selected_cmd)
    else
        vim.cmd("echohl ErrorMsg | echo 'Error: Invalid type' | echohl None")
    end
end

local function run(cmd_type, cmd)
    cmd = cmd or config.cmds.external[vim.bo.filetype]

    if not cmd then
        vim.cmd("echohl ErrorMsg | echo 'Error: Invalid command' | echohl None")
        return
    end

    if config.behavior.autosave then
        vim.cmd("silent write")
    end

    if type(cmd) == "table" then
        vim.ui.select(cmd, { prompt = "Select a command: ", kind = "Jaq" }, function(selected_cmd)
            execute_command(cmd_type, selected_cmd)
        end)
    else
        execute_command(cmd_type, cmd)
    end
end

local function run_custom(cmd_type)
    if config.behavior.autosave then
        vim.cmd("silent write")
    end

    vim.ui.input({ prompt = "Run command: ", kind = "Jaq" }, function(selected_cmd)
        execute_command(cmd_type, selected_cmd)
    end)
end

local function project(type, file)
    local json = file:read("*a")
    local status, table = pcall(vim.fn.json_decode, json)
    io.close(file)

    if not status then
        vim.cmd("echohl ErrorMsg | echo 'Error: Invalid json' | echohl None")
        return
    end

    if type == "internal" then
        local cmd = table.internal[vim.bo.filetype]
        cmd = substitute(cmd)

        internal(cmd)
        return
    end

    local cmd = table.external[vim.bo.filetype]
    cmd = substitute(cmd)

    run(type, cmd)
end

function M.Jaq(type)
    local file = io.open(vim.fn.expand("%:p:h") .. "/.jaq.json", "r")

    -- Check if the filetype is in config.cmds.internal
    if vim.tbl_contains(vim.tbl_keys(config.cmds.internal), vim.bo.filetype) then
        -- Exit if the type was passed and isn't "internal"
        if type and type ~= "internal" then
            vim.cmd("echohl ErrorMsg | echo 'Error: Invalid type for internal command' | echohl None")
            return
        end
        type = "internal"
    else
        type = type or config.behavior.default
    end

    if file then
        project(type, file)
        return
    end

    if type == "internal" then
        internal()
        return
    end

    run(type)
end

function M.JaqRun(type)
    type = type or config.behavior.default

    run_custom(type)
end

return M
