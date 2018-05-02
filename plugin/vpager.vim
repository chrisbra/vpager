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

let s:bufname = 'Vpager.txt'
let s:seq = 0

function! Tapi_Vpager(bufnum, arglist)
  if type(a:arglist) == type([]) && len(a:arglist) >= 3
    " Safety meaure
    let header=split(a:arglist[0], ':')
    if header[0] ==# 'vpager'
      let seq = header[1]
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

      if s:seq < seq
        setl buftype=nofile
        if len(header) > 2 && header[2] ==? 'new'
          noa %d _
        endif
        " Check for additional options
        if !empty(a:arglist[1])
          try
            exe "setl" a:arglist[1]
          endtry
        endif
        let s:seq = seq
      endif
      " Append output
      call append('$', a:arglist[2:])
      if getline(1) == ''
        :noa 1d _
      endif
      $
      noa wincmd p
    endif
  endif
endfu
" ---------------------------------------------------------------------
" Public Interface {{{1
" Restoration And Modelines: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" Modeline {{{1
" vim: fdm=marker fdl=0 ts=2 et sw=0 sts=-1
