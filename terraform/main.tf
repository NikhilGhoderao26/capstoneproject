locals {
  frontend_dir  = "${path.module}/../frontend"
  product_dir   = "${path.module}/../product-service"
  order_dir     = "${path.module}/../order-service"
  inventory_dir = "${path.module}/../inventory-service"
}

resource "null_resource" "build_and_push" {
  triggers = {
    image_tag = var.image_tag
  }

  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command     = "& \"${path.module}/../scripts/build_and_push.ps1\" -tag ${var.image_tag}"
  }
}

resource "null_resource" "build_and_push_sh" {
  triggers = {
    image_tag = var.image_tag
  }

  # Provide a POSIX-friendly path; users on Linux/macOS can use this
  provisioner "local-exec" {
    command = "bash \"${path.module}/../scripts/build_and_push.sh\" ${var.image_tag}"
  }
}
