variable "ansible_statics" {
  type = map(object(
    {
      groups          = set(string)
      ipaddr          = string
      user_name       = optional(string)
      homedir         = optional(string)
      repodir         = optional(string)
      ansible_user    = optional(string)
      ansible_keyfile = optional(string)
    }
  ))
}