#!/bin/ash

set -e

BEARER_HOST=${HOST-"http://int.bearer.sh"}
API_VERSION=${VERSION-"v5"}
PAYLOAD=${DATA-"{}"}

: ${BEARER_API_KEY:?"Need to set BEARER_API_KEY non-empty"}
: ${FUNCTION_NAME:?"Need to set FUNCTION_NAME non-empty"}
: ${UUID:?"Need to set UUID non-empty"}

response=$(curl -X POST -s \
  -d "$PAYLOAD" \
  -H "Content-Type: application/json" \
  -H "Authorization: $BEARER_API_KEY" \
  "$BEARER_HOST/api/${API_VERSION}/functions/backend/${UUID}/${FUNCTION_NAME}?authId=${AUTH_ID}")

error=$(echo $response | jq .error)
data=$(echo $response | jq .data)

if [[ "$error" != "null" ]]; then
  echo $error
  exit 1
fi

if [[ "${LOG_LEVEL:-none}" == "DEBUG" ]]; then
  echo $data
fi
