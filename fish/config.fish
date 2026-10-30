# no "Welcome to fish" greeting
set -g fish_greeting

# Homebrew first in PATH, so brew's git/curl/python3 win over /usr/bin
/opt/homebrew/bin/brew shellenv fish | source

if status is-interactive
    fish_vi_key_bindings
end

# smart cd: `cd name` jumps to the best match from history, `cdi` opens an fzf picker
zoxide init --cmd cd fish | source

fzf --fish | source

# fzf popup on Tab (fifc plugin, listed in fish_plugins); folders preview with lsd
# list only the current directory, not everything below it
set -gx fifc_fd_opts --max-depth 1 --hidden
set -gx fifc_find_opts -maxdepth 1
# preview takes two thirds of the popup
set -gx fifc_custom_fzf_opts --preview-window=right:66%
set -gx fifc_folders_preview_cmd 'lsd -1 --icon always --color always --group-dirs first {}'

# Folder list with icons (like `ls`), regular folders first, hidden ones at the bottom.
# Entries look like "<icon> <typed path>name/"; the icon is cut off again on selection (-e).
function _dirs_with_icons
    set -l typed (string unescape -- "$fifc_token")
    set -l prefix ""
    set -l dir .
    if string match -q '*/*' -- $typed
        set prefix (string replace -r '[^/]*$' '' -- $typed)
        set dir (string replace -r '^~' $HOME -- $prefix)
    end
    lsd -A1F --icon always --color never --group-dirs first -- $dir 2>/dev/null | grep '/$' \
        | awk -v p="$prefix" '{ i = $1; n = substr($0, length(i) + 2); print ((n ~ /^\./) ? 1 : 0) "\t" i " " p n }' \
        | sort -s -t (printf '\t') -k1,1 | cut -f2- \
        | awk '{ printf "\033[1;34m%s\033[0m\n", $0 }'
end
fifc -O 1 -n 'test "$fifc_group" = directories' \
    -s '_dirs_with_icons | cat' \
    -e '^\S+ (.+)$' \
    -p 'lsd -1 --icon always --color always --group-dirs first -- (string replace -r "^~" $HOME -- "$fifc_extracted") 2>/dev/null'

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
abbr -a zshconf "nvim ~/.config/zsh/.zshrc"
abbr -a nvimconf "nvim ~/.config/nvim/init.lua"
abbr -a atuinconf "nvim ~/.config/atuin/config.toml"
abbr -a asconf "nvim ~/.config/aerospace/aerospace.toml"
abbr -a tmuxconf "nvim ~/.config/tmux/tmux.conf"
abbr -a gconf "nvim ~/.config/ghostty/config.ghostty"
abbr -a skconf "nvim ~/.config/sketchybar"
abbr -a skcheck "~/.config/sketchybar/helpers/scripts/check_gaps.sh"
abbr -a ssconf "nvim ~/.config/starship.toml"
abbr -a bordersconf "nvim ~/.config/borders/bordersrc"
abbr -a ffconf "nvim ~/.config/fastfetch"
abbr -a karaconf "nvim ~/.config/karabiner/karabiner.json"
abbr -a dots "cd ~/.config && git status -sb"

abbr -a ip "curl ipinfo.io"
abbr -a ta "tmux a"
abbr -a tn tmux

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
abbr -a grv "git remote -v"
abbr -a gcl "git clone"

abbr -a dops "docker ps"
abbr -a doco "docker compose"
abbr -a doe "docker exec"

function cheat
    curl -s "https://cheat.sh/$argv"
end

alias ff "fastfetch --config ~/.config/fastfetch/apple.jsonc"
abbr -a c clear
# rm moves files to the macOS Trash (/usr/bin/trash) instead of deleting
# them for good. rm-style flags (-r, -f, -rf, ...) are accepted and
# dropped, since Trash handles folders anyway. Real rm: `command rm`.
function rm --description 'move files to Trash'
    set -l files
    set -l only_files 0
    for arg in $argv
        if test $only_files -eq 0; and test "$arg" = --
            set only_files 1
        else if test $only_files -eq 0; and string match -qr -- '^-' $arg
            continue
        else
            set -a files $arg
        end
    end
    test (count $files) -gt 0; or return 0
    /usr/bin/trash $files
end
# alias ls lsd
alias ls "lsd -lah --group-dirs first"
alias n nvim
abbr -a yz yazi
# read Markdown in the terminal, astronaut colours, scrollable (q to quit)
alias md "glow -s ~/.config/glow/astronaut.json -p"

bind ctrl-\\ 'status test-terminal-feature scroll-content-up && commandline -f scrollback-push; commandline -f clear-screen'
bind -M insert ctrl-\\ 'status test-terminal-feature scroll-content-up && commandline -f scrollback-push; commandline -f clear-screen'
bind -M visual ctrl-\\ 'status test-terminal-feature scroll-content-up && commandline -f scrollback-push; commandline -f clear-screen'

alias buildcont21="docker-buildx build -t s21_env ."

function docreate21
    docker run -it -d --name school-container \
        --hostname lnx-s21 \
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
