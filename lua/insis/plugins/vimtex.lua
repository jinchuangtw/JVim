local function vim_settings()
  vim.cmd([[
        let g:tex_flavor = 'latex'
        let g:vimtex_compiler_latexmk_engines = {'_':'-xelatex'}
        let g:vimtex_compiler_latexrun_engines ={'_':'xelatex'}
        let g:vimtex_quickfix_mode = 0
        set conceallevel=1
        let g:tex_conceal='abdmg'

        " Uncomment this block for zathura viewer ---------------------------
        let g:vimtex_view_general_viewer = 'zathura'
        let g:vimtex_view_method = 'zathura'
        " -------------------------------------------------------------------
        
        " Uncomment this block for skim viewer ------------------------------
        " let g:vimtex_view_general_viewer
        " \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
        " let g:vimtex_view_general_options = '-r @line @pdf @tex'
        " -------------------------------------------------------------------

        " This adds a callback hook that updates Skim after compilation
        " let g:vimtex_compiler_callback_hooks = ['UpdateSkim']

        " function! UpdateSkim(status)
        " if !a:status | return | endif

        " let l:out = b:vimtex.out()
        " let l:tex = expand('%:p')
        " let l:cmd = [g:vimtex_view_general_viewer, '-r']

        " if !empty(system('pgrep Skim'))
        "     call extend(l:cmd, ['-g'])
        " endif

        " if has('nvim')
        "     call jobstart(l:cmd + [line('.'), l:out, l:tex])
        " elseif has('job')
        "     call job_start(l:cmd + [line('.'), l:out, l:tex])
        " else
        "     call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
        " endif
        " endfunction

        let g:vimtex_toc_config = {
        \ 'name' : 'TOC',
        \ 'layers' : ['content', 'todo', 'include'],
        \ 'split_width' : 40,
        \ 'todo_sorted' : 0,
        \ 'show_help' : 1,
        \ 'show_numbers' : 1,
        \}
    ]])
end

vim_settings()
