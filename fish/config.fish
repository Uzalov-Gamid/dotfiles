if status is-interactive
    fish_vi_key_bindings
end

zoxide init fish | source

# thefuck --alias | source

fzf --fish | source

source "$HOME/.atuin/bin/env.fish" 2>/dev/null; or true
atuin init fish | source

# starship init fish | source

set -g fish_color_autosuggestion 585b70

set -gx EDITOR nvim
set -gx VISUAL nvim

fish_add_path "$HOME/.local/bin"
bind -M visual -m default y fish_clipboard_copy end-selection repaint-mode

source "$HOME/.config/fish/tide.config.fish"

abbr -a asrc "source ~/.config/fish/config.fish"

abbr -a fishconf "nvim ~/.config/fish/config.fish"
abbr -a zshconf "nvim ~/.zshrc"
abbr -a nvimconf "nvim ~/.config/nvim"
abbr -a atuinconf "nvim ~/.config/atuin/config.toml"
abbr -a asconf "nvim ~/.config/aerospace/aerospace.toml"
abbr -a tmuxconf "nvim ~/.config/tmux/tmux.conf"
abbr -a gconf "nvim ~/.config/ghostty/config.ghostty"
abbr -a skconf "nvim ~/.config/sketchybar"
abbr -a ssconf "nvim ~/.config/starship.toml"
abbr -a bordersconf "nvim ~/.config/borders/bordersrc"
abbr -a svimconf "nvim ~/.config/svim/blacklist"
abbr -a ffconf "nvim ~/.config/fastfetch"
abbr -a niriconf "nvim ~/.config/niri/"
abbr -a riftconf "nvim ~/.config/rift/config.toml"
abbr -a ybconf "nvim ~/.config/yabai/"
abbr -a skhdconf "nvim ~/.config/skhd/skhdrc"
abbr -a sqlsconf "nvim ~/.config/sqls/config.yml"

abbr -a cm chezmoi
abbr -a ip "curl ipinfo.io"
abbr -a ta "tmux a"
abbr -a tn tmux
alias kick "NVIM_APPNAME=nvim-kickstart nvim"

abbr -a lg lazygit
abbr -a gs "git status -sb"
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gcm "git commit -m"
abbr -a gp "git push"
abbr -a gpl "git pull"
abbr -a gb "git branch"
abbr -a gco "git checkout"
abbr -a gsw "git switch"
abbr -a gl "git log --graph --decorate --all"
abbr -a glo "git log --oneline"
abbr -a gd "git diff"
abbr -a gr "git remote -v"
abbr -a gcl "git clone"

abbr -a dops "docker ps"
abbr -a doco "docker compose"
abbr -a doe "docker exec"

abbr -a gr "go run"
abbr -a gm "go mod"
abbr -a gmt "go mod tidy"

function cheat
    curl -s "https://cheat.sh/$argv"
end

alias ff "fastfetch --config ~/.config/fastfetch/apple.jsonc"
abbr -a c clear
alias cd z
alias rm rmt
# alias ls lsd
alias ls "lsd -lah --group-dirs first"
alias n nvim
alias cal "~/go/bin/calendar"
abbr -a yz yazi

alias nl "NVIM_APPNAME=nvim-lazy nvim"

bind ctrl-\\ 'status test-terminal-feature scroll-content-up && commandline -f scrollback-push; commandline -f clear-screen'
bind -M insert ctrl-\\ 'status test-terminal-feature scroll-content-up && commandline -f scrollback-push; commandline -f clear-screen'
bind -M visual ctrl-\\ 'status test-terminal-feature scroll-content-up && commandline -f scrollback-push; commandline -f clear-screen'

alias buildcont21="docker-buildx build -t s21_env ."

function docreate21
    docker run -it -d --name school-container \
        --hostname lnx-wady \
        -v ~/Projects/School:/home/school \
        -v ~/.ssh:/root/.ssh:ro \
        -v ~/.config/git/config:/root/.gitconfig:ro \
        -v ~/Projects/School/.zshrc_docker:/root/.zshrc \
        s21_env
end

abbr -a doon21 "docker start school-container"
abbr -a do21 "docker exec -it school-container zsh"
abbr -a dooff21 "docker stop school-container"

function dohelp21
    echo "Managing S21 container:
  buildcont21 - build s21_env from dependency list
  docreate21  - First-boot
  doon21      - Start if off
  do21        - Enter Linux lol
  dooff21     - Stop

Dirs:
  Host:   ~/Projects/School  ->  Container: /home/school
  Git:    ~/.config/git/config"
end

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
