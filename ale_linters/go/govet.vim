" Author: neersighted <bjorn@neersighted.com>
" Description: go vet for Go files
"
" Author: John Eikenberry <jae@zhar.net>
" Description: updated to work with go1.10

call ale#Set('go_go_executable', 'go')
call ale#Set('go_govet_options', '')

function! ale_linters#go#govet#GetCommand(buffer) abort
    let l:options = ale#Var(a:buffer, 'go_govet_options')

    return ale#path#BufferCdString(a:buffer) . ' '
    \   . ale#Var(a:buffer, 'go_go_executable') . ' vet '
    \   . (!empty(l:options) ? ' ' . l:options : '')
    \   . ' .'
endfunction

call ale#linter#Define('go', {
\   'name': 'govet',
\   'aliases': ['go vet'],
\   'output_stream': 'stderr',
\   'executable_callback': ale#VarFunc('go_go_executable'),
\   'command_callback': 'ale_linters#go#govet#GetCommand',
\   'callback': 'ale#handlers#go#Handler',
\   'lint_file': 1,
\})
