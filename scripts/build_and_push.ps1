param(
  [string]$tag = 'local',
  [string]$registry = ''  # if empty, images will be built locally only
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "Building images with tag: $tag"

# build frontend
Push-Location (Join-Path $root '..\frontend')
if(Test-Path Dockerfile){
  docker build -t "capstoneproject-frontend:$tag" .
} else { Write-Host "frontend/Dockerfile not found, skipping" }
Pop-Location

# build product
Push-Location (Join-Path $root '..\product-service')
if(Test-Path Dockerfile){
  docker build -t "capstoneproject-product-service:$tag" .
} else { Write-Host "product-service/Dockerfile not found, skipping" }
Pop-Location

# build order
Push-Location (Join-Path $root '..\order-service')
if(Test-Path Dockerfile){
  docker build -t "capstoneproject-order-service:$tag" .
} else { Write-Host "order-service/Dockerfile not found, skipping" }
Pop-Location

# build inventory
Push-Location (Join-Path $root '..\inventory-service')
if(Test-Path Dockerfile){
  docker build -t "capstoneproject-inventory-service:$tag" .
} else { Write-Host "inventory-service/Dockerfile not found, skipping" }
Pop-Location

# optional push
if($registry -ne ''){
  Write-Host "Pushing images to registry: $registry"
  docker tag "capstoneproject-frontend:$tag" "$registry/capstoneproject-frontend:$tag"
  docker tag "capstoneproject-product-service:$tag" "$registry/capstoneproject-product-service:$tag"
  docker tag "capstoneproject-order-service:$tag" "$registry/capstoneproject-order-service:$tag"
  docker tag "capstoneproject-inventory-service:$tag" "$registry/capstoneproject-inventory-service:$tag"

  docker push "$registry/capstoneproject-frontend:$tag"
  docker push "$registry/capstoneproject-product-service:$tag"
  docker push "$registry/capstoneproject-order-service:$tag"
  docker push "$registry/capstoneproject-inventory-service:$tag"
}

Write-Host "Done"