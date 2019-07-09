#!/usr/bin/env bats

PATH="$BATS_TEST_DIRNAME/bin:$PATH"

function setup() {
  # Ensure GITHUB_WORKSPACE is set
  # chmod u+x $BATS_TEST_DIRNAME/bin/*
  export GITHUB_WORKSPACE="${GITHUB_WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

@test "raises if TOKEN is missing" {
  echo $GITHUB_WORKSPACE/push/entrypoint.sh
  run /bin/bash $GITHUB_WORKSPACE/push/entrypoint.sh

  echo $output | grep "Need to set TOKEN non-empty"

  [ "$status" -ne 0 ]
}

@test "raises if UUID is missing" {
  export TOKEN="a-token"

  run /bin/bash $GITHUB_WORKSPACE/push/entrypoint.sh

  echo $output | grep "Need to set UUID non-empty"
  [ "$status" -ne 0 ]
}

# @test "it pushes integration" {
#   export TOKEN="a-key"
#   export UUID="function-name"

#   run /bin/bash $GITHUB_WORKSPACE/push/entrypoint.sh

#   echo "${lines[1]}" | grep "url: https://int.bearer.sh/api/v5/functions/backend/function-name/function-name?"
# }
