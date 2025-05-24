resource "webhookrelay_bucket" "github-jenkins" {
  name                 = "github-jenkins"
  description          = "Webhook fired by GitHub to alert Jenkins to new pushes"
  delete_default_input = true
}