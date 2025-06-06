# Rachel's Homelab Repository
This repo is for my personal homelab stuff

I've tried to make it so that it's easily reconfigured for others where possible, and feel free to fork, but I do **NOT** provide any support unless I have personally told you otherwise.

It is based on Proxmox, with Terraform and Ansible for Infra-as-Code, and Cloudflare for DNS
(mostly due to ease-of-use and their generous free offers, if I ever decide to pay for DNS stuff I'm likely to go with another provider)

## Starting From Scratch
First off, I advise searching all files for `rachel` and `rachelf42` and changing all instances appropriately.

Once you have, and have cloned your fork, the [bootstrap/steps.md](/bootstrap/steps.md) file will get you started

## To Install Git Hooks
Simply run
`git config core.hooksPath .githooks`
(requires git v2.9, released 2016)