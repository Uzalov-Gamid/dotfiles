# dotfiles — `~/.config` моего MacBook

Этот репозиторий — **сама папка `~/.config`**. Никаких симлинков и
скриптов-установщиков: программы читают конфиги прямо отсюда, а git просто
следит за этой папкой.

- Поменял конфиг → он уже работает (после перезагрузки программы, см. ниже).
- Хочешь сохранить изменения → `cd ~/.config && git add -A && git commit -m "..." && git push`
  (в fish есть сокращение `dots` = перейти сюда и показать статус).
- В git попадает только то, что явно разрешено в [`.gitignore`](.gitignore)
  (белый список). Токены и личные данные (`gh/`, `ticktick-cli/`, ключи atuin,
  диск виртуалки Colima, кэши Raycast и т.п.) **никогда не уходят на GitHub**.
  Чтобы добавить новый конфиг в репо — допиши строку `!/имя-папки/` в `.gitignore`.

Палитра везде одна — **Gruvbox** (тёмный фон; «активное» — голубой `#7daea3`, в терминале/tmux акцент — оранжевый `#e5784c`).

---

## Как всё связано

```
вход в систему
 ├─ AeroSpace (Login Item) ──── тайлинг окон, спейсы, хоткеи alt-…
 │    ├─ запускает borders ─── свечение вокруг активного окна
 │    └─ шлёт события ───────► SketchyBar (верхний бар)
 ├─ SketchyBar (brew services) ─ бар: спейсы, иконки приложений, виджеты
 ├─ Karabiner-Elements ──────── переназначение клавиш (Caps ↔ Ctrl, Fn+HJKL)
 └─ Ice, Raycast, Handy, OneMenu (Login Items, настраиваются в их GUI)

терминал
 Ghostty ─► fish (+ Tide промпт, atuin, zoxide, fzf) ─► tmux ─► Neovim (LazyVim)
```

