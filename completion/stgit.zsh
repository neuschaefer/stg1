#compdef stg

# This script implements zsh completions for StGit (stg).
#
# To use these completions, copy to a directory in $fpath as _stgit.
# For example:
#
#     $ mkdir ~/.zsh.d
#     $ cp completion/stgit.zsh ~/.zsh.d/_stgit
#     $ $EDITOR ~/.zshrc
#
#       fpath=("$HOME/.zsh.d" $fpath)
#       autoload -U compinit
#

_stg-branch() {
    __stg_add_args_help
    subcmd_args+=(
        - group-list
        '--list[list branches]'
        - group-switch
        '--merge[merge worktree changes into other branch]'
        ':branch:__stg_branch_stgit'
        - group-create
        '--create[create and switch to new branch]'
        ':new-branch:'
        ':committish:'
        - group-clone
        '--clone[clone current branch to new branch]'
        ':new-branch:'
        - group-rename
        '(-r --rename)'{-r,--rename}'[rename existing branch]'
        ':branch:__stg_branch_stgit'
        ':new-branch:'
        - group-protect
        '(-p --protect)'{-p,--protect}'[prevent stg from modifying branch]'
        ':branch:__stg_branch_stgit'
        - group-unprotect
        '(-u --unprotect)'{-u,--unprotect}'[allow stg to modify branch]'
        ':branch:__stg_branch_stgit'
        - group-delete
        '--delete[delete branch]'
        '--force[force delete when series is non-empty]'
        ':branch:__stg_branch_stgit'
        - group-cleanup
        '--cleanup[cleanup stg metadata for branch]'
        '--force[force cleanup when series is non-empty]'
        ':branch:__stg_branch_stgit'
        - group-description
        '(-d --description)'{-d,--description}'[set branch description]:description'
        ':branch:__stg_branch_stgit'
    )
    _arguments -s -S $subcmd_args
}

_stg-clean() {
    __stg_add_args_help
    subcmd_args+=(
        '(-a --applied)'{-a,--applied}'[delete empty applied patches]'
        '(-u --unapplied)'{-u,--unapplied}'[delete empty unapplied patches]'
    )
    _arguments -s -S $subcmd_args
}

_stg-clone() {
    __stg_add_args_help
    subcmd_args+=(
        ':repository:'
        ': :_directories'
    )
    _arguments -s $subcmd_args
}

_stg-commit() {
    __stg_add_args_help
    subcmd_args+=(
        '--allow-empty[allow committing empty patches]'
        - group-all
        '(-a --all)'{-a,--all}'[commit all unapplied patches]'
        - group-number
        '(-n --number)'{-n+,--number=}'[commit specified number of patches]:number'
        - group-patches
        '*:applied patches:__stg_patches_applied'
    )
    _arguments -s -S $subcmd_args
}

