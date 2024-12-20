# ==================== History ====================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_SPACE # Ignore commands prefixed with space
setopt HIST_IGNORE_DUPS  # Ignore duplicate lines
setopt SHARE_HISTORY     # Share history between sessions


# ===================== Prompt ====================

PURE_GIT_PULL = 0 # Prevents pure from git pulling when cding into dir

if [[ "$OSTYPE" == darwin* ]]; then
  fpath += ("$(brew --prefix)/share/zsh/site-functions")
else
  fpath += ($HOME/.zsh/pure)
fi

autoload -U promptinit; promptinit
prompt pure


# ================ Keybindings ====================

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word 
bindkey "^[[Z" reverse-menu-complete # enables shift+tab


# =================== Plugins  ====================

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ================ Completions ====================

autoload -Uz compinit
compinit


