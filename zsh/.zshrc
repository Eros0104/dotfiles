# ==================== History ====================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_SPACE # Ignore commands prefixed with space
setopt HIST_IGNORE_DUPS  # Ignore duplicate lines
setopt SHARE_HISTORY     # Share history between sessions


# ===================== Prompt ====================

PURE_GIT_PULL=0 # Prevents pure from git pulling when cding into dir

if [[ "$OSTYPE" == darwin* ]]; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
else
  fpath+=($HOME/.zsh/pure)
fi

autoload -U promptinit; promptinit
prompt pure


# ================ Keybindings ====================

bindkey "^[[1;5C" forward-word       # Move the cursor to the next word (Ctrl+→)
bindkey "^[[1;5D" backward-word      # Move the cursor to the previous word (Ctrl+←)
bindkey "^[[Z" reverse-menu-complete # Enables reverse navigation in autocomplete (Shift+Tab)
bindkey -v "^?" backward-delete-char # Fixes Backspace behavior in vi mode


# =================== Plugins  ====================

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ================ Completions ====================

autoload -Uz compinit
compinit


# ==================== Aliases ====================

# ls
alias la='ls -lathr'

# go
alias gocov='go test -coverprofile=cover.out && go tool cover -html=cover.out'
alias gocovr='go test ./... -coverprofile=cover.out && go tool cover -html=cover.out'

# docker
alias wakethewhale='docker start $(docker container list -qa)'  # start all containers
alias zapthewhale='docker restart $(docker container list -qa)' # restart all containers

# ====================== Paths ====================

if [ -f ~/.zsh_paths ]; then
  source ~/.zsh_paths
fi

if [ -f ~/.zsh_extras ]; then
  source ~/.zsh_extras
fi

# ======================= Misc ====================

# enable vim motions
set -o vi


