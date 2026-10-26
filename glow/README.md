# glow — Markdown в терминале

[glow](https://github.com/charmbracelet/glow) рисует Markdown прямо в терминале.
Стиль [`astronaut.json`](astronaut.json) — в палитре темы (оранжевый заголовок,
голубые подзаголовки и ключевые слова в коде, олива для строк, жёлтый inline-код).

## Как пользоваться

- **В Neovim**: в `.md`-файле `Space p` — режим чтения во всё окно (как в Obsidian),
  листать `j`/`k`, `Ctrl-d`/`Ctrl-u`; `Space p` или `q` — обратно в редактор (см. [nvim](../nvim/)).
- **В терминале**:
  ```sh
  md README.md          # ★ alias в fish: стиль astronaut + прокрутка (q — выход)
  glow README.md        # просто вывести (стиль тоже astronaut — из glow.yml)
  glow                  # выбрать .md в текущей папке
  ```

## Как поменять

[`glow.yml`](glow.yml) — настройки glow: `style` (сейчас astronaut), ширина, пейджер.


`astronaut.json` — стиль [glamour](https://github.com/charmbracelet/glamour):
`h1`…`h6` — заголовки, `code` — inline-код, `code_block.chroma` — подсветка
блоков кода, `link`, `block_quote`, `item` (маркер списка), `task` (`[✓]`).
Цвета — те же, что в `nvim/colors/palette.lua`.
