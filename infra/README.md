# TripPlanner — инфраструктура (Heat + Jenkins)

Репозиторий с кодом управления инфраструктурой: Heat-шаблон создаёт сервер для развёртывания проекта.

## Структура

```
infra/
├── heat/
│   └── tripplanner-stack.yaml   # Heat: создаёт VM tripplanner-Salimli-vm
├── Jenkinsfile                 # Jenkins job — создание/обновление стека
└── README.md
```

## Параметры Heat (API шаблона)

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| image | Glance image (Ubuntu и т.д.) | ubuntu-22.04 |
| flavor | Nova flavor | m1.small |
| key_name | SSH key pair для доступа к VM | — |
| network | Сеть (name или ID) | — |
| spring_data_mongodb_uri | MongoDB URI (application.properties) | mongodb://localhost:27017/... |
| spring_data_mongodb_database | Имя БД | tripplanner |

## API приложения (после запуска на VM)

Из `application.properties` и контроллеров:

| Метод | Путь | Описание |
|-------|------|----------|
| GET | /healthcheck | Состояние сервиса, авторы |
| GET | /admin/users | Список пользователей (Basic Auth) |

Остальные эндпоинты (Telegram, внутренние) не публичные.

## Что делать после выкладки в репо

### 1. Jenkins — job для создания инфраструктуры

1. **New Item** → имя (например `infra` или `tripplanner-infra`) → **Pipeline** → OK.
2. **Pipeline** → Definition: **Pipeline script from SCM**.
3. **SCM**: Git.
4. **Repository URL**: URL твоего репо (где лежит папка `infra/`).
5. **Branch**: `*/main` (или твоя ветка).
6. **Script Path**: `infra/Jenkinsfile`.
7. Сохранить.

### 2. OpenStack CLI на агенте Jenkins

На узле, где выполняется job (Jenkins agent), должны быть:

- установлен `python3-openstackclient` (или `openstack` CLI);
- перед запуском job — загружены переменные OpenStack:  
  `source openrc.sh` или `source students-openrc.sh` (в job или в окружении агента).

Иначе в **Execute shell** в начале шага можно добавить (если openrc лежит в workspace или по фиксированному пути):

```bash
source /path/to/openrc.sh
```

Либо настроить credentials в Jenkins и подставлять их в `openstack` через переменные окружения.

### 3. Запуск создания инфраструктуры

1. Запустить созданный Pipeline job (Build Now).
2. При первом запуске указать параметры (если job параметризован):  
   **STACK_NAME** (например `tripplanner-stack`), **IMAGE**, **FLAVOR**, **KEY_NAME**, **NETWORK** — под свои значения OpenStack.
3. Дождаться окончания: stack перейдёт в `CREATE_COMPLETE` (или `UPDATE_COMPLETE` при повторном запуске).

### 4. Узнать IP созданной VM

На машине с OpenStack CLI:

```bash
openstack stack output show tripplanner-stack instance_ip -f value
```

Либо в Horizon: Stacks → твой стек → Outputs.

### 5. Установка софта на VM вручную

По SSH на полученный IP:

- Установить Java 21 (если не ставится через cloud-init в шаблоне).
- Установить и запустить MongoDB.
- При необходимости создать пользователя/каталоги и настроить приложение (env, systemd) по своей схеме.

Дальнейший деплой JAR (build job → Copy Artifact → VM) настраивается отдельно, если нужен.

## deletion_policy

В шаблоне у ресурсов указано `deletion_policy: Delete`: при удалении стека (`openstack stack delete <stack_name>`) удаляются VM, Security Group и Port.
