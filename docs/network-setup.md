---
icon: circle-nodes
---

# Network Setup

The "Security Separation" thing is not actually set up yet because there's only network-infra and trusted so far, its just future-proofing

<table data-full-width="true"><thead><tr><th>Hostname</th><th>IP Address</th><th>Security Separation</th><th>Logical Separation</th><th>Notes</th></tr></thead><tbody><tr><td>EXAMPLE</td><td>10.X.Y.Z</td><td>X</td><td>Y</td><td>netmask 255.0.0.0</td></tr><tr><td>router</td><td>10.0.0.1</td><td>0 = Network Infra</td><td>0 = Gateway</td><td></td></tr><tr><td>VARIOUS</td><td>10.69.0.*</td><td>69 = Trusted</td><td>0 = DHCP-Allocated</td><td></td></tr><tr><td>rachel-pc</td><td>10.69.1.69</td><td>69 = Trusted</td><td>1 = Client with Static IP</td><td></td></tr><tr><td>pve-laptop</td><td>10.69.69.1</td><td>69 = Trusted</td><td>69 = Server</td><td></td></tr><tr><td>control</td><td>10.69.69.69</td><td>69 = Trusted</td><td>69 = Server</td><td>docker host for authentication and stuff that ties the compose stacks together</td></tr><tr><td>jenkins-agent</td><td>10.69.69.253</td><td>69 = Trusted</td><td>69 = Server</td><td></td></tr><tr><td>jenkins</td><td>10.69.69.254</td><td>69 = Trusted</td><td>69 = Server</td><td>controller node</td></tr></tbody></table>
