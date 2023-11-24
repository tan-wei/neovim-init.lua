" Enable Mouse
set mouse=a
if has("win64") || has("win32") || has("win16")
    source $VIMRUNTIME/mswin.vim
endif
" Set Editor Font
if exists(':GuiFont')
    if has("win64") || has("win32") || has("win16")
        " Use GuiFont! to ignore font errors
        " NOTE: DejaVuSansMono Nerd Font causes 'bad fixed pitch metrics'
        GuiFont! DejaVuSansMono Nerd Font:h12
    elseif has('mac')
        GuiFont! DejaVuSansMono Nerd Font:h14
    else
        GuiFont SpaceMono Nerd Font:h8
    endif
endif

" Set Ligatures
if exists(':GuiRenderLigatures')
    GuiRenderLigatures 1
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif


if exists(':GuiScrollBar')
    " Right Click Context Menu (Copy-Cut-Paste)
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
    snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
endif
