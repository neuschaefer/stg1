# bash completion support for StGIT                        -*- shell-script -*-
#
# Copyright (C) 2006, Karl Hasselström <kha@treskal.com>
# Based on git-completion.sh
#
# To use these routines:
#
#    1. Copy this file to somewhere (e.g. ~/.stgit-completion.bash).
#
#    2. Add the following line to your .bashrc:
#         . ~/.stgit-completion.bash

_stg_commands="
    add
    applied
    assimilate
    branch
    delete
    diff
    clean
    clone
    commit
    export
    files
    float
    fold
    goto
    id
    import
    init
    log
    mail
    new
    patches
    pick
    pop
    pull
    push
    refresh
    rename
    resolved
    rm
    series
    show
    status
    top
    unapplied
    uncommit
"

# The path to .git, or empty if we're not in a repository.
_gitdir ()
{
    echo "$(git rev-parse --git-dir 2>/dev/null)"
}

# Name of the current branch, or empty if there isn't one.
_current_branch ()
{
    local b=$(git symbolic-ref HEAD 2>/dev/null)
    echo ${b#refs/heads/}
}

# List of all applied patches.
_applied_patches ()
{
    local g=$(_gitdir)
    [ "$g" ] && cat "$g/patches/$(_current_branch)/applied"
}

# List of all unapplied patches.
_unapplied_patches ()
{
    local g=$(_gitdir)
    [ "$g" ] && cat "$g/patches/$(_current_branch)/unapplied"
}

# List of all patches.
_all_patches ()
{
    local b=$(_current_branch)
    local g=$(_gitdir)
    [ "$g" ] && cat "$g/patches/$b/applied" "$g/patches/$b/unapplied"
}

# List of all patches except the current patch.
_all_other_patches ()
{
    local b=$(_current_branch)
    local g=$(_gitdir)
    [ "$g" ] && cat "$g/patches/$b/applied" "$g/patches/$b/unapplied" \
        | grep -v "^$(< $g/patches/$b/current)$"
}

# List the command options
_cmd_options ()
{
    stg $1 --help | grep -e " --[A-Za-z]" | sed -e "s/.*\(--[^ =]\+\).*/\1/"
}

# Generate completions for patches and patch ranges from the given
# patch list function, and options from the given list.
_complete_patch_range ()
{
    local patchlist="$1" options="$2"
    local pfx cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
        *..*)
            pfx="${cur%..*}.."
            cur="${cur#*..}"
            COMPREPLY=($(compgen -P "$pfx" -W "$($patchlist)" -- "$cur"))
            ;;
        *)
            COMPREPLY=($(compgen -W "$options $($patchlist)" -- "$cur"))
            ;;
    esac
}

# Generate completions for options from the given list.
_complete_options ()
{
    local options="$1"
    COMPREPLY=($(compgen -W "$options" -- "${COMP_WORDS[COMP_CWORD]}"))
}

_stg_common ()
{
    _complete_options "$(_cmd_options $1)"
}

_stg_all_patches ()
{
    _complete_patch_range _all_patches "$(_cmd_options $1)"
}

_stg_other_patches ()
{
    _complete_patch_range _all_other_patches "$(_cmd_options $1)"
}

_stg_applied_patches ()
{
    _complete_patch_range _applied_patches "$(_cmd_options $1)"
}

_stg_unapplied_patches ()
{
    _complete_patch_range _unapplied_patches "$(_cmd_options $1)"
}

_stg_help ()
{
    _complete_options "$_stg_commands"
}

_stg ()
{
    local i c=1 command

    while [ $c -lt $COMP_CWORD ]; do
        if [ $c == 1 ]; then
            command="${COMP_WORDS[c]}"
        fi
        c=$((++c))
    done

    # Complete name of subcommand.
    if [ $c -eq $COMP_CWORD -a -z "$command" ]; then
        COMPREPLY=($(compgen \
            -W "--help --version copyright help $_stg_commands" \
            -- "${COMP_WORDS[COMP_CWORD]}"))
        return;
    fi

    # Complete arguments to subcommands.
    case "$command" in
        # generic commands
        help)   _stg_help ;;
        # repository commands
        id)     _stg_all_patches $command ;;
        # stack commands
        float)  _stg_all_patches $command ;;
        goto)   _stg_other_patches $command ;;
        pop)    _stg_applied_patches $command ;;
        push)   _stg_unapplied_patches $command ;;
        # patch commands
        delete) _stg_all_patches $command ;;
        export) _stg_applied_patches $command ;;
        files)  _stg_all_patches $command ;;
        log)    _stg_all_patches $command ;;
        mail)   _stg_applied_patches $command ;;
        pick)   _stg_unapplied_patches $command ;;
        rename) _stg_all_patches $command ;;
        show)   _stg_all_patches $command ;;
        # all the other commands
        *)      _stg_common $command ;;
    esac
}

complete -o default -F _stg stg
