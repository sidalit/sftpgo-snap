# The script printed by "sftpgo gen completion bash" calls bash-completion
# helpers by their old names. Since bash-completion 2.12 those names are
# defined in /etc/bash_completion.d/000_bash_completion_compat.bash. core26
# ships that file, but inside a snap /etc is the host's, and a host with an
# older bash-completion (Ubuntu 24.04 has 2.11) has no such file. Define the
# names here when they are missing. This file is prepended to the generated
# script.
declare -F _get_comp_words_by_ref >/dev/null ||
    _get_comp_words_by_ref() { _comp_get_words "$@"; }
declare -F __ltrim_colon_completions >/dev/null ||
    __ltrim_colon_completions() { _comp_ltrim_colon_completions "$@"; }
declare -F _filedir >/dev/null ||
    _filedir() { _comp_compgen -a filedir "$@"; }
