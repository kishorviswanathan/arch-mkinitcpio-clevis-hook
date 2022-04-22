# Introduction

---
**Update: Starting with systemd version 248, TPM2 unlock support is built-in and it is much faster than clevis. Follow [this](https://gist.github.com/chrisx8/cda23e2d1fa3dcda0d739bc74f600175) guide to get it working.**

---

A simple hook to unlock LUKS devices on boot using TPM and `clevis`.

Tested System:
* Manjaro Linux 20.2.1 with `systemd-boot` and `mkinitcpio`.
* Artix Linux OpenRC (Linux 5.17.4-artix1-1) wiht `grub` and `mkinitcpio`.

# Installing

1. Install the `mkinitcpio-clevis-hook` package from the AUR.
    Note: If you are using `plymouth`, replace the `plymouth-encrypt` hook with `encrypt` in your `/etc/mkinitcpio.conf` file. `plymouth-encrypt` is reported to be buggy when the device is already unlocked. [More info.](https://github.com/kishorv06/arch-mkinitcpio-clevis-hook/issues/1)
2. Reboot.

# Updating

If you have updated any of the settings in BIOS, changed anything in the kernel options, you have to recreate the  `clevis` binding as TPM will not be able to unlock the device.

```sh
sudo clevis luks unbind -d <device> -s <slot-id> # slot-id is usually 1
sudo clevis luks bind -d <device> tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
```

# Troubleshooting

Usually unlocking fails only when any of the TPM registers were updated as part of a system configuration change. Try rebooting the system and re adding the `clevis` LUKS binding. In most cases this should fix the issue. Feel free to create an issue if your problem is not resolved.

# Credits

Forked from [arch-mkinitcpio-clevis-hook](https://github.com/kishorv06/arch-mkinitcpio-clevis-hook/) by @kishorv06, which was forked from [arch-clevis](https://gitlab.com/cosandr/arch-clevis) by [Andrei Costescu](https://gitlab.com/cosandr). @kishorv06 just simplified, fixed some bugs & added a clear readme, and I just adapted it so this can be used in the AUR for easier install and uninstall.
