local function vim_settings()
  vim.cmd([[
        let g:tex_flavor = 'latex'
        let g:vimtex_compiler_latexmk_engines = {'_':'-xelatex'}
        let g:vimtex_compiler_latexrun_engines ={'_':'xelatex'}
        let g:vimtex_quickfix_mode = 0
        set conceallevel=1
        let g:tex_conceal='abdmg'
        " Uncomment this line if forward/backward searching is invalid
        " let g:vimtex_compiler_progname = 'nvr'
        
        " PDF Viewer settings
        let g:vimtex_view_method = 'zathura' " 'skim' or 'zathura' here

        " Uncomment this block for zathura viewer ---------------------------
        let g:vimtex_view_general_viewer = 'zathura'
        let g:vimtex_view_method = 'zathura'
        " -------------------------------------------------------------------
        
        " Uncomment this block for skim viewer ------------------------------
        " let g:vimtex_view_general_viewer
        " \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
        " let g:vimtex_view_general_options = '-r @line @pdf @tex'
        " " Value 1 allows forward search after every successful compilation
        " let g:vimtex_view_skim_sync = 1 
        " " Value 1 allows change focus to skim after command `:VimtexView` is given
        " let g:vimtex_view_skim_activate = 1 
        " -------------------------------------------------------------------

        " Toc settings
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
