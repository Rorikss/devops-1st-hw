output "container_name" {
  description = "Имя созданного контейнера"
  value       = docker_container.nginx.name
}

output "network_name" {
  description = "Имя отдельной Docker-сети"
  value       = docker_network.nginx.name
}

output "volume_name" {
  description = "Имя Docker-тома"
  value       = docker_volume.nginx_html.name
}

output "check_url" {
  description = "Адрес для проверки Nginx с учебной VM"
  value       = "http://localhost:${var.external_port}"
}
