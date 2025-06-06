#!/usr/bin/env bash
set -e

PGPASSWORD=$(cat /run/secrets/psql-root-password)
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER authelia WITH PASSWORD '$(cat /run/secrets/psql-authelia-password)';
	CREATE DATABASE authelia;
	GRANT ALL PRIVILEGES ON DATABASE authelia TO authelia;
	ALTER DATABASE authelia OWNER TO authelia;

	CREATE USER lldap WITH PASSWORD '$(cat /run/secrets/psql-lldap-password)';
	CREATE DATABASE lldap;
	GRANT ALL PRIVILEGES ON DATABASE lldap TO lldap;
	ALTER DATABASE lldap OWNER TO lldap;
EOSQL