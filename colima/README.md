# Colima — Docker без Docker Desktop

Конфиг: [`default/colima.yaml`](default/colima.yaml). [Colima](https://github.com/abiosoft/colima)
поднимает лёгкую Linux-виртуалку (Apple Virtualization, `vz`), внутри которой
работает Docker. Команда `docker` на маке ходит в неё.

Ресурсы VM: **4 CPU, 6 ГБ памяти, 40 ГБ диск**, папки мака видны внутри через
virtiofs (быстро), Kubernetes выключен.

## Как пользоваться

```sh
colima start          # запустить VM (нужно один раз после перезагрузки)
docker ps             # дальше обычный docker / docker compose
colima status         # работает ли
colima stop           # остановить, освободить память
colima ssh            # зайти внутрь виртуалки
```

Сокращения fish: `dops` (docker ps), `doco` (docker compose), `doe` (docker exec),
и команды School 21 — см. [fish](../fish/).

## Как поменять

- Ресурсы — `cpu`, `memory`, `disk` в `colima.yaml`, затем `colima stop && colima start`
  (диск можно только увеличить).
- Включить Kubernetes — `kubernetes.enabled: true`.

Диск виртуалки и служебные файлы (`_lima/`, `_store/`) в git не попадают.