_stg-delete() {
    __stg_add_args_help
    __stg_add_args_branch
    subcmd_args+=(
        '--spill[spill patch contents to worktree and index]'
        - group-top
        '(-t --top)'{-t,--top}'[delete top patch]'
        - group-patchnames
        '*:patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-diff() {
    __stg_add_args_help
    __stg_add_args_diffopts
    subcmd_args+=(
        '(-r --range)'{-r,--range=}'[show diff between revisions]: :__stg_patches_all'
        '(-s --stat)'{-s,--stat}'[show stat instead of diff]'
        '*:files:__stg_changed_files'
    )
    _arguments -s -S $subcmd_args
}

_stg-edit() {
    __stg_add_args_help
    __stg_add_args_author
    __stg_add_args_diffopts
    __stg_add_args_edit
    __stg_add_args_hook
    __stg_add_args_savetemplate
    __stg_add_args_sign
    subcmd_args+=(
        '(-d --diff)'{-d,--diff}'[edit patch diff]'
        '(-t --set-tree)'{-t,--set-tree=}'[set git tree of patch]:treeish'
        ':patch:__stg_patches_all'
    )
    __stg_add_args_message
    _arguments -s -S $subcmd_args
}

_stg-export() {
    __stg_add_args_help
    __stg_add_args_branch
    __stg_add_args_diffopts
    subcmd_args+=(
        '(-d --dir)'{-d,--dir}'[export patches to directory]: :_directories'
        '(-n --numbered)'{-n,--numbered}'[prefix patch names with order numbers]'
        '(-s --stdout)'{-s,--stdout}'[dump patches to standard output]'
        '(-t --template)'{-t,--template=}'[use template file]: :_files'
        '*:patches:__stg_patches_unhidden'
        + '(suffix)'
        '(-e --extension)'{-e,--extension=}'[extension to append to patch names]:extension'
        '(-p --patch)'{-p,--patch}'[append .patch to patch names]'
    )
    _arguments -s -S $subcmd_args
}

_stg-files() {
    __stg_add_args_help
    __stg_add_args_diffopts
    subcmd_args+=(
        '--bare[bare file names]'
        '(-s --stat)'{-s,--stat}'[show diff stat]'
        ':patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-float() {
    __stg_add_args_help
    __stg_add_args_keep
    subcmd_args+=(
        '--noapply[Reorder patches by floating without applying]'
        '(-s --series)'{-s,--series=}'[arrange according to series file]: :_files'
        '*:patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-fold() {
    __stg_add_args_help
    subcmd_args+=(
        '(-b --base)'{-b,--base=}'[apply on base commit instead of HEAD]:commit'
        '(-p --strip)'{-p+,--strip=}'[remove N leading directories from diff paths]:num'
        '-C=[ensure N lines of surrounding context for each change]:num'
        '--reject[leave rejected hunks in .rej files]'
        ':file:_files'
    )
    _arguments -s -S $subcmd_args
}

_stg-goto() {
    __stg_add_args_help
    __stg_add_args_keep
    __stg_add_args_merged
    subcmd_args+=(
        ':patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-help() {
    _arguments -s ':commands:__stg_subcommands'
}

_stg-hide() {
    __stg_add_args_help
    __stg_add_args_branch
    subcmd_args+=(
        ':patches:__stg_patches_unhidden'
    )
    _arguments -s -S $subcmd_args
}

_stg-id() {
    __stg_add_args_help
    subcmd_args+=(
        ':references:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-import() {
    __stg_add_args_help
    __stg_add_args_author
    __stg_add_args_edit
    __stg_add_args_sign
    subcmd_args+=(
        '(-n --name)'{-n,--name}'[name for imported patch]'
        '(-p --strip)'{-p+,--strip=}'[remove N leading directories from diff paths]:num'
        '(-t --stripname)'{-t,--stripname}'[strip number and extension from patch name]'
        '-C=[ensure N lines of surrounding context for each change]:num'
        '(-i --ignore)'{-i,--ignore}'[ingore applied patches in series]'
        '--replace[replace unapplied patches in series]'
        '--reject[leave rejected hunks in .rej files]'
        '--keep-cr[do not remove CR from email lines ending with CRLF]'
        '--message-id[create Message-Id trailer from email header]'
        '(-d --showdiff)'{-d,--showdiff}'[show patch content in editor buffer]'
        ':file:_files'
        + '(source)'
        '(-m --mail)'{-m,--mail}'[import from standard email file]'
        '(-M --mbox)'{-M,--mbox}'[import from mbox file]'
        '(-s --series)'{-s,--series}'[import from series file]'
        '(-u --url)'{-u,--url}'[import patch from URL]'
    )
    _arguments -s -S $subcmd_args
}

_stg-init() {
    __stg_add_args_help
    _arguments -s $subcmd_args
}

_stg-log() {
    __stg_add_args_help
    __stg_add_args_branch
    subcmd_args+=(
        '--clear[clear log history]'
        '(-d --diff)'{-d,--diff}'[show refresh diffs]'
        '(-f --full)'{-f,--full}'[show full commit ids]'
        '(-g --graphical)'{-g,--graphical}'[show log in gitk]'
        '(-n --number)'{-n+,--number=}'[limit to number of commits]'
        '*:patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-mail() {
    __stg_add_args_help
    __stg_add_args_branch
    __stg_add_args_diffopts
    subcmd_args+=(
        '--to=[add address to To: list]:address'
        '--cc=[add address to Cc: list]:address'
        '--bcc=[add address to Bcc: list]:address'
        '--auto[automatically cc patch signers]'
        '--no-thread[do not send subsequent messages as replies]'
        '--unrelated[send patches without sequence numbers]'
        '(-v --version)'{-v,--version=}'[add version to subject prefix]:version'
        '--prefix=[add prefix to subject]:prefix'
        '(-c --cover)'{-c,--cover=}'[cover message file]: :_files'
        '(-e --edit-cover)'{-e,--edit-cover}'[edit cover message before sending]'
        '(-E --edit-patches)'{-E,--edit-patches}'[edit patches before sending]'
        '(-s --sleep)'{-s,--sleep=}'[seconds to sleep between sending emails]:seconds'
        '--in-reply-to=[reply reference id]:refid'
        '--domain=[domain to use for message ID]:domain'
        '(-u --user)'{-u,--user=}'[username for SMTP authentication]:user'
        '(-p --password)'{-p,--password=}'[password for SMTP authentication]:password'
        '(-T --smtp-tls)'{-t,--smtp-tls}'[use TLS for SMTP authentication]'
        + '(send-method)'
        '--git[use `git send-email`]'
        '(-m --mbox)'{-m,--mbox}'[generate mbox file instead of sending]'
        '--smtp-server=[server or command for sending email]'
        + '(attachment)'
        '--attach[send patch as attachment]'
        '--attach-inline[send patch as inline attachment]'
        '(-t --template)'{-t,--template=}'[message template file]: :_files'
        + '(patches)'
        '(-a --all)'{-a,--all}'[email all applied patches]'
        '*:patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-new() {
    __stg_add_args_help
    __stg_add_args_author
    __stg_add_args_sign
    __stg_add_args_hook
    __stg_add_args_savetemplate
    subcmd_args+=(
        '(-v --verbose)'{-v,--verbose}'[show diff of file changes]'
        ':: :_guard "([^-]?#|)" name'
    )
    __stg_add_args_message
    _arguments -s -S $subcmd_args
}

_stg-next() {
    __stg_add_args_help
    __stg_add_args_branch
    _arguments -s -S $subcmd_args
}

_stg-patches() {
    __stg_add_args_help
    __stg_add_args_branch
    __stg_add_args_diffopts
    subcmd_args+=(
        '(-d --diff)'{-d,--diff}'[show diffs of given files]'
        '*:files:__stg_files_known'
    )
    _arguments -s -S $subcmd_args
}

_stg-pick() {
    # TODO: complete --parent commit id
    __stg_add_args_help
    subcmd_args+=(
        '(-n --name)'{-n,--name=}'[name for picked patch]:name'
        '(-B --ref-branch)'{-B,--ref-branch=}'[pick patches from branch]: :__stg_branch_stgit'
        '(-r --revert)'{-r,--revert}'[revert given commit object]'
        '(-p --parent=)'{-p,--parent}'[use commit id as parent]:commit'
        '(-x --expose)'{-x,--expose}'[append imported commit id to patch log]'
        '--noapply[keep patch unapplied]'
        '*'{-f,--file=}'[only fold given file]: :_files'
        '*:patches:__stg_patches_refbranch'
        + '(mode)'
        '--fold[fold the commit into current patch]'
        '--update[fold limited to current patch files]'
    )
    _arguments -s -S $subcmd_args
}

_stg-pop() {
    __stg_add_args_help
    __stg_add_args_keep
    subcmd_args+=(
        '(-s --spill)'{-s,--spill}'[pop a patch keeping its modifications in the tree]'
        - group-number
        '(-n --number)'{-n+,--number=}'[push specified number of patches]:number'
        - group-all
        '(-a --all)'{-a,--all}'[push all unapplied patches]'
        - group-patches
        '*:applied patches:__stg_patches_applied'
    )
    _arguments -s -S $subcmd_args
}

_stg-prev() {
    __stg_add_args_help
    __stg_add_args_branch
    _arguments -s -S $subcmd_args
}

_stg-pull() {
    __stg_add_args_help
    __stg_add_args_merged
    subcmd_args+=(
        '(-n --nopush)'{-n,--nopush}'[do not push patches after rebasing]'
        ':repository:__stg_remotes'
    )
    _arguments -s -S $subcmd_args
}

_stg-push() {
    __stg_add_args_help
    __stg_add_args_keep
    __stg_add_args_merged
    subcmd_args+=(
        '--reverse[push patches in reverse order]'
        '--noapply[push without applying]'
        '--set-tree[push patch with the original tree]'
        - group-all
        '(-a --all)'{-a,--all}'[push all unapplied patches]'
        - group-number
        '(-n --number)'{-n+,--number=}'[push specified number of patches]:number'
        - group-patches
        '*:unapplied patches:__stg_patches_unapplied'
    )
    _arguments -s -S $subcmd_args
}

_stg-rebase() {
    __stg_add_args_help
    __stg_add_args_merged
    subcmd_args+=(
        '(-n --nopush)'{-n,--nopush}'[do not push patches after rebasing]'
        ':new-base-id:__stg_heads'
    )
    _arguments -s -S $subcmd_args
}

_stg-redo() {
    __stg_add_args_help
    subcmd_args+=(
        '--hard[discard changes in index/worktree]'
        '(-n --number)'{-n+,--number=}'[number of undos to redo]:number'
    )
    _arguments -s -S $subcmd_args
}

_stg-refresh() {
    __stg_add_args_help
    __stg_add_args_author
    __stg_add_args_edit
    __stg_add_args_hook
    __stg_add_args_sign
    __stg_add_args_diffopts
    subcmd_args+=(
        '(-a --annotate)'{-a,--annotate=}'[annotate patch log entry]:note'
        '(-d --diff)'{-d,--diff}'[show diff when editing patch message]'
        '(-F --force)'{-F,--force}'[force refresh even if index is dirty]'
        '(-i --index)'{-i,--index}'[refresh from index instead of worktree]'
        '(-p --patch)'{-p,--patch=}'[refresh patch other than top patch]: :__stg_patches_all'
        '--spill[Spill patch contents to worktree and index, and erase patch content]'
        + '(update-files)'
        '(-u --update)'{-u,--update}'[only update current patch files]'
        '*:files:__stg_changed_files'
        + '(submodules)'
        '(-s --submodules)'{-s,--submodules}'[include submodules in refresh]'
        '--no-submodules[exclude submodules from refresh]'
    )
    __stg_add_args_message
    _arguments -s -S $subcmd_args
}

_stg-rename() {
    __stg_add_args_help
    __stg_add_args_branch
    subcmd_args+=(
        ':old-patch:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-repair() {
    __stg_add_args_help
    _arguments -s $subcmd_args
}

_stg-reset() {
    __stg_add_args_help
    subcmd_args+=(
        '--hard[discard changes in index/worktree]'
        ':state:'
        '*:patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-series() {
    __stg_add_args_help
    __stg_add_args_branch
    subcmd_args+=(
        '--author[show the author name for each patch]'
        '(-c --count)'{-c,--count}'[print number of patches]'
        '(-d --description)'{-d,--description}'[show short descriptions]'
        '--no-description[do not show patch descriptions]'
        '(-e --empty)'{-e,--empty}'[identify empty patches]'
        '(-m --missing)'{-m,--missing=}'[show patches from branch missing in current]: :__stg_branch_stgit'
        '--noprefix[do not show the patch status prefix]'
        '(-s --short)'{-s,--short}'[list just patches around the topmost patch]'
        '--showbranch[show branch name of listed patches]'
        - group-ahu
        '(-A --applied)'{-A,--applied}'[show applied patches]'
        '(-H --hidden)'{-H,--hidden}'[show hidden patches]'
        '(-U --unapplied)'{-U,--unapplied}'[show unapplied patches]'
        - group-all
        '(-a --all)'{-a,--all}'[show all patches including hidden]'
        - group-patches
        ':patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-show() {
    __stg_add_args_help
    __stg_add_args_branch
    __stg_add_args_diffopts
    subcmd_args+=(
        '(-s --stat)'{-s,--stat}'[show diff stat]'
        '*:patches:__stg_patches_all'
        + '(patch-selection)'
        '(-a --applied)'{-a,--applied}'[show applied patches]'
        '(-u --unapplied)'{-u,--unapplied}'[show unapplied patches]'
    )
    _arguments -s -S $subcmd_args
}

_stg-sink() {
    __stg_add_args_help
    __stg_add_args_keep
    subcmd_args+=(
        '(-n --nopush)'{-n,--nopush}'[do not push patches after sinking]'
        '(-t --to)'{-t,--to=}'[sink patches below target patch]: :__stg_patches_applied'
        '*:patches:__stg_patches_all'
    )
    _arguments -s -S $subcmd_args
}

_stg-squash() {
    __stg_add_args_help
    __stg_add_args_hook
    __stg_add_args_savetemplate
    subcmd_args+=(
        '(-n --name)'{-n,--name=}'[name for squashed patch]: :__stg_patches_all'
        '*:patches:__stg_patches_all_allow_dups'
    )
    __stg_add_args_message
    _arguments -s -S $subcmd_args
}

_stg-sync() {
    __stg_add_args_help
    subcmd_args+=(
        + '(patches)'
        '(-a --all)'{-a,--all}'[synchronize all applied patches]'
        '*:patches:__stg_patches_refbranch'
        + '(source)'
        '(-B --ref-branch)'{-B,--ref-branch}'[synchronize patches with branch]: :__stg_branch_stgit'
        '(-s --series)'{-s,--series=}'[synchronize patches with series]: :_files'
    )
    _arguments -s -S $subcmd_args
}

_stg-top() {
    __stg_add_args_help
    __stg_add_args_branch
    _arguments -s -S $subcmd_args
}

_stg-uncommit() {
    __stg_add_args_help
    subcmd_args+=(
        - group-number
        '(-n --number)'{-n+,--number=}'[push specified number of patches]:number'
        ':prefix:'
        - group-to
        '(-t --to)'{-t,--to=}'[uncommit to the specified commit]:commit'
        '(-x --exclusive)'{-x,--exclusive}'[exclude the commit specified by --to]'
        - group-names
        '*: :_guard "([^-]?#|)" names'
    )
    _arguments -s -S $subcmd_args
}

_stg-undo() {
    __stg_add_args_help
    subcmd_args+=(
        '--hard[discard changes in index/worktree]'
        '(-n --number)'{-n+,--number=}'[number commands to undo]:number'
    )
    _arguments -s -S $subcmd_args
}

_stg-unhide() {
    __stg_add_args_help
    __stg_add_args_branch
    subcmd_args+=(
        ':patches:__stg_patches_hidden'
    )
    _arguments -s -S $subcmd_args
}

__stg_add_args_author() {
    subcmd_args+=(
        '--author=[set author details]'
        '--authdate=[set author date]:date'
        '--authemail=[set author email]:email'
        '--authname=[set author name]:name'
    )
}

__stg_add_args_branch() {
    subcmd_args+=(
        '(-b --branch)'{-b,--branch=}'[specify another branch]: :__stg_branch_stgit'
    )
}

__stg_add_args_diffopts() {
    # TODO: complete diff-opts values (with separators?)
    subcmd_args+=(
        '(-O --diff-opts)'{-O+,--diff-opts=}'[extra options for git diff]:opts'
    )
}

__stg_add_args_edit() {
    subcmd_args+=(
        '(-e --edit)'{-e,--edit}'[invoke interactive editor]'
    )
}

__stg_add_args_help() {
    subcmd_args+=(
        '(- *)'{-h,--help}'[show help message and exit]'
    )
}

__stg_add_args_hook() {
    subcmd_args+=(
        '--no-verify[disable commit-msg hook]'
    )
}

__stg_add_args_keep() {
    subcmd_args+=(
        '(-k --keep)'{-k,--keep}'[keep local changes]'
    )
}

__stg_add_args_merged() {
    subcmd_args+=(
        '(-m --merged)'{-m,--merged}'[check for patches merged upstream]'
    )
}

__stg_add_args_message() {
    subcmd_args+=(
        + '(message)'
        '(-f --file)'{-f,--file=}'[use message file instead of invoking editor]: :_files'
        '(-m --message)'{-m,--message=}'[specify message instead of invoking editor]:message'
    )
}

__stg_add_args_savetemplate() {
    subcmd_args+=(
        '--save-template=[save message template to file and exit]: :_files'
    )
}

__stg_add_args_sign() {
    subcmd_args+=(
        '--ack[add Acked-by trailer]'
        '--ack-by[add Acked-by trailer]:value'
        '--review[add Reviewed-by trailer]'
        '--review-by[add Reviewed-by trailer]:value'
        '--sign[add Signed-off-by trailer]'
        '--sign-by[add Signed-off-by trailer]:value'
    )
}

__stg_heads () {
    _alternative 'heads-local::__stg_heads_local' 'heads-remote::__stg_heads_remote'
}

__stg_heads_local () {
    local f gitdir
    declare -a heads

    heads=(${(f)"$(_call_program headrefs git for-each-ref --format='"%(refname:short)"' refs/heads 2>/dev/null)"})
    gitdir=$(_call_program gitdir git rev-parse --git-dir 2>/dev/null)
    if __stg_git_command_successful $pipestatus; then
        for f in HEAD FETCH_HEAD ORIG_HEAD MERGE_HEAD; do
            [[ -f $gitdir/$f ]] && heads+=$f
        done
        [[ -f $gitdir/refs/stash ]] && heads+=stash
        [[ -f $gitdir/refs/bisect/bad ]] && heads+=bisect/bad
    fi

    __stg_git_describe_commit heads heads-local "local head" "$@"
}

__stg_heads_remote () {
  declare -a heads

  heads=(${(f)"$(_call_program headrefs git for-each-ref --format='"%(refname:short)"' refs/remotes 2>/dev/null)"})

  __stg_git_describe_commit heads heads-remote "remote head" "$@"
}

__stg_git_command_successful () {
  if (( ${#*:#0} > 0 )); then
    _message 'not a git repository'
    return 1
  fi
  return 0
}

__stg_git_describe_commit () {
  __stg_git_describe_branch $1 $2 $3 -M 'r:|/=* r:|=*' "${(@)argv[4,-1]}"
}

__stg_git_describe_branch () {
  local __commits_in=$1
  local __tag=$2
  local __desc=$3
  shift 3

  integer maxverbose
  if zstyle -s :completion:$curcontext: max-verbose maxverbose &&
    (( ${compstate[nmatches]} <= maxverbose )); then
    local __c
    local -a __commits
    for __c in ${(P)__commits_in}; do
      __commits+=("${__c}:${$(_call_program describe git rev-list -1 --oneline $__c)//:/\\:}")
    done
    _describe -t $__tag $__desc __commits "$@"
  else
    local expl
    _wanted $__tag expl $__desc compadd "$@" -a - $__commits_in
  fi
}

__stg_branch_stgit() {
    declare -a stg_branches
    stg_branches=(
        ${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/stacks 2>/dev/null)"}#refs/stacks/}
    )
    local expl
    _wanted -V branches expl "branch" compadd $stg_branches
}

__stg_files_relative() {
    local prefix
    prefix=$(_call_program gitprefix git rev-parse --show-prefix 2>/dev/null)
    if (( $#prefix == 0 )); then
        print $1
        return
    fi

    local file
    local -a files

    files=()
    # Collapse "//" and "/./" into "/". Strip any remaining "/." and "/".
    for file in ${${${${${(0)1}//\/\///}//\/.\///}%/.}%/}; do
        integer i n
        (( n = $#file > $#prefix ? $#file : $#prefix ))
        for (( i = 1; i <= n; i++ )); do
            if [[ $file[i] != $prefix[i] ]]; then
                while (( i > 0 )) && [[ $file[i-1] != / ]]; do
                    (( i-- ))
                done
                break
            fi
        done

        files+=${(l@${#prefix[i,-1]//[^\/]}*3@@../@)}${file[i,-1]}
    done

    print ${(pj:\0:)files}
}

__stg_diff-index_files () {
  local tree=$1 description=$2 tag=$3; shift 3
  local files expl

  # $tree needs to be escaped for _call_program; matters for $tree = "HEAD^"
  files=$(_call_program files git diff-index -z --name-only --no-color --cached ${(q)tree} 2>/dev/null)
  __stg_git_command_successful $pipestatus || return 1
  files=(${(0)"$(__stg_files_relative $files)"})
  __stg_git_command_successful $pipestatus || return 1

  _wanted $tag expl $description _multi_parts $@ - / files
}

__stg_changed-in-index_files () {
  __stg_diff-index_files HEAD 'changed in index file' changed-in-index-files "$@"
}

__stg_changed-in-working-tree_files () {
  local files expl

  files=$(_call_program changed-in-working-tree-files git diff -z --name-only --no-color 2>/dev/null)
  __stg_git_command_successful $pipestatus || return 1
  files=(${(0)"$(__stg_files_relative $files)"})
  __stg_git_command_successful $pipestatus || return 1

  _wanted changed-in-working-tree-files expl 'changed in working tree file' _multi_parts $@ -f - / files
}

__stg_changed_files () {
  _alternative \
    'changed-in-index-files::__stg_changed-in-index_files' \
    'changed-in-working-tree-files::__stg_changed-in-working-tree_files'
}

__stg_files_known() {
    declare -a known_files
    known_files=(
        ${(f)"$(_call_program known-files git ls-files 2>/dev/null)"}
    )
    local expl
    _wanted -V known-files expl "known files" _multi_parts - / known_files
}

__stg_get_branch_opt() {
    local short long i
    short=${1:-'-b'}
    long=${2:-'--branch'}
    i=${words[(I)$short|$long(=*|)]}
    case ${words[i]} in
    $short|$long)
        if (( i < $#words )); then
            echo "--branch=${words[i + 1]}"
        fi
        ;;
    *)
        echo "--branch=${words[i]#*=}"
        ;;
    esac
}

__stg_want_patches() {
    declare -a patches
    local expl
    patches=(
        ${(f)"$(_call_program want-patches stg series --no-description --noprefix $@ 2>/dev/null)"}
    )
    _wanted -V all expl "patch" compadd ${patches:|words}

}

__stg_patches_all() {
    __stg_want_patches $(__stg_get_branch_opt) --all
}

__stg_patches_all_allow_dups() {
    declare -a patches
    local expl branch_opt
    branch_opt=$(__stg_get_branch_opt)
    patches=(
        ${(f)"$(_call_program all-patches stg series $branch_opt --no-description --noprefix --all 2>/dev/null)"}
    )
    _wanted -V all expl "patch" compadd ${patches}
}

__stg_patches_applied() {
    __stg_want_patches $(__stg_get_branch_opt) --applied
}

__stg_patches_hidden() {
    __stg_want_patches $(__stg_get_branch_opt) --hidden
}

__stg_patches_unapplied() {
    __stg_want_patches $(__stg_get_branch_opt) --unapplied
}

__stg_patches_unhidden() {
    __stg_want_patches $(__stg_get_branch_opt) --applied --unapplied
}

__stg_patches_refbranch() {
    __stg_want_patches $(__stg_get_branch_opt -B --ref-branch) --all
}

__stg_remotes() {
    local remotes expl
    remotes=(${(f)"$(_call_program remotes git remote 2>/dev/null)"})
    _wanted remotes expl remote compadd "$@" -a - remotes
}

__stg_subcommands() {
    _describe -t commands 'stgit command' _stg_cmds
}

__stg_caching_policy() {
    [[ =$service -nt $1 ]]
}

_stgit() {
    local curcontext="$curcontext" state line expl ret=1
    typeset -A opt_args

    # Special cases for git aliases
    case "$words[2]" in
        (add|mv|rm|status)
            words[1]=git
            ;;
        (resolved)
            words[1]=git
            words[2]=add
            ;;
    esac
    if [ "$words[1]" = git ]; then
        _normal && ret=0
        return ret
    fi

    local update_policy
    zstyle -s ":completion:*:*:stg:*" cache-policy update_policy
    if [[ -z "$update_policy" ]]; then
        zstyle ":completion:*:*:stg:*" cache-policy __stg_caching_policy
    fi

    _arguments -C -A "-*" \
               '(-)--help[print help information]' \
               '(*)--version[display version information]' \
               '1: :->command' \
               '*:: :->args' && ret=0

    if [[ -n $state ]] && (( ! $+_stg_cmds )); then
        typeset -a _stg_cmds
        if _cache_invalid stg-cmds || ! _retrieve_cache stg-cmds; then
            _stg_cmds=(
                ${${${(M)${(f)"$(stg help 2> /dev/null)"}## *}#  }/#(#b)([^[:space:]]##)[[:space:]]##(*)/$match[1]:$match[2]}
            )
            if (( $? == 0 )); then
                _store_cache stg-cmds _stg_cmds
            else
                unset _stg_cmds
            fi
        fi
    fi

    case $state in
        (command)
            __stg_subcommands && ret=0
            ;;
        (args)
            local -a subcmd_args
            local subcmd=$words[1]
            curcontext="${curcontext%:*:*}:stg-$subcmd:"
            if ! _call_function ret _stg-$subcmd; then
                _message "unknown sub-command: $subcmd"
            fi
            ;;
    esac

    return ret
}

_stgit "$@"
