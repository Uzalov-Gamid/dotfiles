# Python-библиотеки

[`requirements.txt`](requirements.txt) — личные библиотеки, которые ставятся в
Python из Homebrew (`python3` в fish — это он). Сейчас: **matplotlib** и
**python-docx**; numpy, pillow, lxml и остальное приходят как зависимости.

```sh
# установить / обновить (это же делает install.sh)
python3 -m pip install --user --break-system-packages -r ~/.config/python/requirements.txt
```

- `--user` — в `~/Library/Python/3.x`, не трогая папки Homebrew.
- `--break-system-packages` — обязательно: Homebrew помечает свой Python как
  «управляемый извне».
- Добавить библиотеку — дописать строку в `requirements.txt`, выполнить команду выше, закоммитить.

Для проектов лучше отдельное окружение: `python3 -m venv .venv` — Neovim сам
запустит файл через `.venv/bin/python`, если такая папка есть ([nvim](../nvim/)).
