#!/bin/ash

set -e

log() {
  if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]; then
    echo $*
  fi
}

notify() {
  if [ -n "$NOTIFY_URL" ]; then
    data="{\"text\":\"Error during function invoke\", \"blocks\":[{ \"type\": \"section\", \"fields\": [{ \"type\": \"mrkdwn\", \"text\": \"*Workflow* ${GITHUB_WORKFLOW}\" }, { \"type\": \"mrkdwn\", \"text\": \"*URL* https://github.com/${GITHUB_REPOSITORY}/actions\" }] }] }"
    curl -X POST -H 'Content-type: application/json' --data "$data" $NOTIFY_URL
  fi
}


notify_bearer() {
  if [ -n "$NOTIFY_BEARER_URL" ]; then

      echo "Sending notification to bearer"
      echo "payload: $1"

      curl -X POST \
           -H "Content-Type: application/json" \
           -H "Authorization: $BEARER_API_KEY" \
           --data "$1" \
      "$NOTIFY_BEARER_URL"
  fi
}

BEARER_HOST=${HOST-"https://int.bearer.sh"}
API_VERSION=${VERSION-"v5"}
PAYLOAD=${DATA-"{}"}
STAGE=${STAGE-"test"}

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

temp_file=$(mktemp)

response_code=$(
  curl -X POST -s \
    -d $PAYLOAD \
    -H "Content-Type: application/json" \
    -H "Authorization: $BEARER_API_KEY" \
    -o $temp_file \
    -w "%{http_code}" \
    $url
)

log "response_code: " $response_code
response=$(cat $temp_file)

if [[ "$response_code" != "200" ]]; then
  echo "An error occured"
  log "response: " $response
  echo $response_code
  notify $error
  exit 1
fi

log "response: " $response

error=$(echo $response | jq .error)
log "error: " $error

data=$(echo $response | jq .data)
log "data: " $data

if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]; then
  echo $data
fi

payload=$(echo "$response" | base64 | xargs echo -n | tr -d ' ')

notify_bearer "{\"stage\":\"$STAGE\",\"payload\":\"$payload\",\"buid\":\"$UUID\"}"

if [[ "$error" != "null" ]]; then
  echo "An error occured"
  echo $error
  notify $error
  exit 1
fi
