#!/bin/ash

log() {
  if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]; then
    echo $*
  fi
}

notify() {
  if [ -n "$NOTIFY_URL" ]; then
    data="{\"text\":\"Error during function invoke: ${error}\", \"blocks\":[{ \"type\": \"section\", \"fields\": [{ \"type\": \"mrkdwn\", \"text\": \"*Workflow* ${GITHUB_WORKFLOW}\" }, { \"type\": \"mrkdwn\", \"text\": \"*URL* https://github.com/${GITHUB_REPOSITORY}/actions\" }] }] }"
    curl -X POST -H 'Content-type: application/json' --data $data $NOTIFY_URL
  fi
}

set -e

BEARER_HOST=${HOST-"https://int.bearer.sh"}
API_VERSION=${VERSION-"v5"}
PAYLOAD=${DATA-"{}"}

: ${BEARER_API_KEY:?"Need to set BEARER_API_KEY non-empty"}
: ${FUNCTION_NAME:?"Need to set FUNCTION_NAME non-empty"}
: ${UUID:?"Need to set UUID non-empty"}
params=""

if [ -n "$AUTH_ID" ]; then
  params="authId=${AUTH_ID}"
fi

if [ -n "$SETUP_ID" ]; then
  params="${params}&setupId=${SETUP_ID}"
fi

url="$BEARER_HOST/api/${API_VERSION}/functions/backend/${UUID}/${FUNCTION_NAME}?${params}"

log "payload: " $PAYLOAD
log "url: " $url

response=$(
  curl -X POST -s \
    -d $PAYLOAD \
    -H "Content-Type: application/json" \
    -H "Authorization: $BEARER_API_KEY" \
    $url
)

log "response: " $response

error=$(echo $response | jq .error)
log "error: " $error

data=$(echo $response | jq .data)
log "data: " $data

if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]; then
  echo $data
fi

if [[ "$error" != "null" ]]; then
  echo "An error occured"
  echo $error
  notify $error
  exit 1
fi
