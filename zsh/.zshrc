# Minimalist, mostly framework-free Zsh setup.
# Styled to match the rest of this rig: Ghostty, tmux, Neovim, Starship.

export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"

typeset -U path PATH
path=("$HOME/.local/bin" $path)

# History
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
mkdir -p "${HISTFILE:h}"

setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt prompt_subst

# Completion
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"

zstyle ":completion:*" menu select
zstyle ":completion:*" group-name ""
zstyle ":completion:*" list-colors ""
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zstyle ":completion:*:descriptions" format "%F{8}%d%f"

# Familiar editing keys with prefix-aware history search.
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^R" history-incremental-search-backward

# Prompt: Starship, configured in ~/.config/starship.toml to match the
# quiet two-line look this setup had before (directory + git, then a
# single accent-colored arrow).
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Small conveniences; no shell framework and no icon font required.
alias v="nvim"
alias g="git"
alias lg="lazygit"
alias c="clear"
alias reload="source ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

if (( $+commands[eza] )); then
  alias ls="eza --group-directories-first --icons=auto"
  alias ll="eza -la --group-directories-first --icons=auto --git"
  alias tree="eza --tree --level=2 --group-directories-first --icons=auto"
else
  alias ls="ls -G"
  alias ll="ls -lahG"
fi

if (( $+commands[bat] )); then
  alias b="bat --paging=never --style=plain"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

mkcd() {
  if (( $# != 1 )); then
    print -u2 "usage: mkcd <directory>"
    return 2
  fi
  mkdir -p -- "$1" && builtin cd -- "$1"
}

# tmux: attach to a shared session named after the current directory, or
# create one. `tm` is the one command worth remembering.
tm() {
  local session="${1:-$(basename "$PWD" | tr . _)}"
  if [[ -z "$TMUX" ]]; then
    tmux new-session -A -s "$session"
  else
    tmux switch-client -t "$session" 2>/dev/null || tmux new-session -d -s "$session" && tmux switch-client -t "$session"
  fi
}

if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=none --info=inline --prompt='› ' --pointer='›' --marker='+' --color=16"
  source <(fzf --zsh)
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# Autosuggestions + syntax highlighting (Homebrew formulae). Highlighting
# must be sourced last, after anything else that touches widgets.
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
  bindkey '^ ' autosuggest-accept
fi

if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_STYLES[default]="none"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=1"
  ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=4"
  ZSH_HIGHLIGHT_STYLES[alias]="fg=6"
  ZSH_HIGHLIGHT_STYLES[builtin]="fg=6"
  ZSH_HIGHLIGHT_STYLES[function]="fg=6"
  ZSH_HIGHLIGHT_STYLES[command]="fg=2"
  ZSH_HIGHLIGHT_STYLES[path]="fg=7,underline"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=3"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=3"
fi
