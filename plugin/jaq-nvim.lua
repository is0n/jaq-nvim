vim.cmd([[
    function! JaqCompletion(lead, cmd, cursor)
        let valid_args = [ 'internal', 'float', 'terminal', 'bang', 'quickfix' ]
        let l = len(a:lead) - 1
        if l >= 0
            let filtered_args = copy(valid_args)
            call filter(filtered_args, {_, v -> v[:l] ==# a:lead})
            if !empty(filtered_args)
                return filtered_args
            endif
        endif
        return valid_args
    endfunction

    function! JaqRunCompletion(lead, cmd, cursor)
        let valid_args = [ 'float', 'terminal', 'bang', 'quickfix' ]
        let l = len(a:lead) - 1
        if l >= 0
            let filtered_args = copy(valid_args)
            call filter(filtered_args, {_, v -> v[:l] ==# a:lead})
            if !empty(filtered_args)
                return filtered_args
            endif
        endif
        return valid_args
    endfunction

    command! -nargs=? -complete=customlist,JaqCompletion Jaq :lua require('jaq-nvim').Jaq(<f-args>)
    command! -nargs=? -complete=customlist,JaqRunCompletion JaqRun :lua require('jaq-nvim').JaqRun(<f-args>)
]])
