#!/bin/ash

set -e

BEARER_HOST=${HOST-"http://int.bearer.sh"}
PAYLOAD=${DATA-"{}"}

: ${BEARER_API_KEY:?"Need to set BEARER_API_KEY non-empty"}
: ${FUNCTION_NAME:?"Need to set FUNCTION_NAME non-empty"}
: ${BUID:?"Need to set BUID non-empty"}

response=$(curl -X POST -s \
  -d "$PAYLOAD" \
  -H "Authorization: $API_KEY" \
  "$BEARER_HOST/api/v5/functions/backend/${BUID}/$FUNCTION_NAME")

error=$(echo $response | jq .error)
data=$(echo $response | jq .data)

if [[ "$error" != "null" ]]
then
  echo $error
  exit 1
fi

if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]
then
  echo $data
fi

