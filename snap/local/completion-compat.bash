# Old bash-completion helper names, missing when the host's /etc has no compat file.
declare -F _get_comp_words_by_ref >/dev/null ||
    _get_comp_words_by_ref() { _comp_get_words "$@"; }
declare -F __ltrim_colon_completions >/dev/null ||
    __ltrim_colon_completions() { _comp_ltrim_colon_completions "$@"; }
declare -F _filedir >/dev/null ||
    _filedir() { _comp_compgen -a filedir "$@"; }
