workflow "Tests" {
  on       = "push"

  resolves = [
    "INVOKE - test",
    "PUSH - test"
  ]
}

action "INVOKE - test" {
  uses = "actions/bin/bats@master"
  args = "invoke/test/*.bats"
}

action "PUSH - test" {
  uses = "actions/bin/bats@master"
  args = "push/test/*.bats"
}
