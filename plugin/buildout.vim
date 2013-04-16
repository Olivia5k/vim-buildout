if exists('g:loaded_buildout') || &cp || v:version < 700
  finish
endif
let g:loaded_buildout = 1

let s:cpo_save = &cpo
set cpo&vim

function! s:Detect(filename)
  if exists('b:buildout_root')
    return buildout#BufInit()
  endif

  let fn = substitute(fnamemodify(a:filename, ":p"), '\c^file://', '', '')
  let ofn = ""

  while fn != ofn
    let ofn = fn
    let fn = fnamemodify(fn, ":h")

    if filereadable(fn . '/buildout.cfg')
      let b:buildout_root = fn
      return buildout#BufInit()
    endif
  endwhile
endfunction

augroup buildoutDetect
  autocmd!
  autocmd BufNewFile,BufRead * call s:Detect(expand("<afile>:p"))
augroup END

let &cpo = s:cpo_save
" vim:set sw=2 sts=2:
