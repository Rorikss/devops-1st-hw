# Результаты проверки

Проверка выполнена на учебной VM `111.88.162.43`.

## Ansible

Второй запуск playbook:

```text
PLAY RECAP
devops-vm : ok=10 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

## Terraform

Первый `terraform apply`:

```text
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

`terraform state list`:

```text
docker_container.nginx
docker_image.nginx
docker_network.nginx
docker_volume.nginx_html
```

Повторный `terraform plan`:

```text
No changes. Your infrastructure matches the configuration.
```

`curl -i http://localhost:8080`:

```text
HTTP/1.1 200 OK
Server: nginx/1.27.5
Content-Type: text/html
Content-Length: 615

<h1>Welcome to nginx!</h1>
```

Созданный том:

```text
VOLUME NAME            DRIVER
terraform-nginx-html   local
```

## Разделение сетей

```text
/terraform-nginx -> terraform-nginx-network
/homework-app -> homework-compose-network
/homework-proxy -> homework-compose-network
```

Таким образом, Terraform-контейнер не подключён к сети контейнеров Compose.

## Docker Compose

```text
NAME             IMAGE               SERVICE   STATUS   PORTS
homework-app     nginx:1.27-alpine   app       Up       80/tcp
homework-proxy   nginx:1.27-alpine   nginx     Up       0.0.0.0:80->80/tcp
```

`curl -i http://localhost` возвращает:

```text
HTTP/1.1 200 OK
Server: nginx/1.27.5
Content-Type: text/html

<h1>Hello World</h1>
```

## Мониторинг

```text
Сервис: docker
Статус: active
Ошибок за последний час: 0
Источник: /var/log/syslog
```
