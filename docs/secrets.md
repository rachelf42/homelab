---
icon: lock-keyhole
---

# Secrets

{% @github-files/github-code-block url="https://github.com/rachelf42/homelab/tree/main/secrets" %}

Files are symlinked from here to where they're used, so on Github and when freshly downloaded, the repo will be filled with broken symlinks.

pullSecrets.sh should be configured to sync them from a central location (in my case a NAS, you could also use a private github repo)

To initially populate that sync source:

1. generate a list of broken symlinks (like with `watch -n5 "symlinks -rvs $GIT_DIR | grep dangling | awk -F' ' '!_[$4]++'"`)
2. search the repo for where the topmost file is referenced
3. consult the documentation for the tool referencing that path
4. create and fill the file appropriately
5. rinse and repeat till you run out of links
