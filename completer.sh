#!/bin/bash

# Adapted from: Brian Beffa <brbsix@gmail.com>
# Original version: https://brbsix.github.io/2015/11/29/accessing-tab-completion-programmatically-in-bash/

# load bash-completion if necessary
declare -F _completion_loader &>/dev/null || {
    source /usr/share/bash-completion/bash_completion
}

COMP_TYPE=9 # <tab> pressed (63 would be <tab><tab>)
COMP_KEY=9 # <tab>
COMP_LINE=$*
COMP_POINT=${#COMP_LINE}

# echo '$@' $@ $#
COMP_WORDS=("$@")
# echo COMP_WORDS ${COMP_WORDS}

eval set -- "$@"

# index of the last word
COMP_CWORD=$(( ${#COMP_WORDS[@]} - 1 ))

# determine completion function
completion=$(complete -p "$1" 2>/dev/null | awk '{print $(NF-1)}')

# run _completion_loader only if necessary
if [[ -z ${completion} ]]; then
    # load completion
    _completion_loader "$1"

    # determine completion function
    completion=$(complete -p "$1" 2>/dev/null | awk '{print $(NF-1)}')
fi

# complete -p | ag kube
# echo $completion

# ensure completion was detected
if [[ -z ${completion} ]]; then
    exit 127
fi

wordBeforeCompletion=''
if [[ ${#COMP_WORDS[@]} -gt 1 ]]; then
    wordBeforeCompletion=${COMP_WORDS[-2]}
fi

# echo COMP_LINE ${COMP_LINE}
# echo COMP_POINT ${COMP_POINT}
# echo COMP_WORDS ${COMP_WORDS}
# echo COMP_CWORD ${COMP_CWORD}

# execute completion function
"$completion" "${COMP_WORDS[0]}" "${COMP_WORDS[-1]}" "${wordBeforeCompletion}" 2>/dev/null

# echo COMP_LINE ${COMP_LINE}
# echo COMP_POINT ${COMP_POINT}
# echo COMP_WORDS ${COMP_WORDS}
# echo COMP_CWORD ${COMP_CWORD}
# echo COMPREPLY ${COMPREPLY}

# print completions
printf '%s\n' "${COMPREPLY[@]}"
