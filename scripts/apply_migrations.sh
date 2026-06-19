#!/bin/sh
# This script applies all migrations in /migrations inside the mysql container
# Usage: docker exec -i <mysql-container> /bin/sh -c "/path/to/apply_migrations.sh"

for f in /migrations/*.sql; do
  echo "Applying $f"
  mysql -uroot -ppassword < "$f"
done

echo "Migrations applied"
