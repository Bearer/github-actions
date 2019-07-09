#!/bin/ash

set -e

: ${TOKEN:?"Need to set TOKEN non-empty"}
: ${UUID:?"Need to set UUID non-empty"}
STAGE=${STAGE-"production"}

echo "integrationId=$UUID" >.integrationrc
echo "[token]" >~/.bearerrc
echo "refresh_token=$TOKEN" >>~/.bearerrc
echo "expires_in=1" >>~/.bearerrc
echo "expires_at=0" >>~/.bearerrc

yarn install --frozen-lockfile
BEARER_ENV=$stage yarn bearer push
