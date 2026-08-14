# Trip Planner Bot (Team №8)

- [Проверить бота](https://t.me/TripPlannerBot_bot).

<p align="center">
  <img src="https://mathematiclove.github.io/my-cv/content/projects/TRIP_PLANNER/EXAMPLE_1.PNG" width="300" height="500" alt="Fig. 1: Bot example">
  <img src="https://mathematiclove.github.io/my-cv/content/projects/TRIP_PLANNER/EXAMPLE_2.PNG" width="300" height="500" alt="Fig. 2: Bot example">
</p>

Telegram бот для планирования путешествий с административной панелью.
## Инфраструктура 
- Создание инстенса - Terraform;
- Подргузка пакетов - Ansible;
- Сборка - Jenkins (sh);
- Деплой - Jenkins.
(см. ./infra/)

## K8s
- см. ./infra/kubernetes/
  
## API Endpoints

### Административные эндпоинты

- /admin/users
   - Требует авторизацию
        - Login: AyzekPetyaMartin
        - Password: Ayzek123321    
- /healthceck
   - Проверяет состояние Mongo запросом
   - Выводит ОК - если все хорошо
   - Выводит авторов
## Запуск проекта

### Локальная сборка

1. Сборка проекта с помощью Gradle:
```bash
./gradlew clean build
```

2. Создание исполняемого JAR-файла:
```bash
./gradlew clean shadowJar
```
3. Запуск с Gradle:
``` bash
./gradlew run
```

### Запуск в Docker

Проект использует Docker Compose для оркестрации контейнеров:

1. **docker-compose.yml**:
   - Настраивает сеть `trip-planner-network`
   - Настраивает переменные окружения для приложения
   - Устанавливает зависимости между сервисами
   - Настраивает healthcheck для проверки работоспособности

2. **Dockerfile**:
   - Использует Amazon Corretto 21 (Alpine)
   - Копирует собранный JAR-файл
   - Настраивает точку входа для запуска приложения

### Команды для работы с Docker
1. Сборка:
```bash
docker compose --build -d
docker compose run app
```

Очистка и пересборка:
```bash
# Остановка и удаление контейнеров
docker compose down --remove-orphans

# Удаление всех образов
docker compose down --rmi all

# Сборка и запуск в фоновом режиме
docker compose up --build -d

# Запуск приложения
docker compose run app
```

## Авторы
- Салимли Айзек:
   - Infra   
   - Planner 
   - Docker 
   - gradle
- Григорьев Петр:
   - Helper 
   - Healthcheck
- Михалец Мартин:
   - History 
   - Admin
