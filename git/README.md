# git

Конфиг: [`config`](config). Git сам читает `~/.config/git/config` — файла
`~/.gitconfig` нет и не нужно.

## Что настроено

- Имя и почта для коммитов.
- Пейджер **[delta](https://github.com/dandavison/delta)**: диффы с подсветкой
  синтаксиса и номерами строк (`git diff`, `git log -p`, `git show`).
- Редактор сообщений коммита — nvim (там подсветка длины: 50 / 72 символа).
- `push` сам создаёт ветку на GitHub при первом пуше, `fetch` чистит удалённые ветки,
  `pull` — merge, конфликты показываются в формате diff3 (видно исходный вариант).

## Алиасы

| Команда | Что делает |
|---|---|
| `git st` | Короткий статус |
| `git co` / `git br` / `git ci` | checkout / branch / commit |
| `git last` | Последний коммит |
| `git lg` | Граф всех веток в одну строку |
| `git amend` | Добавить изменения в последний коммит, не меняя сообщение |

Ещё короче — сокращения fish (`gs`, `gcm`, `gp`…), см. [fish](../fish/).
Визуальный клиент в терминале — `lg` (lazygit).

## Имя и почта

Имя и почта лежат **не в репозитории**, а в файле `identity` рядом с `config`
(он в `.gitignore`; шаблон — `identity.example`). `install.sh` спросит их при установке.

### Поменять

```sh
git config -f ~/.config/git/identity user.name "Новое Имя"
git config -f ~/.config/git/identity user.email "почта@example.com"
```
(или просто открыть `~/.config/git/identity`). Не через `git config --global` —
он пишет в основной `config`, который лежит в репозитории.
