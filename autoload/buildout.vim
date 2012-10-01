" autoload/buildout.vim
" Author:       Lowe Thiderman <lowe.thiderman@gmail.com>

" Install this file as autoload/buildout.vim.

if exists('g:autoloaded_buildout') || &cp
  finish
endif
let g:autoloaded_buildout = '0.1'

let s:cpo_save = &cpo
set cpo&vim

" Utilities {{{1

function! s:join(...)
  let ret = []
  for str in a:000
    let ret = add(ret, substitute(str, s:slash.'\+$', '', ''))
  endfor

  return join(ret, s:slash)
endfunction

function! s:relpath(path, ...)
  let path = fnamemodify(a:path, ':p')

  if a:0
    let rel = fnamemodify(a:1, ':p')
    return substitute(path, rel, '', '')
  else
    let rel = getcwd() . s:slash
    let rel = substitute(path, rel, '', '')
    return rel == '' ? './' : rel
  endif
endfunction

function! s:Buildcomplete(A,P,L)
  let path = s:join(b:buildout_root, 'bin')
  let l = split(globpath(path, '*'), '\n')
  let l = map(l, "fnamemodify(v:val, ':t')")
  let l = filter(l, 'v:val =~# "^".a:A')
  return l
endfunction

function! s:Bootcomplete(A,P,L)
  " let l = split(globpath(path, '*'), '\n')
  " let l = map(l, "fnamemodify(v:val, ':t')")
  " let l = filter(l, 'v:val =~# "^".a:A')
  " return l
endfunction

" }}}
" Interface {{{1

function! s:Edit(cmd)
  exe a:cmd s:relpath(s:join(b:buildout_root, 'buildout.cfg'))
endfunction

function! s:Buildout(...)
  let cmd = s:join(b:buildout_root, 'bin', a:0 ? a:1 : 'buildout')
  exe "!".cmd
endfunction

function! s:Bootstrap(...)
  " let cmd = s:join(b:buildout_root, 'bin', a:0 ? a:1 : 'buildout')
  " exe "!".cmd
endfunction

" }}}
" Initialization {{{1

function! s:BufCommands()
  com! -buffer Bedit    :call s:Edit('edit')
  com! -buffer Bsplit   :call s:Edit('split')
  com! -buffer Bvsplit  :call s:Edit('vsplit')
  com! -buffer Btabedit :call s:Edit('tabedit')

  com! -buffer -nargs=? -complete=customlist,s:Buildcomplete Buildout :call s:Buildout(<f-args>)
  " com! -buffer -nargs=? -complete=customlist,s:Bootcomplete Bootstrap :call s:Bootstrap(<f-args>)
endfunction

function! BuildoutBufInit()
  call s:BufCommands()
endfunction

if !exists('s:slash')
  let s:slash = has('win32') || has('win64') ? '\' : '/'
endif

" }}}

let &cpo = s:cpo_save
" vim:set sw=2 sts=2:
