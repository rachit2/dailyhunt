

kubectl create secret generic app-secrets \
	--from-literal=TEMPLATEAPP_DATABASE='postgress' \
	--from-literal=TEMPLATEAPP_DATABASE_USER='postgres' \
	--from-literal=TEMPLATEAPP_DATABASE_PASSWORD='postgres' \
	--from-literal=TEMPLATEAPP_DATABASE_URL="postgres://postgres:postgres@postgres-postgresql/postgres" \
	--from-literal=SECRET_KEY_BASE='3f2edb446925a1f2e07aaea63223dc84865409d868efda0541130adeca1aba52a6e2f3942cd47b6bb303dba646c1efec139f9c79a275ec88967ee52456e5e3a1'
