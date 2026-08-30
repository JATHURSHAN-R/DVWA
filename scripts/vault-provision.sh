#!/bin/bash
set -e

VAULT_EXEC="docker exec -e VAULT_ADDR=http://127.0.0.1:8200 -e VAULT_TOKEN=root dev-vault vault"

# Only generate new secrets if none exist yet — keeps the password stable across restarts
if ! $VAULT_EXEC kv get secret/dvwa >/dev/null 2>&1; then
  $VAULT_EXEC kv put secret/dvwa \
    db_password="VaultManaged_$(openssl rand -hex 8)" \
    mysql_root_password="VaultManaged_$(openssl rand -hex 8)"
fi

DB_PASSWORD=$($VAULT_EXEC kv get -field=db_password secret/dvwa)
MYSQL_ROOT_PASSWORD=$($VAULT_EXEC kv get -field=mysql_root_password secret/dvwa)

cat > .env << EOF
DB_DATABASE=dvwa
DB_USER=dvwa
DB_PASSWORD=${DB_PASSWORD}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
EOF

echo ".env written from Vault-managed secrets"
