output "frontend_image" {
  value = docker_image.frontend.name
}

output "product_image" {
  value = docker_image.product.name
}

output "order_image" {
  value = docker_image.order.name
}

output "inventory_image" {
  value = docker_image.inventory.name
}

output "containers" {
  value = [
    docker_container.frontend_ct.name,
    docker_container.product_ct.name,
    docker_container.order_ct.name,
    docker_container.inventory_ct.name,
  ]
}
