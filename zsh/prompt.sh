# Activate colors!
autoload -Uz colors && colors
setopt prompt_subst

local bold="%{$terminfo[bold]%}"
local black="%{$fg[black]%}"
local red="%{$fg[red]%}"
local green="%{$fg[green]%}"
local yellow="%{$fg[yellow]%}"
local magenta="%{$fg[magenta]%}"
local blue="%{$fg[blue]%}"
local cyan="%{$fg[cyan]%}"
local white="%{$fg[white]%}"
local reset="%{$reset_color%}"

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_MERGING="😨 "
GIT_PROMPT_REBASE="😰 "
GIT_PROMPT_DETACHED="🔥 "
GIT_PROMPT_UNTRACKED="%{$red%}●%{$reset%}"
GIT_PROMPT_MODIFIED="%{$red%}●%{$reset%}"
GIT_PROMPT_STAGED="%{$yellow%}●%{$reset%}"
GIT_PROMPT_GOOD="%{$green%}●%{$reset%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [ -n $GIT_DIR ] && test -d $GIT_DIR/rebase-merge -o -d $GIT_DIR/rebase-apply; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_REBASE
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if [[ -n $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | grep detached) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_DETACHED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo " $GIT_STATE"
  else
    echo " $GIT_PROMPT_GOOD"
  fi

}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo " on git:$cyan${git_where#(refs/heads/|tags/)}$reset$(parse_git_state)"
}


local current_dir='%~'
local status_indicator="$bold%(?.%(!.$red.$green).$red)→$reset "
local git_info='$(git_prompt_string)'


# Prompt format: \n # USER at MACHINE in DIRECTORY on git:BRANCH STATE [TIME] \n $
PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$cyan%}%n \
%{$white%}in \
$bold$yellow$current_dir$reset\
$git_info \
%{$white%}[$(date +'%H:%M:%S')]
$status_indicator"
