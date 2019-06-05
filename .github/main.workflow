workflow "Tests" {
  on       = "push"

  resolves = [
    "INVOKE - test"
  ]
}

action "INVOKE - test" {
  uses = "actions/bin/bats@master"
  args = "invoke/test/*.bats"
}
