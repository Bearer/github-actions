#!/bin/ash

BEARER_HOST=${HOST-"http://int.bearer.sh"}
PAYLOAD=${DATA-"{}"}

response=$(curl -X POST -s \
  -d "$PAYLOAD" \
  -H "Authorization: $BEARER_API_KEY" \
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

