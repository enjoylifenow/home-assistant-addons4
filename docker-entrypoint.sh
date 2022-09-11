#!/bin/sh

CONFIG_PATH="/data/options.json"
N8N_PATH="/data/n8n"

mkdir -p "${N8N_PATH}/.n8n"


#####################
## USER PARAMETERS ##
#####################

# REQUIRED
    

export N8N_BASIC_AUTH_ACTIVE="$(jq --raw-output '.auth // empty' $CONFIG_PATH)"
export N8N_BASIC_AUTH_USER="$(jq --raw-output '.auth_username // empty' $CONFIG_PATH)"
export N8N_BASIC_AUTH_PASSWORD="$(jq --raw-output '.auth_password // empty' $CONFIG_PATH)"
export GENERIC_TIMEZONE="$(jq --raw-output '.timezone // empty' $CONFIG_PATH)"
export N8N_PROTOCOL="$(jq --raw-output '.protocol // empty' $CONFIG_PATH)"
export N8N_SSL_CERT="/ssl/$(jq --raw-output '.certfile // empty' $CONFIG_PATH)"
export N8N_SSL_KEY="/ssl/$(jq --raw-output '.keyfile // empty' $CONFIG_PATH)"
export N8N_USER_FOLDER="${N8N_PATH}"
export WEBHOOK_URL="$(jq --raw-output '.webhook_url // empty' $CONFIG_PATH)"
export N8N_ENDPOINT_REST="$(jq --raw-output '.endpoint_rest // empty' $CONFIG_PATH)"
export N8N_ENDPOINT_WEBHOOK="$(jq --raw-output '.endpoint_webhook // empty' $CONFIG_PATH)"
export N8N_ENDPOINT_WEBHOOK_TEST="$(jq --raw-output '.endpoint_webhook_test // empty' $CONFIG_PATH)"
export N8N_ENDPOINT_WEBHOOK_WAIT="$(jq --raw-output '.endpoint_webhook_wait // empty' $CONFIG_PATH)"
export N8N_LOG_LEVEL="$(jq --raw-output '.log_level // empty' $CONFIG_PATH)"
export N8N_LOG_OUTPUT="$(jq --raw-output '.log_output // empty' $CONFIG_PATH)"


if [ -z "${N8N_BASIC_AUTH_USER}" ] || [ -z "${N8N_BASIC_AUTH_ACTIVE}" ]; then
    export N8N_BASIC_AUTH_ACTIVE=false
    unset N8N_BASIC_AUTH_USER
    unset N8N_BASIC_AUTH_PASSWORD
fi


###########
## MAIN  ##
###########


if [ -d ${N8N_PATH} ] ; then
  chmod o+rx ${N8N_PATH}
  chown -R node ${N8N_PATH}/.n8n
  ln -s ${N8N_PATH}/.n8n /home/node/
fi

chown -R node /home/node

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec su-exec node "$@"
else
  # Got started without arguments
  exec su-exec node n8n
fi