# dotfiles

Личный терминальный сетап под macOS: Ghostty + Zsh + Starship + tmux + Neovim,
собранные в единой приглушённой тёмной палитре с одним тёплым акцентом
(`#d97757`) — в духе интерфейса Claude Code: спокойный монохромный фон,
акцент только там, где он что-то значит (курсор, активная панель, промпт,
режим редактора, ошибки).

## Состав

| Инструмент | Роль | Конфиг |
|---|---|---|
| [Ghostty](https://ghostty.org) | Терминальный эмулятор | `config/ghostty/config` |
| Zsh | Оболочка (без фреймворков вроде oh-my-zsh) | `zsh/.zshrc` |
| [Starship](https://starship.rs) | Промпт | `config/starship.toml` |
| [tmux](https://github.com/tmux/tmux) | Мультиплексор терминала | `tmux/.tmux.conf` |
| [Neovim](https://neovim.io) | Редактор, IDE-конфиг на `lazy.nvim` | `config/nvim/` |
| Git | `delta` как пейджер для диффов | `git/.gitconfig` |

Инструкции по повседневному использованию — в [CHEATSHEET.md](./CHEATSHEET.md).

## Установка на новую машину

```sh
git clone https://github.com/Uzalov-Gamid/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Скрипт идемпотентный: ставит Homebrew (если его нет), пакеты из `Brewfile`,
Nerd Font, бэкапит любые существующие конфиги в `~/dotfiles-backup-<дата>`
и симлинкует файлы этого репозитория на их обычные места
(`~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig`, `~/.config/nvim`, ...).
Ничего не перезаписывается без бэкапа.

После установки: `exec zsh`, открой Ghostty заново, и в tmux нажми
`prefix + I`, если плагины ещё не подтянулись сами.

## Как это устроено

Репозиторий — источник истины. Реальные файлы (`~/.zshrc` и т.д.) —
симлинки на файлы отсюда, так что правки конфига = правки файлов в
`~/dotfiles`, которые можно закоммитить и запушить как обычно:

```sh
cd ~/dotfiles
git add -A
git commit -m "tweak tmux status bar"
git push
```

## Палитра

Одна и та же палитра используется в Ghostty, tmux, Neovim (`colors/claude.lua`)
и Starship, поэтому всё выглядит как одна система, а не набор случайных тем.

| | Hex | Где |
|---|---|---|
| фон | `#161616` | фон терминала/редактора |
| текст | `#d7d7d7` | основной текст |
| приглушённый | `#666666` / `#8a8a8a` | комментарии, второстепенный текст |
| **акцент** | `#d97757` | курсор, активная граница панели, промпт, заголовки |
| red/green/yellow/blue/purple/cyan | из `config/ghostty/config` | диагностика, git-статус, синтаксис |

## Neovim: что внутри

Плагин-менеджер — [lazy.nvim](https://github.com/folke/lazy.nvim), LSP-серверы
ставятся через [mason.nvim](https://github.com/williamboman/mason.nvim).
Разбивка конфига:

```
config/nvim/
├── init.lua                  — точка входа
├── colors/claude.lua         — тема
└── lua/
    ├── config/                — options / keymaps / autocmds / lazy bootstrap
    └── plugins/
        ├── ui.lua             — lualine, which-key, nvim-tree, indent-blankline
        ├── editor.lua         — telescope, treesitter, gitsigns, trouble, ...
        ├── lsp.lua            — mason + lspconfig
        └── cmp.lua            — blink.cmp (автодополнение)
```

По умолчанию поставлены LSP для Lua, Python (pyright + ruff), TypeScript/JS,
Bash, JSON, YAML, Markdown. Остальные ставятся через `:Mason`.
