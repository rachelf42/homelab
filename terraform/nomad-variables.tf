variable "nomad_reserved_memory" {
  type    = number
  default = 2048 # in Mb
}
variable "nomad_nodes" {
  type = list(object({
    name   = string
    cores  = number
    memory = number # in Mb
  }))
}