---
icon: clipboard-list-check
---

# ToDo List

See also: [Github Issues](https://github.com/rachelf42/homelab/issues)

* [ ] Purchase NAS mobo and debug card
* [ ] Put NAS together, make sure it POSTs and you can get into the BIOS on the couch tv
* [ ] Set up TrueNAS on the new server (flash drive already burned), [video](https://www.youtube.com/watch?v=67KtKoW4IM0)
  * [ ] 6:35 press 1, select only interface
    * [ ] turn `ipv4_dhcp` and `ipv6_auto`  to no
    * [ ] set `aliases` to `10.69.69.96/8`
    * [ ] save, apply, persist, quit
    * [ ] reboot, ensure can log in to web ui on main pc
    * [ ] shutdown and move to server table before proceeding
  * [ ] 10:20 also make dyls user
  * [ ] 10:30 do that, call it smb\_users
  * [ ] 12:30 do the group thing, make three datasets
    * [ ] appdata
    * [ ] media
    * [ ] backups
  * [ ] 15:20 scrub at 23:00, hdd smart at 02:00, all smart at 03:00
  * [ ] 16:30 tasks as follows
    * [ ] appdata:
      * [ ] keep for 3 days
      * [ ] frequency hourly
    * [ ] backups
      * [ ] keep for 2 weeks
      * [ ] frequency daily
    * [ ] media
      * [ ] keep for 1 month
      * [ ] frequency weekly
  * [ ] 23:00 do slack instead, bot forwards to pushover
  * [ ] 25:00+ don't have UPS yet, do not run vms in vms just leave it here youre done
* [ ] Purchase [case](https://ca.pcpartpicker.com/product/T3rG3C/cooler-master-case-nse200kkn1) for NAS
* [ ] Wattage measuring thing
* [ ] UPS and NUT (wolnut?)
