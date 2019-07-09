# GitHub Actions for bearer

## Usage

An example workflow to push a bearer integration

```
workflow "[STAGING] - Push" {
  on = "push"
  resolves = "Push integration"
}

action "Push integration" {
  uses = "bearer/github-actions/push@master"
  env = {
    UUID = "TEST_INTEGRATION_UUID",
    TOKEN = "test-token"
  }
}


workflow "[PROD] - Push" {
  on = "push"
  resolves = "[PROD] - Push integration"
}


action "[PROD] - Filter production" {
  uses = "actions/bin/filter@master"
  args = "tag release-*"
}

action "[PROD] - Push integration" {
  uses = "bearer/github-actions/push@master"
  secrets = ["TOKEN"]
  needs = [
    "[PROD] - Filter production"
  ]
  env = {
    UUID = "INTEGRATION_UUID",
  }
}

```

### Secrets

- `TOKEN` - **Required**. You must be logged in on your computer to retrieve this token.
  - from your integration run: `yarn bearer login` and authenticate yourself
  - run `t=$( cat ~/.bearerrc| grep refresh_token ); echo ${t/refresh_token=/}` or get value of `refresh_token` from `~/.bearerrc` file

### Environment variables

- `UUID` - **Required**. To specify what integration you target

## Testing

using github actions helper
``` bash
act push
```

if you have bats installed
``` bash
GITHUB_WORKSPACE=".." BATS_TEST_DIRNAME=test bats -p test/entrypoint.bats
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
