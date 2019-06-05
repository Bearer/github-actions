#!/bin/ash

log() {
  if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]; then
    echo $*
  fi
}

set -e

BEARER_HOST=${HOST-"http://int.bearer.sh"}
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
  exit 1
fi
