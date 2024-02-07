### Как настроить локальную среду для разработки документации
1. Клонировать репозитарий
2. docker login
3. docker build  -t <registry_name>.cr.cloud.ru/<repo_name> . --platform linux/amd64
4. docker push <registry_name>.cr.cloud.ru/<repo_name>
