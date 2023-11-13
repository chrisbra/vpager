" Vim plugin copying terminal output to a Vim window
" Last Change: 
" Version: 0.1
" Author: Christian Brabandt <cb@256bit.org>
" Script:  http://www.vim.org/scripts/script.php?script_id=5682
" License: VIM License
" GetLatestVimScripts: 5682 1 :AutoInstall: vpager.vim
" Documentation: see :h vpager.txt (TODO!)
" TODO: - Remove ANSI Escape Sequences?
"       - allow option to pass current PWD to Vim
" ---------------------------------------------------------------------

" Load Once: {{{1
if exists("g:loaded_vpager") || &cp
  finish
elseif has("nvim")
  finish
elseif !(v:version > 800 || v:version == 800 && has("patch1647"))
  echohl WarningMsg
  echomsg "Vpager needs at least Vim 8.0.1647"
  echohl Normal
  finish
endif
let g:loaded_vpager = 1
let s:keepcpo       = &cpo
let s:bufname       = 'VPAGER'
set cpo&vim

" add directory of vpager to $PATH inside Vim
let s:script_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:bin_path = fnamemodify(s:script_path . '/../bin', ':p')
if stridx($PATH, s:bin_path) < 0
	if has('win32')
		let $PATH .= ';' . s:bin_path
	else
		let $PATH .= ':' . s:bin_path
	endif
endif
unlet s:script_path
unlet s:bin_path

" under Unix-like OSes we assume Vim to be in $PATH as vim
if has('win32')
  let $VIM_EXE = v:progpath
endif

function! s:SetupWindow() "{{{1 Setup VPAGER Window
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
function! Tapi_Vpager_setup(bufnum, arglist) "{{{1 Setup VPAGER Options
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
function! Tapi_Vpager_setup_post(bufnum, arglist) "{{{1 Setup VPAGER Options
  if type(a:arglist) == type([]) && len(a:arglist) > 1
        \ && a:arglist[0] ==# 'vpager_setup_post'
    if !exists("s:winid")
      let s:winid = s:SetupWindow()
    endif
    if s:winid != win_getid()
      call win_gotoid(s:winid)
    endif
    " Use a default errorformat filename:linenr
    setl errorformat=%f:%l:%m
    for value in a:arglist[1:]
      try
        exe "sil " value
      endtry
    endfor
    if len(a:arglist) > 1
      copen
    endif
  endif
endfunction
function! Tapi_Vpager(bufnum, arglist) "{{{1 Read Vpager input
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
    if getline(1) == ''
      1d
    endif
    noa wincmd p
  endif
endfu
" Restoration And Modelines: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" Modeline {{{1
" vim: fdm=marker fdl=0 ts=2 et sw=0 sts=-1
