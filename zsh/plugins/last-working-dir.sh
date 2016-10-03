## currently disabled because I wanna try out plugins like enhancd

local cwd_file=${ZSH_CACHE_DIR}/cwd

# Override native cd
# - call native cd
# - write new working dir into $cwd_file
function cd() {
  builtin cd "$@"
  echo "$PWD" > $cwd_file
}
export cd

# Current Working Directory
# - Check if $cwd_file exists
# - Jump to the directory specified there
function cwd() {
  if [[ -f $cwd_file ]]; then
    cd "$(cat $cwd_file)"
  else
    return 1
  fi
}
export cwd

cwd
