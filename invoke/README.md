# GitHub Actions for bearer

## Usage

### Invoke

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
    BUID = "INTEGRATION_BUID",
    FUNCTION_NAME = "INTEGRATION_FUNCTION_NAME"
  }
}

```

### Secrets

- `BEARER_API_KEY` - **Required**. The token to use for authentication with the Bearer API ([more info](https://app.bearer.sh/keys))

### Environment variables

- `BUID` - **Required**. To specify what integration you target
- `FUNCTION_NAME` - **Required**. To specify what function you want to invoke
- `DATA` - **Optional**. Invoke function with data, JSON string ex `"DATA" : '{"foo": "bar"}'`

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
