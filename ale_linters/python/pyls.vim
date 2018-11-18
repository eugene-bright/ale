" Author: aurieh <me@aurieh.me>
" Description: A language server for Python

call ale#Set('python_pyls_executable', 'pyls')
call ale#Set('python_pyls_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('python_pyls_auto_pipenv', 0)
call ale#Set('python_pyls_extra_args', get(g:, 'ale_python_pyls_extra_args', []))

function! ale_linters#python#pyls#GetExecutable(buffer) abort
    if (ale#Var(a:buffer, 'python_auto_pipenv') || ale#Var(a:buffer, 'python_pyls_auto_pipenv'))
    \ && ale#python#PipenvPresent(a:buffer)
        return 'pipenv'
    endif

    return ale#python#FindExecutable(a:buffer, 'python_pyls', ['pyls'])
endfunction

function! ale_linters#python#pyls#GetExtraArguments(buffer) abort
    let l:extra_args = ""

    for arg in ale#Var(a:buffer, 'python_pyls_extra_args')
        let l:extra_args .= " " . ale#Escape(arg)
    endfor

    return l:extra_args
endfunction

function! ale_linters#python#pyls#GetCommand(buffer) abort
    let l:executable = ale_linters#python#pyls#GetExecutable(a:buffer)

    let l:exec_args = l:executable =~? 'pipenv$'
    \   ? ' run pyls'
    \   : ''

    let l:exec_args .= ale_linters#python#pyls#GetExtraArguments(a:buffer)

    return ale#Escape(l:executable) . l:exec_args
endfunction

call ale#linter#Define('python', {
\   'name': 'pyls',
\   'lsp': 'stdio',
\   'executable_callback': 'ale_linters#python#pyls#GetExecutable',
\   'command_callback': 'ale_linters#python#pyls#GetCommand',
\   'project_root_callback': 'ale#python#FindProjectRoot',
\   'completion_filter': 'ale#completion#python#CompletionItemFilter',
\})
