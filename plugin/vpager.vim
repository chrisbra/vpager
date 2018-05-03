" Vim plugin copying terminal output to a Vim window
" Last Change: Thu, 15 Jan 2015 21:26:55 +0100
" Version: 0.19
" Author: Christian Brabandt <cb@256bit.org>
" Script:  http://www.vim.org/scripts/script.php?script_id=
" License: VIM License
" GetLatestVimScripts: ???? 18 :AutoInstall: vpager.vim
" Documentation: see :h vpager.txt (TODO!)
" ---------------------------------------------------------------------
" Load Once: {{{1
if exists("g:loaded_vpager") || &cp
  finish
endif
let g:loaded_vpager = 1
let s:keepcpo          = &cpo
set cpo&vim
"}}}1

let s:bufname = 'VPAGER'
let s:seq = 0

function! s:SetupWindow()
  " Create window
  if bufexists(s:bufname)
    if bufwinnr(bufnr(s:bufname)) == -1
      exe ":sp" s:bufname
    else
      exe ":noa :drop" s:bufname
    endif
  else
    exe ":sp" s:bufname
  endif
  return win_getid()
endfu

function! Tapi_Vpager_setup(bufnum, arglist)
  if type(a:arglist) == type([]) && len(a:arglist) > 1
        \ && a:arglist[0] ==# 'vpager_setup'
    let s:winid = s:SetupWindow()
    setl buftype=nofile
    for value in a:arglist[1:]
      try
        exe "sil " value
      endtry
    endfor
  endif
endfunction

function! Tapi_Vpager(bufnum, arglist)
  " Safety meaure
  if type(a:arglist) == type([]) && len(a:arglist) >= 2
        \ && a:arglist[0] ==# 'vpager'
    if !exists("s:winid")
      let s:winid = s:SetupWindow()
    endif
    if s:winid != win_getid()
      call win_gotoid(s:winid)
    endif
    " Append output
    try
      call append('$', a:arglist[1:])
    catch
      echo v:exception
      echo a:arglist
    endtry
    " go back to terminal window
    noa wincmd p
  endif
endfu
" ---------------------------------------------------------------------
" Public Interface {{{1
" Restoration And Modelines: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" Modeline {{{1
" vim: fdm=marker fdl=0 ts=2 et sw=0 sts=-1
