# Lab 1: Развертывание frontend-приложения

В этой лабораторной работе вы получите первый практический опыт использования облачных сервисов для разработчиков Evolution Container Apps и Evolution Artifact Registry на примере развертывания простого frontend-приложения.

Вы загрузите Docker-образ с готовым приложением в реестр, создадите контейнер и опубликуете приложение в интернет.

![dev-experience](images/scheme/dev_experience.svg)

### 1. Подготовьте среду

[Подготовьте среду](/prerequisites), если пропустили этот шаг в начале. 

### 2. (Опционально) Клонируйте или скачайте репозиторий кода c GitVerse
 
Вы можете зарегистрироваться в [GitVerse](https://gitverse.ru/){target=_blank}, если у вас еще нет аккаунта, и познакомиться с новой системой контроля версий. Этот шаг необязательный и не влияет на дальнейшее прохождение лабораторной работы. 

![gitverse-clone](images/lab1/gitverse_clone.png) 

```
git clone https://gitverse.ru/cloudru/evo-containerapp-react-sample
```

### 3. Создайте реестр в Artifact Registry
В [личном кабинете](https://console.cloud.ru){target=_blank} перейдите на карточку сервиса Artifact Registry.

![ar-go-console](images/lab1/ar-go-console.png)

Нажмите **Создать реестр**.

Укажите название реестра — оно станет частью URI, который вы будете использовать при работе в Docker CLI. 

![ar-registry-create](images/lab1/ar-registry-create.png)

Скопируйте полученный URI реестра, он будет нужен для выполнения дальнейших шагов. 

![ar-registry-copy-uri](images/lab1/ar-registry-copy-uri.png)

### 4. Получите ключи доступа для аутентификации

В личном кабинете перейдите в раздел **Управление профилем**.

![revision-running](images/lab1/profile-settings.png)

Выберите раздел **Ключи доступа** и нажмите **Создать ключ**.

![revision-running](images/lab1/ar-secrets.png)

Введите краткое описание ключа, которое поможет в будущем идентифировать его среди других ключей.
Задайте время жизни ключа: от 1 до 365 дней. 
Нажмите **Создать**.

После этого будут сгенерированы Key ID (логин) и Key Secret (пароль). 
Сохраните Key Secret. После того как вы закроете окно, повторно посмотреть его будет нельзя. 

### 5. Пройдите аутентификацию в реестре Artifact Registry 
Откройте терминал и введите команду для аутентификации. Вы можете использовать любой привычный для вас терминал.

```bash
docker login <registry_name>.cr.cloud.ru -u <key_id> -p <key_secret>
```
где: 

- `<registry_name>` — название реестра, которок вы указывали при его создании в Artifact Registry.
- `<key_id>` — логин персонального ключа (Key ID).
- `<key_secret>` — пароль персонального ключа (Key Secret).

### 6. Соберите и подготовьте Docker-образ

Cоберите на локальном компьютере готовый Docker-образ из репозитория GitVerse, выполнив в терминале следующую команду: 

```shell
docker build --tag <registry_name>.cr.cloud.ru/react-hello-world https://gitverse.ru/cloudru/evo-containerapp-react-sample.git#master --platform linux/amd64
```
Команда собирает образ и тегирует его для дальнейшей загрузки в реестр.
Для создания контейнера Docker-образ должен быть собран под платформу ***linux/amd64***.

### 7. Загрузите Docker-образ в реестр

Загрузите образ в реестр Artifact Registry, выполнив команду:

```bash
docker push <registry_name>.cr.cloud.ru/react-hello-world
```
где: 

- `<registry_name>` — название реестра, которое вы указывали при его создании в Artifact Registry.
- `react-hello-world` — название будущего репозитория в Artifact Registry. Название репозитория соответствует имени Docker-образа. 

Убедитесь, что в Artifact Registry появился репозиторий с указанным именем и загруженный образ.

![revision-running](images/lab1/ar-repository-sucess.png)

### 8. Создайте и запустите контейнер

Откройте меню загруженного образа и нажмите **Создать Container App**. 

![revision-running](images/lab1/ar-create-container.png)

Заполните поля и активируйте опции:

![run_from_ar_form](images/lab1/ar-container-params.png)

**Название контейнера** — глобально уникальное имя, на базе которого формируется адрес вашего приложения в домене *.containers.cloud.ru.

**Порт контейнера** — порт контейнера, который должен совпадать с портом вашего приложения. В этой лабораторной работе используем порт 8080.

```
server {
    listen 8080;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

**vCPU/RAM** — количество vCPU и RAM, которые выделяются для каждого экземпляра контейнера при обработке вызова. Выберите минимальную конфигурацию.

**Минимальное** и **максимальное количество экземпляров** при масштабировании сервиса. По умолчанию происходит масштабирование с 0, что может вызывать небольшую задержку при старте вашего приложения. Установите минимальное количество экземпляров в значение 0, а максимальное — 1.

**Публичный адрес**— активируйте опцию, чтобы получить URL-адрес для вызова контейнера из интернета.

Нажмите **Создать**.

Откроется страница сервиса Container Apps. 
Контейнер будет запущен в течение нескольких секунд.

Дождитесь, когда контейнер и ревизия перейдут в статус **Выполняется**.

![revision-running](images/lab1/ca-container-run.png)


### 9. Проверьте рабостоспособность развернутного приложения

Дождитесь появления **Публичного URL**, скопируйте его и вставьте в адресную строку браузера.

Если приложение не отвечает проверьте в списке ревизий, что последняя ревизия (первая по списку) в статусе **Выполняется**.

![revision-running](images/lab1/ca-public-url.png)

Откроется страница приложения.

![revision-running](images/lab1/app-go.png)
    
👍 Поздравляем, вы только что развернули frontend-приложение в облачном контейнере и опубликовали его в интернет!  

### Что дальше

В данной лабораторной работе вы научились:

- загружать Docker-образ в Artifact Registry;
- создавать и запускать контейнер с быстрого меню в Artifact Registry.

В следующей лабораторной работе вы научитесь разворачивать backend-приложение и познакомитесь с дополнительными настройками облачных сервисов Container Apps и Artifact Registry.
