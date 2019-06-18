# GitHub Actions for bearer

## Usage

An example workflow to invoke a bearer function

```
workflow "Invoke" {
  on = "push"
  resolves = "invoke"
}

action "invoke" {
  uses = "bearer/github-actions/invoke@master"
  secrets = ["BEARER_API_KEY"]
  env = {
    UUID = "INTEGRATION_UUID",
    FUNCTION_NAME = "INTEGRATION_FUNCTION_NAME"
  }
}

```

### Secrets

- `BEARER_API_KEY` - **Required**. The token to use for authentication with the Bearer API ([more info](https://app.bearer.sh/keys))

### Environment variables

- `UUID` - **Required**. To specify what integration you target
- `FUNCTION_NAME` - **Required**. To specify what function you want to invoke
- `SETUP_ID` - **Optional**. Retrieves required credentials (needed for basic and api key authentication types)
- `AUTH_ID` - **Optional**. Authenticate your function invoke with a specific auth identifier
- `DATA` - **Optional**. Invoke function with data, JSON string ex `"DATA" : '{"foo": "bar"}'`
- `NOTIFY_URL` - **Optional**. Slack webhook url where
- `NOTIFY_BEARER_URL` - **Optional**. Bearer integration url notification
- `STAGE` - **Optional**. stage

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
