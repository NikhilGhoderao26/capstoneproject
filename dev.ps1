param(
  [string]$task = 'help'
)

switch($task){
  'build' {
    docker compose build
  }
  'up' {
    docker compose up --build -d
  }
  'down' {
    docker compose down --volumes
  }
  'seed-db' {
    # copy migrations and run inside mysql container
    docker cp .\migrations capstoneproject-mysql-1:/migrations
    docker exec -i capstoneproject-mysql-1 sh -c '/scripts/apply_migrations.sh'
  }
  default {
    Write-Host "Usage: .\dev.ps1 [build|up|down|seed-db]"
  }
}
