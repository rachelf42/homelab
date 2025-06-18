terraform {
  required_version = "1.12.1"
  required_providers {
    lldap = {
      source  = "tasansga/lldap"
      version = "0.3.0"
    }
  }
  cloud {
    organization = "rachelf42"
    workspaces {
      name = "poststrap"
    }
  }
}
provider "lldap" {
  http_url = "http://control.local.rachelf42.ca:17170"
  ldap_url = "ldap://control.local.rachelf42.ca:3890"
  username = "admin"
  password = file("${path.module}/lldap-adminpw")
  base_dn  = "dc=rachelf42,dc=ca"
}