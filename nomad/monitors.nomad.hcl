job "monitors" {
    name = "monitors"
    type = "service"
    # This jobspec should prefer nodes outside the PVE cluster
    affinity {
        attribute = "${node.unique.name}"
        operator = "regexp"
        value = "nomad-client-pve-"
        weight = -50
    }
    group "dozzle" {
        network {
            port "dozzle" { to = 8080 }
        }
        task "dozzle" {
            driver = "docker"
            config {
                image = "amir20/dozzle:v8.11.9"
                ports = ["dozzle"]
                security_opt = ["no-new-privileges=true"]
                mount {
                    type = "bind"
                    target = "/var/run/docker.sock"
                    source = "/var/run/docker.sock"
                    readonly = true
                }
            }
            env {
                DOZZLE_LEVEL = "info"
            }
        }
    }
}