variable "name" {
  type = string
}
variable "groups" {
  type = set(string)
}
variable "ipaddr" {
  type = string
}
variable "cf_domain" {
  type = string
}
variable "cf_zone_id" {
  type = string
}
variable "user_name" {
  type = string
}
variable "ansible_user" {
  type     = string
  default  = null
  nullable = true
}
variable "ansible_keyfile" {
  type     = string
  default  = null
  nullable = true
}
variable "homedir" {
  type     = string
  default  = null
  nullable = true
}
variable "repodir" {
  type     = string
  default  = null
  nullable = true
}