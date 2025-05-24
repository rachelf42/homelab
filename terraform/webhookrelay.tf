resource "webhookrelay_bucket" "github-jenkins" {
  name                 = "github-jenkins"
  description          = "Webhook fired by GitHub to alert Jenkins to new pushes"
  delete_default_input = true
}
resource "webhookrelay_output" "github-jenkins" {
  name        = "github-jenkins"
  destination = "http://jenkins.local.rachelf42.ca:8080/github-webhook/"
  internal    = true
  bucket_id   = webhookrelay_bucket.github-jenkins.id
}
resource "webhookrelay_input" "github-jenkins" {
  name = "github-jenkins"
  bucket_id = webhookrelay_bucket.github-jenkins.id
}