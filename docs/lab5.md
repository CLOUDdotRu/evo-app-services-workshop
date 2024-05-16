# Lab 5: Работа в команде, настройка CI/CD
В данной лабораторной работе вы научитесь настраивать CI/CD на примере GitHub Actions. 

![dev-experience](images/cicd.svg)

### 1. (Опционально) Клонируйте репозиторий кода

```
git clone https://gitverse.ru/sc/mabondarevskiy/evo-app-services-workshop.git
``` 

### 2. docker-image.yml

```
name: Build and Push docker image to Evolution Artifact Registry

on:
  push:
    branches: [ "dev", "main" ]
  pull_request:
    branches: [ "main" ]
env:
  CR_URI: helloworld_registry.cr.cloud.ru
  REPO_NAME: helloworld_repository
jobs:
  build:
    runs-on: ubuntu-latest    
    steps:
      - name: Checkout to the branch
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to Evolution Artifact Registry
        uses: docker/login-action@v1
        with:
          registry: ${{ env.CR_URI }}
          username: ${{ secrets.EVO_CR_LOGIN }}
          password: ${{ secrets.EVO_CR_PWD }}
      
      - name: Docker metadata
        id: backend
        uses: docker/metadata-action@v4
        with:
          images: ${{env.CR_URI}}/${{env.REPO_NAME}}
          tags: |
            type=raw,value=build{{date 'DDMMYYY'}}

      - name: Build and push to Evolution Artifact Registry
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ steps.backend.outputs.tags }}
          platforms: linux/amd64
          provenance: false
          file: ./Dockerfile
          context: ./
```
TODO:

### Заключение
В данной лабораторной работе вы научились:

- использовать встроенный сервисы логгирования и мониторинга
- добавлять и использовать переменные окружения
- определять пользовательские health-пробы