variable "nginx_image" {
  description = "Docker-образ Nginx"
  type        = string
}

variable "container_name" {
  description = "Имя контейнера, которым управляет Terraform"
  type        = string
}

variable "network_name" {
  description = "Отдельная сеть Terraform-контейнера"
  type        = string
}

variable "volume_name" {
  description = "Том с файлами стандартной страницы Nginx"
  type        = string
}

variable "external_port" {
  description = "Нестандартный HTTP-порт на учебной VM"
  type        = number

  validation {
    condition     = var.external_port > 1024 && var.external_port < 65536
    error_message = "external_port должен быть нестандартным портом от 1025 до 65535."
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = var.nginx_image
  keep_locally = true
}

resource "docker_network" "nginx" {
  name = var.network_name
}

resource "docker_volume" "nginx_html" {
  name = var.volume_name
}

resource "docker_container" "nginx" {
  name    = var.container_name
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.nginx.name
  }

  volumes {
    volume_name    = docker_volume.nginx_html.name
    container_path = "/usr/share/nginx/html"
  }

  ports {
    internal = 80
    external = var.external_port
  }
}
