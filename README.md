# houston

> *Houston, we have a config.*

Мой macOS: тайлинговые окна, верхняя панель, терминал и редактор — всё в одной
палитре **astronaut**: цвета взяты с обоев (оранжевый, кремовый, тёмное стекло
шлема, олива) плюс голубое свечение активного окна.

![Три окна плитками: редактор, lazygit и yazi, сверху бар SketchyBar](screenshots/tiling.png)

## Всё в картинках

Все кадры сняты на демо-проекте, без личных данных. Верхняя полоса на каждом
кадре — **SketchyBar**; плашки внутри окна сверху и снизу — **tmux** и **Neovim**.

### Окна и рабочий стол

**AeroSpace** раскладывает окна плитками с ровными зазорами, у каждого окна своя
рамка-свечение голубого цвета. Слева в баре — текущий спейс и его приложения,
справа — сеть, раскладка, память, процессор, громкость, батарея, дата.
Скриншот выше: редактор, [lazygit](https://github.com/jesseduffield/lazygit) и
[yazi](https://yazi-rs.github.io) — разные окна одной раскладки (`alt-h/j/k/l`
переходят между ними). Подробнее — [`aerospace/`](aerospace/), [`sketchybar/`](sketchybar/).

### tmux — панели и плавающее окно

Панели с цветной рамкой у активной; сверху сессия, окна, режим (оранжевая плашка
`PREFIX`, пока нажат префикс), папка и git-ветка.

![tmux: три панели и плашка PREFIX](screenshots/tmux-panes.png)

`prefix b` открывает плавающий терминал поверх всего (здесь — `ff`, fastfetch).

![tmux: плавающее окно floax](screenshots/tmux-float.png)

Подробнее и все клавиши — [`tmux/`](tmux/).

### Neovim — без плагинов и LSP

Дерево проекта на `Space e`, иконки по типам файлов, строка состояния в стиле tmux:

![Neovim: дерево проекта и код](screenshots/editor.png)

Строка команд — отдельное окошко по центру (`:` и `/`), подстановка подсвечивается
сразу, пока печатаешь:

![Neovim: окно команд](screenshots/command.png)

`Space r` сохраняет и запускает файл (Python, C, bash, Dockerfile…), вывод — внизу:

![Neovim: запуск кода](screenshots/run.png)

`Space g` — поиск по всему проекту через ripgrep, результаты в списке:

![Neovim: поиск по проекту](screenshots/search.png)

YAML и Dockerfile рядом: линии уровней отступа, правильные 2 пробела:

![Neovim: YAML и Dockerfile](screenshots/yaml.png)

Стартовый экран — мини-профиль: активность GitHub, команды из atuin, время в
редакторе, фаза Луны. Имя и город на кадре — демо, свои лежат в
`nvim/lua/local_profile.lua` (не в репо):

![Стартовый экран Neovim](screenshots/dashboard.png)

Режим чтения Markdown (`Space p`, как в Obsidian), его рисует `glow` в цветах темы:

![Режим чтения Markdown](screenshots/reading.png)

Подробнее и все клавиши — [`nvim/`](nvim/).

### Чего нет на скриншотах

Музыкальная карточка в баре (обложка и кнопки Apple Music), окошко сети (скорость,
IP-адреса) и выпадающий терминал `alt-1` — на кадрах были бы личные данные
(трек, адреса). Как они устроены — в [`sketchybar/`](sketchybar/) и [`ghostty/`](ghostty/).

---

Этот репозиторий — **сама папка `~/.config`**. Без симлинков: программы читают
конфиги прямо отсюда, а git следит за папкой.

- Поменял конфиг → он уже работает (после перезагрузки программы — как, написано в README её папки).
- Сохранить изменения: `dots` (в fish: перейти сюда + git status), затем
  `git add -A && git commit -m "..." && git push`.
- В git попадает только то, что разрешено в [`.gitignore`](.gitignore) (белый
  список): токены, ключи и кэши (`gh/`, ключи atuin, диск Colima…) на GitHub не уходят.
  Новый конфиг в репо — строка `!/имя-папки/` в `.gitignore`.

**Тема везде одна — astronaut:** цвета с обоев (оранжевый, кремовый, тёмное
стекло шлема, олива, стальной синий) + голубой `#7daea3` свечения окон.

## Как всё связано

```
вход в систему
 ├─ AeroSpace ─────────── окна и спейсы, хоткеи alt-…
 │    ├─ запускает borders ─ голубое свечение вокруг активного окна
 │    └─ шлёт события ─────► SketchyBar — верхний бар с виджетами
 ├─ Karabiner-Elements ── Caps → Ctrl, Fn+HJKL → стрелки
 ├─ MaCursor ──────────── указатель Bibata
 └─ Raycast, Handy ────── (настраиваются в своих приложениях)

терминал
 Ghostty ─► fish (Tide, atuin, zoxide) ─► tmux ─► Neovim
```

## Папки — у каждой свой README «как пользоваться»

| Папка | Что это |
|---|---|
| [`aerospace/`](aerospace/) | Тайлинговый менеджер окон: спейсы `main`, `term`, `Cal&Rem`…, хоткеи `alt-…` |
| [`borders/`](borders/) | Свечение вокруг активного окна |
| [`sketchybar/`](sketchybar/) | Верхний бар: спейсы, музыка, сеть, RAM, CPU, батарея, попапы |
| [`karabiner/`](karabiner/) | Переназначение клавиш |
| [`cursor/`](cursor/) | Указатель мыши (MaCursor + Bibata) |
| [`ghostty/`](ghostty/) | Терминал: тема astronaut, SF Mono Bold, quick terminal |
| [`fish/`](fish/) | Основная оболочка: сокращения, School 21 docker, `rm` в Корзину |
| [`tmux/`](tmux/) | **Как пользоваться моим tmux**: сессии, окна, панели, плавающее окно |
| [`nvim/`](nvim/) | Neovim без плагинов и LSP: Python, C, Markdown, YAML/DevOps |
| [`git/`](git/) | git + delta, алиасы |
| [`atuin/`](atuin/) | История команд (`Ctrl-R`) |
| [`zsh/`](zsh/) | Запасная оболочка + Starship ([`starship.toml`](starship.toml)) |
| [`btop/`](btop/) | Монитор процессов |
| [`fastfetch/`](fastfetch/) | Информация о системе (`ff`) |
| [`glow/`](glow/) | Режим чтения Markdown (`Space p` в Neovim, `md` в терминале) |
| [`colima/`](colima/) | Docker без Docker Desktop |
| [`python/`](python/) | Личные Python-библиотеки |

Файлы в корне: [`Brewfile`](Brewfile) — все программы, [`install.sh`](install.sh) —
установка на новый Mac, [`.editorconfig`](.editorconfig) — отступы по папкам
(Lua в `sketchybar/` — табы, в `nvim/` — 2 пробела).

## Установка на новый Mac

```sh
git clone https://github.com/Uzalov-Gamid/houston.git ~/.config
~/.config/install.sh
```

Скрипт: Command Line Tools → Homebrew → `brew bundle` (всё из Brewfile, включая
App Store через `mas`) → npm-утилиты → Python-библиотеки → SbarLua → `~/.zshenv`
→ fish как оболочка входа + плагины → плагины tmux → запуск SketchyBar и
AeroSpace. Можно запускать повторно. После — дать AeroSpace и Karabiner доступ
к «Универсальному доступу», открыть `cursor/BibataModernIceSmall.cursor` → Apply.
Вручную: Jazz (SberJazz) и My Words — их нет ни в brew, ни в App Store.

## Держать систему в порядке

| Команда | Что делает |
|---|---|
| `brew bundle --file=~/.config/Brewfile` | Доставить недостающее |
| `brew bundle check --file=~/.config/Brewfile --verbose` | Чего не хватает |
| `brew bundle cleanup --file=~/.config/Brewfile` | Что стоит, но **нет** в Brewfile (`--force` — удалить) |
| `brew update && brew upgrade` | Обновить всё |

Поставил что-то новое и хочешь оставить — допиши строку в `Brewfile` и закоммить.

## История

- Раньше параллельно с AeroSpace стоял yabai (+ skhd) — он ничего не делал
  (прозрачности окон нужен выключенный SIP) и удалён; конфиги — в коммите `e05d57e`.
- Предыдущий вариант репо (zsh + Starship + свой Neovim) — тег `legacy-zsh-rig`:
  `git checkout legacy-zsh-rig` посмотреть, `git checkout main` вернуться.
