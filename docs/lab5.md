# Lab 5: Развертывание Telegram-бота на Python

В этой лабораторной работе вы будете использовать репозиторий GitVerse с готовым образом Telegram-бота на языке Python. На примере развертывания Telegram-бота вы познакомитесь с созданием контейнера через интерфейс сервиса Container Apps и дополнительными настройками контейнера.

### 1. Подготовьте среду

[Подготовьте среду](/prerequisites), если пропустили этот шаг в начале. 

### 2. (Опционально) Клонируйте или скачайте репозиторий кода c GitVerse

Вы можете зарегистрироваться в [GitVerse](https://gitverse.ru/){target=_blank}, если у вас еще нет аккаунта, и познакомиться с новой системой контроля версий. Этот шаг необязательный и не влияет на дальнейшее прохождение лабораторной работы. 

В данном репозитории находится готовый образ Telegram-бота на языке Python.

```bash
git clone https://gitverse.ru/cloudru/evo-containerapp-telegrambot-webhook-python-sample.git
``` 

### 3. Зарегистрируйте Telegram-бота

Зарегистрируйте бота с помощью [BotFather](https://t.me/BotFather){target=_blank}.

В Telegram найдите BotFather.

![search-botfather](images/lab5/search-botfather.png)

Выполните команду `/newbot`.

Задайте имя (name) и имя пользователя (username) для бота.
Имя пользователя должно оканчиваться на `...Bot` или `..._bot`.

В нашем случае: 

- name: new-bot
- username: botforlabbot

В результате вы получите токен, сохраните его, он потребуется на следующих этапах.

![create-bot](images/lab5/create-bot.png)

С помощью команды `/setuserpic` установите иконку для вашего бота.

![set-userpick](images/lab5/set-userpick.png)

### 4. Соберите образ и присвойте тег

[В первой лабораторной работе](/lab1) вы создавали реестр в сервисе Artifact Registry для загрузки образа.
Вы можете использовать текущий реестр или создать новый. Если хотите создать новый реестр, пройдите шаги 3-5 из первой лабораторной работы.  

Соберите образ и присвойте ему тег, выполнив следующую команду:

```bash
docker build --tag <registry_name>/telegram-bot-example https://gitverse.ru/cloudru/evo-containerapp-telegrambot-webhook-python-sample.git#master --platform linux/amd64
```
### 5. Загрузите Docker-образ в реестр

Загрузите образ в реестр Artifact Registry, выполнив команду:

```bash
docker push <registry_name>.cr.cloud.ru/telegram-bot-example
```
где: 

- `<registry_name>` — название реестра, которое вы указывали при его создании в Artifact Registry.
- `telegram-bot-example` — название будущего репозитория в Artifact Registry. Название репозитория соответствует имени Docker-образа. 

В личном кабинете перейдите в репозиторий Artifact Registry и убедитесь, что образ загружен.

![ar-image-done](images/lab5/ar-image-done.png)

### 6. Создайте и запустите контейнер

Перейдите в сервис Container Apps через меню в левом верхнем углу экрана.

![go-ca](images/lab5/go-ca.png)

Нажмите **Создать**.

![start-create](images/lab5/start-create.png)

Укажите название контейнера и активируйте опцию **Публичный адрес**. 

Нажмите **Продолжить**.

![ca-container-name](images/lab5/ca-container-name.png)

Выберите реестр, репозиторий и тег Docker-образа, который вы загрузили в Artifact Registry.

Укажите порт контейнера — 5000.

![ca-general-settings](images/lab5/ca-general-settings.png)

Перейдите на вкладку **Переменные** и добавьте переменную окружения `BOT_TOKEN`. В значение переменной укажите токен, полученный при регистрации бота в BotFather.

Нажмите **Продолжить**.

![ca-variables](images/lab5/ca-variables.png)

Задайте количество ресурсов:

- vCPU и RAM: 0.5 vCPU — 1024 MB
- Минимальное количество экземпляров: 0
- Максимальное количество экземпляров: 1

Нажмите **Создать**.

![ca-config](images/lab5/ca-config.png)

Дождитесь, когда контейнер и ревизия перейдут в статус **Выполняется**.

![ca-run](images/lab5/ca-run.png)

### 7. Добавьте webhook в Telegram

Чтобы бот получал сообщения из Telegram, добавьте webhook:

1. Откройте любой браузер.
1. В адресной строке введите по очереди следующие запросы: 

   `https://api.telegram.org/bot{BOT_TOKEN}/getWebhookInfo` — проверяет, существуют ли webhook:

   ![get-webhook](images/lab5/get-webhook.png)

   `https://api.telegram.org/bot{BOT_TOKEN}/deleteWebhook` — удаляет существующие webhook:

   ![set-webhook](images/lab5/delete-webhook.png)

   `https://api.telegram.org/bot{BOT_TOKEN}/setWebhook?url={PUBLIC_URL}/{BOT_TOKEN}` — добавляет новый webhook:

   ![set-webhook-url](images/lab5/set-webhook-url.png)

   где:  
   
   - `{BOT_TOKEN}` — токен, который был сгенерирован при регистрации бота в BotFather.
   - `{PUBLIC_URL}` — публичный URL-адрес, который был сгенирован при создании контейнера в Container Apps.


### 8. Проверьте работу Telegram-бота

Вызовите бота в Telegram по имени пользователя (username) и проверьте его работу, выполнив команду `/start`.

![bot-run](images/lab5/bot-run.png)

👍 Поздравляем, вы только что развернули Telegram-бота в контейнере!