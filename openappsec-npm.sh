# https://github.com/openappsec/openappsec/tree/main/deployment/docker-compose/nginx-proxy-manager
# https://docs.openappsec.io/integrations/nginx-proxy-manager/deploy-nginx-proxy-manager-with-open-appsec-managed-from-npm-webui

mkdir openappsec-npm
cd openappsec-npm
wget https://raw.githubusercontent.com/openappsec/openappsec/main/deployment/docker-compose/nginx-proxy-manager/docker-compose.yaml
wget https://raw.githubusercontent.com/openappsec/openappsec/main/deployment/docker-compose/nginx-proxy-manager/.env
mkdir appsec-localconfig
wget https://raw.githubusercontent.com/openappsec/open-appsec-npm/main/deployment/managed-from-npm-ui/local_policy.yaml -O ./appsec-localconfig/local_policy.yaml

# edit .env
# APPSEC_USER_EMAIL=emailmu@terserah
# COMPOSE_PROFILES=standalone

docker compose up -d