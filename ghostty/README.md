# Ghostty — терминал

Конфиг: [`config.ghostty`](config.ghostty), тема: [`themes/astronaut`](themes/astronaut).
Открыть: `gconf` (fish). Применить изменения: **`Cmd+Shift+,`** в Ghostty
(или перезапуск).

## Как выглядит

- **Тема astronaut** — цвета с обоев: тёмное стекло шлема (фон), кремовый мех
  (текст), оранжевый (курсор, акценты), олива, жёлтый, стальной синий, плюс
  голубой `#7daea3` свечения окон. Та же палитра в [Neovim](../nvim/) и [tmux](../tmux/).
- **Шрифт** SF Mono Bold 14.5 (шрифт Xcode), жирный текст — Heavy, `font-thicken`
  для плотности. Nerd-иконки Ghostty берёт из встроенного набора, отдельный
  Nerd-шрифт не нужен.
- Без заголовка окна и кнопок, без полосы прокрутки (`scrollbar = never`), отступы 14 px.

При переходе в Ghostty раскладка сама переключается на английскую — это
делает AeroSpace, см. [aerospace](../aerospace/#английская-раскладка-в-ghostty).

## Клавиши

| Клавиши | Действие |
|---|---|
| `alt-1` (или `cmd-F20`) | **Quick terminal** — выпадающий терминал по центру из любого приложения |
| `Cmd+T` / `Cmd+W` | Новая вкладка / закрыть |
| `Cmd+D` / `Cmd+Shift+D` | Разделить окно вправо / вниз (но для этого есть [tmux](../tmux/)) |
| `Cmd+Shift+,` | Перечитать конфиг |
| `Cmd+=` / `Cmd+-` / `Cmd+0` | Крупнее / мельче / сбросить шрифт |
| `Option` | Работает как `Alt` — нужно для хоткеев fish и tmux |

## Как поменять

- Шрифт: `font-family`, `font-size`, `font-style` (`regular`/`medium`/`semibold`/`bold`/`heavy`).
  Доступные начертания: `ghostty +list-fonts --family="SF Mono"`.
- Цвета: файл `themes/astronaut` (фон, текст, курсор, 16 ANSI-цветов).
  Вернуть стандартную тему: `theme = Gruvbox Dark`. Все встроенные темы:
  `ghostty +list-themes`.
- Эффекты курсора: в `shaders/` лежат шейдеры (светящийся след, рябь, «взрыв»).
  Включить: раскомментировать строку `custom-shader = shaders/cursor_tail.glsl`.
- Проверить конфиг на ошибки: `ghostty +validate-config`.
