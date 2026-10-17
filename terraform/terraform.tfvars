nginx_image    = "nginx:1.27-alpine"
container_name = "terraform-nginx"
network_name   = "terraform-nginx-network"
volume_name    = "terraform-nginx-html"
external_port  = 8080