| Папка | Программа | Что делает | Статус |
|---|---|---|---|
| `aerospace/` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Тайлинговый оконный менеджер | ✅ работает |
| `borders/` | [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Подсветка активного окна | ✅ работает |
| `sketchybar/` | [SketchyBar](https://github.com/FelixKratz/SketchyBar) | Верхний бар вместо меню macOS | ✅ работает |
| `karabiner/` | [Karabiner-Elements](https://karabiner-elements.pqrs.org) | Переназначение клавиш | ✅ работает |
| `fish/` | [fish](https://fishshell.com) + [Tide](https://github.com/IlanCosman/tide) | Основная оболочка | ✅ работает |
| `ghostty/` | [Ghostty](https://ghostty.org) | Терминал | ✅ работает |
| `tmux/` | [tmux](https://github.com/tmux/tmux) | Мультиплексор терминала | ✅ работает |
| `nvim/` | [Neovim](https://neovim.io) + [LazyVim](https://lazyvim.org) | Редактор | ✅ работает |
| `git/` | git + [delta](https://github.com/dandavison/delta) | Имя/почта, красивые диффы, алиасы | ✅ работает |
| `atuin/` | [atuin](https://atuin.sh) | История команд с поиском (`Ctrl-R`) | ✅ работает |
| `zsh/` | zsh + Starship (`starship.toml`) | Запасная оболочка (её используют скрипты и Claude Code) | ✅ работает |
| `btop/`, `htop/` | btop / htop | Мониторы процессов | ✅ |
| `fastfetch/` | fastfetch | Инфо о системе (`ff`) | ✅ |
| `zed/` | Zed | Редактор: vim-режим, тема | ✅ |
| `colima/` | [Colima](https://github.com/abiosoft/colima) | Docker без Docker Desktop: VM 4 CPU / 6 GB / 40 GB | ✅ |

---

## AeroSpace — окна и спейсы

Конфиг: [`aerospace/aerospace.toml`](aerospace/aerospace.toml).
AeroSpace сам раскладывает окна по экрану (как i3 на Linux) и даёт
**именованные спейсы** вместо нумерованных рабочих столов macOS.

### Спейсы

Все спейсы постоянные (`persistent-workspaces`) — существуют, даже когда пустые.

| Спейс | Перейти | Перенести окно туда | Кто попадает автоматически |
|---|---|---|---|
| `main` | `alt-m` | `alt-shift-m` | VS Code |
| `sec` | `alt-s` | `alt-shift-s` | Spotify |
| `brwse` | `alt-o` | `alt-shift-o` | Safari, Helium, Zen |
| `note` | `alt-n` | `alt-shift-n` | Obsidian, ZenNotes |
| `ai` | `alt-i` | `alt-shift-i` | ChatGPT, Gemini |
| `chat` | `alt-t` | `alt-shift-t` | Telegram, Messages, Mail, Rocket.Chat |
| `vpn` | `alt-v` | `alt-shift-v` | Happ, Incy |
| `Cal&Rem` | `alt-r` | `alt-shift-r` | — (кладёшь окна сам) |
| `term` | `alt-g` | `alt-shift-g` | Ghostty |

Finder и QuickTime всегда открываются **плавающими** (не тайлятся).

> Правило «приложение → спейс» — это блок `[[on-window-detected]]` в конце
> конфига. Bundle ID приложения узнать: `aerospace list-apps`.
> Имя `Cal&Rem` в командах пишется в кавычках (`'workspace "Cal&Rem"'`),
> потому что `&` — служебный символ AeroSpace.

### Окна

| Клавиши | Действие |
|---|---|
| `alt-h/j/k/l` | Фокус на окно слева/снизу/сверху/справа |
| `alt-shift-h/j/k/l` | Передвинуть окно |
| `alt-minus` / `alt-equal` | Уменьшить / увеличить окно |
| `alt-slash` | Раскладка «плитки» (окна рядом) |
| `alt-comma` | Раскладка «аккордеон» (окна стопкой, видно края) — **по умолчанию** |
| `alt-tab` | Вернуться на предыдущий спейс |
| `alt-shift-tab` | Перенести спейс на другой монитор |

### Сервисный режим — `alt-shift-;`

Бар покажет `[S]` под именем спейса. Дальше одна клавиша:

| Клавиша | Действие |
|---|---|
| `esc` | **Перечитать конфиг** и выйти |
| `r` | Сбросить раскладку спейса |
| `f` | Окно: плавающее ↔ тайловое |
| `backspace` | Закрыть все окна спейса, кроме текущего |
| `alt-shift-h/j/k/l` | Объединить окно с соседним в группу |

### Связь с SketchyBar

При смене спейса, фокуса или режима AeroSpace шлёт в SketchyBar события
`aerospace_refresh` / `aerospace_mode_change` — так бар узнаёт, что
перерисовать. Это строки `exec-on-workspace-change`, `on-focus-changed`,
`on-mode-changed` в начале конфига.

---

## borders — свечение активного окна

Конфиг: [`borders/bordersrc`](borders/bordersrc). Запускается AeroSpace'ом при старте.

Вместо тонкой рамки активное окно окружено **мягким голубым
свечением** (`glow`) — тем же голубым `#7daea3`, которым в баре отмечено всё
активное (текущий спейс, активное приложение, иконки виджетов), которое рисуется *под* окном (`order=below`). Рамка
повторяет идеальный скруглённый прямоугольник и поэтому не совпадает с углами
приложений (у всех разное скругление), а свечение размыто и прикрыто углами
самого окна — выглядит как цветная тень.

Настройка:
- сила свечения — первые две цифры в `glow(0x`**`b3`**`7daea3)`: `ff` — максимум, `80` — вдвое слабее;
- другой цвет — последние шесть цифр (RGB); готовые варианты из палитры (оранжевый, розовый, зелёный, кремовый) лежат комментарием в файле;
- ширина ореола — `width=8.0`;
- вернуть старую тонкую рамку — закомментированная строка внизу options.

Применить: `pkill borders; ~/.config/borders/bordersrc &` (или `alt-shift-;` → `esc`).

---

## SketchyBar — верхний бар

Конфиг написан на Lua ([SbarLua](https://github.com/FelixKratz/SbarLua)).
Запускается через `brew services`. Перезапуск: `sketchybar --reload`.

```
sketchybar/
├── sketchybarrc          — точка входа (запускает Lua)
├── init.lua              — собирает бар: bar.lua + items/
├── bar.lua               — сам бар (высота 33, чёрный фон)
├── settings.lua          — ВСЕ размеры, шрифты, частоты обновления, пороги
├── colors.lua            — палитра Gruvbox (+ закомментированная Tokyonight)
├── icons.lua             — SF Symbols всех виджетов
├── helpers/
│   ├── capsule.lua       — общий вид капсулы и всплывающих окошек (попапов)
│   ├── app_icons.lua     — имя приложения → иконка шрифта sketchybar-app-font
│   ├── scripts/music_info.applescript — читает трек из Apple Music
│   ├── scripts/music_artwork.applescript — достаёт обложку (кэш в ~/.cache/sketchybar)
│   ├── scripts/check_gaps.sh — проверка: все промежутки равны, под чёлкой пусто
│   └── event_providers/cpu_load — маленькая C-программа, считает загрузку CPU
└── items/widgets/        — по файлу на виджет; порядок задаёт init.lua
```

### Как выглядит

Каждый виджет справа — **одна капсула: цветная иконка SF Symbols + белое
число**. Общий стиль капсулы описан один раз в `helpers/capsule.lua`
(фон, скругление, отступы: 8 pt от края капсулы до содержимого, 6 pt от иконки до текста) — поменяешь там, поменяются все виджеты.
Расстояние между всеми капсулами одинаковое — 7 pt (`settings.lua → paddings.container_paddings`),
от краёв экрана — 9 pt (`paddings.edge_padding`).
**Проверка после любых правок бара:** `skcheck` (в fish) или
`~/.config/sketchybar/helpers/scripts/check_gaps.sh` — меряет все капсулы и
пишет ✓, либо какие две капсулы стоят неровно / какая залезла под чёлку.
Сами иконки — в `icons.lua`.

```
 [main 􀙇 …] [🖼 Трек]   ▓▓ чёлка ▓▓   [􀙇 EN] [􀄬] [􀫦 63%] [􀫥 12%] [􀊩 19%] [􀛨 96%] [􀉉 22/10 17:39]
```

### Чёлка (MacBook Air 15")

Вырез камеры занимает 179 pt посередине экрана (x = 646…825 из 1470).
- `settings.lua → ui.notch_width = 190` — SketchyBar знает ширину чёлки
  (пригодится для позиций `q`/`e`: вплотную слева/справа от выреза).
- Музыка стоит сразу за блоком спейсов. Название длиннее 28 символов
  прокручивается, поэтому даже со спейсом на 10 приложений плеер
  заканчивается до чёлки.
- Правые виджеты заканчиваются на x ≈ 908, т.е. ~80 pt до чёлки в запасе.
  Добавляешь новый виджет справа — проверь, что он влезает:
  `sketchybar --query widgets.network.down | jq '.bounding_rects'`
  (`origin[0]` должен быть больше 830).

### Что на баре (слева направо)

| Виджет | Файл | Что показывает | Взаимодействие |
|---|---|---|---|
| Спейс + приложения | `aerospace_d.lua` | Имя текущего спейса, иконка активного приложения (синяя) и остальных в этом спейсе (серые). `[S]` — сервисный режим | — |
| 􀑪 Музыка | `music.lua` | **Обложка альбома + название трека** из Apple Music. Серое = на паузе. Скрыт, если Music закрыт или остановлен | **ЛКМ — карточка**: большая обложка, трек, исполнитель · альбом, кнопки ⏮ ⏯ ⏭. ПКМ — пауза/play |
| Сеть + раскладка | `system.lua` | Иконка: Wi-Fi / Ethernet / хотспот; щит = VPN включён; красная = нет сети. Текст — раскладка `EN`/`RU` | — |
| 􀄬 Сеть | `network.lua` | Только иконка, её цвет = активность: серая — тишина, синяя — идёт трафик, зелёная — > 1 МБ/с | **ЛКМ — окошко**: скорость загрузки/отдачи (обновляется живьём), сеть, локальный и внешний IP, VPN. Уводишь мышь с бара — закрывается |
| 􀫦 Память | `ram.lua` | Занятая память, %. Иконка: синяя → жёлтая > 60 → оранжевая > 75 → красная > 90 | — |
| 􀫥 Процессор | `cpu.lua` | Загрузка CPU. Иконка: > 30 жёлтая, > 60 оранжевая, > 80 красная | — |
| 􀊩 Громкость | `volume.lua` | Громкость; динамик меняется по уровню, серый = 0 | — |
| 􀛨 Батарея | `battery.lua` | Заряд; иконка показывает уровень, ⚡ зелёная = зарядка, красная < 20% | — |
| 􀉉 Дата/время | `calendar.lua` | `ДД/ММ  ЧЧ:ММ` | — |

`aerospace.lua` в той же папке — альтернативный вариант (показывает все
спейсы сразу), сейчас не подключён. Чтобы переключиться — в
`items/widgets/init.lua` заменить `aerospace_d` на `aerospace`.

### Как поменять

- Порядок/набор виджетов — `items/widgets/init.lua`. Правые виджеты
  добавляются **справа налево**: первый в списке — самый правый.
- Частоты обновления и пороги цветов — `settings.lua` → `widgets`.
- Попап для своего виджета: `capsule.attach_popup(item)` + строки `capsule.popup_row(...)`
  (пример — `network.lua`).
- Имя Wi-Fi в попапе показывается как «Wi-Fi»: macOS 26 скрывает название сети от
  программ без доступа к геолокации.
- Код SF-символа удобно копировать из приложения [SF Symbols](https://developer.apple.com/sf-symbols/) (правый клик → Copy Symbol).
- Иконка для нового приложения — строка в `helpers/app_icons.lua`
  (имя приложения → `:имя_иконки:` из [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font)).

---

## Karabiner-Elements — клавиатура

Конфиг: [`karabiner/karabiner.json`](karabiner/karabiner.json) (лучше менять через GUI Karabiner).

| Клавиша | Становится |
|---|---|
| `Caps Lock` | `Control` |
| `Left Control` | `Caps Lock` |
| `Fn + H/J/K/L` | Стрелки ← ↓ ↑ → (vim-стиль, везде) |
| Двойной `Fn` | Контекстное меню (`Shift+Fn+F10`) |

---

## Терминал

### Ghostty — [`ghostty/config.ghostty`](ghostty/config.ghostty)

Тема Gruvbox Dark, шрифт **0xProto Nerd Font**, без заголовка окна и кнопок.
`Option` работает как `Alt` (нужно для хоткеев fish/tmux/nvim).
**Quick terminal** — выпадающий терминал по центру экрана: `alt-1` (или `cmd-F20`) из любого приложения.
В `ghostty/shaders/` — коллекция шейдеров-эффектов курсора (не включены; подключаются строкой `custom-shader = ...`).

### fish — [`fish/config.fish`](fish/config.fish)

Основная оболочка. Плагины ставит [fisher](https://github.com/jorgebucaran/fisher) по списку `fish/fish_plugins` (сейчас — промпт Tide; его настройки в `fish/tide.config.fish`).

- **vi-режим** ввода (`Esc` → normal, `y` в visual копирует в буфер обмена).
- `Ctrl-R` — история через **atuin** (Enter сразу выполняет команду).
- `cd` = **zoxide** (`cd proj` прыгает в часто посещаемую папку с «proj» в имени).
- `ls` = `lsd -lah`, `n` = nvim, `c` = clear, `ff` = fastfetch, `yz` = yazi, `lg` = lazygit.
- `rm` **кладёт файлы в Корзину** (`/usr/bin/trash`) — флаги `-r/-f` можно писать, они игнорируются. Удалить насовсем: `command rm`.
- `cheat <команда>` — шпаргалка с cheat.sh. `ip` — твой внешний IP.
- Git: `gs` status, `ga` add, `gcm` commit -m, `gp` push, `gpl` pull, `gl` граф, `gd` diff, `grv` remotes …
- Go: `gr` go run, `gm` go mod, `gmt` go mod tidy. Docker: `dops`, `doco`, `doe`.
- Конфиги: `fishconf`, `asconf` (AeroSpace), `skconf` (SketchyBar), `bordersconf`, `gconf` (Ghostty), `tmuxconf`, `nvimconf`, `karaconf`, `asrc` — перечитать fish.
- School 21: `dohelp21` — справка по Docker-контейнеру школы (`buildcont21`, `docreate21`, `doon21`, `do21`, `dooff21`).
- `Ctrl-\` — очистить экран, сохранив прокрутку.

> Это *abbr* (сокращения): набираешь `gs` + пробел — разворачивается в полную команду.

### tmux — [`tmux/tmux.conf`](tmux/tmux.conf)

Префикс стандартный: **`Ctrl-b`** (с Karabiner — `Caps+b`). Статус-бар сверху, окна нумеруются с 1.

| Клавиши | Действие |
|---|---|
| `prefix r` | Перечитать конфиг |
| `prefix b` | Плавающее окно (плагин floax) |
| `prefix Ctrl-←↓↑→` | Изменить размер панели |
| `Ctrl-Shift-↑/↓` | Переставить окно влево/вправо |
| `Ctrl-h/j/k/l` | Переход между панелями tmux **и** окнами nvim (vim-tmux-navigator) |
| `prefix [` → `v` … `y` | Выделить и скопировать в буфер macOS |
| `prefix I` | Установить плагины (TPM) |

### Neovim — `nvim/` (LazyVim)

Основа — [LazyVim](https://lazyvim.org) (`Space` — leader, `Space` и подожди — меню which-key).
Подключённые extras (`nvim/lazyvim.json`): языки Go, Python, C/C++ (clangd, cmake), SQL, Docker, YAML, TOML, Markdown, Gleam; neo-tree, telescope, mini-surround.
Свои плагины — `nvim/lua/plugins/`: темы (gruvbox, catppuccin, kanagawa, tokyonight), базы данных (vim-dadbod + UI, sqls), conform (форматирование), vim-rooter, vim-tmux-navigator, cellular-automaton (`:CellularAutomaton make_it_rain` 🙂).
Свои клавиши (`nvim/lua/config/keymaps.lua`): `p`/`P` в visual поменяны местами (вставка не портит буфер), `a` на пустой строке сразу ставит правильный отступ, `Ctrl-j` в insert — принять подсказку Copilot, `:dash` — стартовый экран.

### git — [`git/config`](git/config)

Git сам читает `~/.config/git/config`. Пейджер — **delta** (подсветка, номера строк), `push` сам создаёт upstream, `pull` — merge.
Алиасы: `git st`, `co`, `br`, `ci`, `last`, `lg` (граф), `amend`.

### zsh — [`zsh/`](zsh/)

Не основная оболочка, но её используют скрипты и Claude Code. Единственный файл вне `~/.config` — `~/.zshenv` из одной строки
`export ZDOTDIR="$HOME/.config/zsh"`, которая говорит zsh искать `.zshrc`/`.zprofile` здесь. Промпт — Starship (`starship.toml`).

---

## Удалено: yabai и skhd

Раньше здесь был ещё оконный менеджер yabai (+ skhd для его хоткеев). Он
работал **параллельно** с AeroSpace, но ничего не делал: его единственная задача
была полупрозрачность окон, а она требует отключения SIP (защиты macOS).
yabai удалён полностью (`brew uninstall`, сервис автозапуска, конфиги);
его конфиги остались в истории git (коммит `e05d57e`).

---

## Восстановить на новом Mac

```sh
# 1. программы
brew install fish tmux neovim git git-delta lsd zoxide fzf atuin yazi lazygit \
  fastfetch btop htop colima lua switchaudio-osx nowplaying-cli jq
brew install --cask aerospace ghostty karabiner-elements font-sketchybar-app-font
brew tap FelixKratz/formulae && brew install sketchybar borders
# SbarLua (Lua-модуль для SketchyBar):
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua && make install)

# 2. конфиги
mv ~/.config ~/.config.bak 2>/dev/null
git clone https://github.com/Uzalov-Gamid/dotfiles.git ~/.config
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

# 3. запуск
brew services start sketchybar
chsh -s /opt/homebrew/bin/fish   # (сначала добавить путь в /etc/shells)
fish -c 'fisher update'          # поставит Tide
open -a AeroSpace
```

Шрифты: SF Pro (Apple), 0xProto Nerd Font (`brew install --cask font-0xproto-nerd-font`).

## История

Предыдущий вариант репозитория (zsh + Starship + tmux + свой Neovim в тёплой
палитре «как Claude Code») сохранён под тегом `legacy-zsh-rig`:
`git checkout legacy-zsh-rig` — посмотреть, `git checkout main` — вернуться.
