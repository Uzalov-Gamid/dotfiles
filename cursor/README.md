# Указатель мыши — Bibata Modern Ice

Стрелку заменяет [MaCursor](https://github.com/writronic/MaCursor) (подписан и
нотаризован Apple, поддерживает macOS 26). Тема — **Bibata Modern Ice** (белая,
скруглённая), уменьшенная до 0.7: 22 pt вместо 32, ближе к родной стрелке.

| Файл | Что это |
|---|---|
| [`BibataModernIceSmall.cursor`](BibataModernIceSmall.cursor) | Тема, которая сейчас стоит |
| [`resize.py`](resize.py) | Делает копию темы другого размера |

## Как пользоваться

- **Применить тему** — дважды кликнуть `.cursor`-файл (откроется MaCursor) → **Apply**.
- **Другой размер**:
  ```sh
  python3 ~/.config/cursor/resize.py ~/.config/cursor/BibataModernIceSmall.cursor 0.9
  ```
  `0.9` — меньше, `1.2` — больше. Рядом появится копия → открыть → **Apply**.
- **Другая тема** — MaCursor → выбрать → **Apply**. Ещё 80+ тем в
  [галерее](https://github.com/writronic/MaCursor/blob/main/themes/README.md);
  скачанный `.cursor` можно положить сюда и закоммитить.
- **Вернуть стандартную стрелку** — кнопка **Restore** (↺) в MaCursor.
- **Чтобы не слетало после перезагрузки** — MaCursor → Settings → General →
  Helper Tool → **Install**.

## На новом маке

`install.sh` ставит MaCursor через Brewfile. Дальше — открыть
`BibataModernIceSmall.cursor` и нажать **Apply**, затем установить Helper Tool.
