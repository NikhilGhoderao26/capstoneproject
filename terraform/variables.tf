variable "docker_host" {
  description = "Docker host connection string (e.g., unix:///var/run/docker.sock or tcp://127.0.0.1:2375). Leave empty to use default local socket."
  type        = string
  default     = ""
}

variable "image_tag" {
  description = "Tag to use for built images"
  type        = string
  default     = "local"
}
