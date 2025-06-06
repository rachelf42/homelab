This directory is for secrets. Obviously.

Nothing should ever be in this directory in the repo
(except of course this readme)

Files are symlinked from here to where they're used, so on Github and when freshly downloaded, the repo will be filled with broken symlinks.

[pullSecrets.sh](/scripts/pullSecrets.sh) should be configured to sync them from a central location (in my case a NAS, you could also use a private github repo)

To initially populate that sync source:
1. generate a list of broken symlinks (like with `watch -n5 "symlinks -rvs $GIT_DIR | grep dangling | awk -F' ' '!_[$4]++'"`)
2. search the repo for where the topmost file is referenced
3. consult the documentation for the tool referencing that path
4. create and fill the file appropriately
5. rinse and repeat till you run out of links