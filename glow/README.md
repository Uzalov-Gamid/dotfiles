# glow — Markdown в терминале

[glow](https://github.com/charmbracelet/glow) рисует Markdown прямо в терминале.
Стиль [`astronaut.json`](astronaut.json) — в палитре темы (оранжевый заголовок,
голубые подзаголовки и ключевые слова в коде, олива для строк, жёлтый inline-код).

## Как пользоваться

- **В Neovim**: в `.md`-файле `Space p` — предпросмотр справа, обновляется при
  каждом сохранении, `Space p` ещё раз — закрыть (см. [nvim](../nvim/)).
- **В терминале**:
  ```sh
  glow -s ~/.config/glow/astronaut.json README.md      # вывести
  glow -s ~/.config/glow/astronaut.json -p README.md   # с прокруткой (q — выход)
  glow                                                 # выбрать .md в текущей папке
  ```

## Как поменять

`astronaut.json` — стиль [glamour](https://github.com/charmbracelet/glamour):
`h1`…`h6` — заголовки, `code` — inline-код, `code_block.chroma` — подсветка
блоков кода, `link`, `block_quote`, `item` (маркер списка), `task` (`[✓]`).
Цвета — те же, что в `nvim/colors/palette.lua`.
