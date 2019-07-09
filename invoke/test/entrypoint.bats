#!/usr/bin/env bats

PATH="$BATS_TEST_DIRNAME/bin:$PATH"

function setup() {
  # Ensure GITHUB_WORKSPACE is set
  chmod u+x $BATS_TEST_DIRNAME/bin/*
  export GITHUB_WORKSPACE="${GITHUB_WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

@test "raises if BEARER_API_KEY is missing" {
  echo $GITHUB_WORKSPACE/invoke/entrypoint.sh
  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo $output | grep "Need to set BEARER_API_KEY non-empty"

  [ "$status" -ne 0 ]
}

@test "raises if FUNCTION_NAME is missing" {
  export BEARER_API_KEY="a-key"

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo $output | grep "Need to set FUNCTION_NAME non-empty"
  [ "$status" -ne 0 ]
}

@test "raises if UUID is missing" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo $output | grep "Need to set UUID non-empty"
  [ "$status" -ne 0 ]
}

@test "it invokes function" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export OUTPUT='200'

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "${lines[1]}" | grep "url: https://int.bearer.sh/api/v4/functions/backend/function-name/function-name?"
}

@test "failing request exits with 1" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export AUTH_ID="auth-id"
  export SETUP_ID="setup-id"
  export NOTIFY_URL="notify"
  export GITHUB_REPOSITORY="repo"
  export GITHUB_WORKFLOW="workflow"
  export OUTPUT='404'

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  [ "$status" -eq 1 ]
}

# Options

@test "OPTION - HOST" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export HOST="https://int.bearer.sh/suffix"

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "${lines[1]}" | grep "url: https://int.bearer.sh/suffix/api/v4/functions/backend/function-name/function-name?"
}

@test "OPTION - API_VERSION" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export VERSION="spongebob"

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "$output"
  echo "${lines[2]}" | grep "https://int.bearer.sh/api/spongebob/functions/backend/function-name/function-name?"
}

@test "OPTION - DATA" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export DATA='{ "data": "ok" }'

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "$output"
  echo "${lines[2]}" | grep -e '-d { "data": "ok" }'
}

@test "OPTION - AUTH_ID" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export AUTH_ID="auth-id"

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "${lines[2]}" | grep " https://int.bearer.sh/api/v4/functions/backend/function-name/function-name?authId=auth-id"
}

@test "OPTION - SETUP_ID" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export SETUP_ID="setup-id"

  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "${lines[2]}" | grep "https://int.bearer.sh/api/v4/functions/backend/function-name/function-name?&setupId=setup-id"
}

@test "OPTION - SETUP_ID & AUTH_ID" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export AUTH_ID="auth-id"
  export SETUP_ID="setup-id"
  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  echo "$output"
  echo "${lines[2]}" | grep "https://int.bearer.sh/api/v4/functions/backend/function-name/function-name?authId=auth-id&setupId=setup-id"
}

@test " OPTION - NOTIFY_URL" {
  export BEARER_API_KEY="a-key"
  export FUNCTION_NAME="function-name"
  export UUID="function-name"
  export LOG_LEVEL="DEBUG"
  export AUTH_ID="auth-id"
  export SETUP_ID="setup-id"
  export NOTIFY_URL="notify"
  export GITHUB_REPOSITORY="repo"
  export GITHUB_WORKFLOW="workflow"
  run /bin/bash $GITHUB_WORKSPACE/invoke/entrypoint.sh

  PATTERN='--data {"text":"Error during function invoke", "blocks":\[{ "type": "section", "fields": \[{ "type": "mrkdwn", "text": "\*Workflow\* workflow" }, { "type": "mrkdwn", "text": "\*URL\* https://github.com/repo/actions" }\] }\] } notify'
  echo "$output"
  echo "${output}" | grep -e $PATTERN
}
