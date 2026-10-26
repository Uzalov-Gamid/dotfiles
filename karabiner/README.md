# Karabiner-Elements — клавиатура

Конфиг: [`karabiner.json`](karabiner.json). Открыть: `karaconf` (fish), но
удобнее менять через само приложение Karabiner-Elements — оно пишет в этот же
файл, и изменения применяются сразу.

## Что переназначено

| Нажимаешь | Получаешь | Зачем |
|---|---|---|
| `Caps Lock` | `Control` | Ctrl под мизинцем: tmux (`Caps-b`), Neovim, терминал |
| `Left Control` | `Caps Lock` | Caps всё ещё доступен |
| `Fn + H/J/K/L` | ← ↓ ↑ → | Стрелки в стиле vim **в любом приложении** |
| Двойной `Fn` | Контекстное меню (`Shift+Fn+F10`) | Правый клик с клавиатуры |

## Как поменять

- Простые замены клавиш — Karabiner → **Simple Modifications**.
- Сложные правила (сочетания, двойные нажатия) — Karabiner → **Complex
  Modifications** → Add rule. Готовые правила: Add predefined rule → Import more
  rules from the Internet.
- Посмотреть, какой код у клавиши, — приложение **Karabiner-EventViewer**.
- Старые версии конфига Karabiner сам кладёт в `automatic_backups/` (в git не
  попадают).

После переустановки macOS попросит разрешения для Karabiner (Мониторинг
ввода, Универсальный доступ, системное расширение) — без них переназначения не работают.
