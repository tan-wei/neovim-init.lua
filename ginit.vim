" Enable Mouse
set mouse=a

if has("win64") || has("win32") || has("win16")
    " NOTE: Not needed now, and it will cause error when start neovim-qt or neovide
    " source $VIMRUNTIME/mswin.vim
endif

" Set Editor Font
if exists(':GuiFont')
    if has("win64") || has("win32") || has("win16")
        " Use GuiFont! to ignore font errors
        " NOTE: DejaVuSansMono Nerd Font causes 'bad fixed pitch metrics'
        GuiFont! DejaVuSansMono Nerd Font:h12
    elseif has('mac')
        GuiFont! DejaVuSansM Nerd Font:h14
    else
        GuiFont! VictorMono Nerd Font:h8
    endif
endif

" Disable Ligatures
if exists(':GuiRenderLigatures')
    " Enable ligatures will cause nerd font cutoff
    GuiRenderLigatures 0
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Disable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 0
endif

" Enable GUI Adaptive Font
if exists(':GuiAdaptiveFont')
    GuiAdaptiveFont 1
endif

if exists(':GuiScrollBar')
    " Right Click Context Menu (Copy-Cut-Paste)
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
    snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
endif

if exists('g:fvim_loaded')
    if g:fvim_os == 'windows'
      set guifont=DejaVuSansMono\ Nerd\ Font:h12
    elseif g:fvim_os == 'osx'
      set guifont=DejaVuSansM\ Nerd\ Font:h14
    else
      set guifont=VictorMono\ Nerd\ Font:h8
    endif

    FVimToggleFullScreen

    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
    FVimUIPopupMenu v:false
    FVimFontAntialias v:true
    FVimFontAutohint v:true
    FVimFontHintLevel 'full'
    FVimFontLigature v:true
    FVimFontSubpixel v:true
    FVimFontNoBuiltinSymbols v:true
endif
