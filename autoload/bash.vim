let s:pluginPath = expand('<sfile>:p:h') . '/..'

function! bash#complete(partialCommand)
    return systemlist(s:pluginPath . '/completer.sh ' . a:partialCommand)
endfunction

function! bash#completor(findstart, base)
    if a:findstart
        " locate the start of the word
        let s:line = getline('.')
        let line = getline('.')
        let start = col('.') - 1
        " echom 'init start' start
        while start > 0 && line[start] != ' '
            let start -= 1
            " echom 'dec start' start
        endwhile
        let start += 1
        " echom 'return start' start
        return start
    else
        let ret = systemlist(s:pluginPath . '/completer.sh ' . s:line)
        " echom 'base' a:base s:line ret
        return ret
    endif

endfunction

" set completefunc=bash#completor
