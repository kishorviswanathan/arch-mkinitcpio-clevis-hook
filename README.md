# Introduction

---
**Update: Starting with systemd version 248, TPM2 unlock support is built-in and it is much faster than clevis. Follow [this](https://wiki.archlinux.org/title/Trusted_Platform_Module#systemd-cryptenroll) guide to get it working.**

**Update 2: Do not attempt to use the systemd version of TPM2 unlock if you don't use systemd.**

---

A simple hook to unlock LUKS devices on boot using TPM and `clevis`.

Tested System:
* Manjaro Linux 20.2.1 with `systemd-boot` and `mkinitcpio`.
* Artix Linux OpenRC (Linux 5.17.4-artix1-1) with `grub` and `mkinitcpio`.

# Installing

## AUR Method

1. Install the `mkinitcpio-clevis-hook` package from the AUR (this installs all dependencies).
2. Add `clevis` binding to your LUKS device.
    ```sh
    sudo clevis luks bind -d <device> tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
    ```
3. Enable the `clevis` hook.
    ```sh
    sudo vim /etc/mkinitcpio.conf
    # Edit the hooks and add clevis before the 'encrypt' hook. Eg:
    # HOOKS=(.. clevis encrypt ..)
    ```

    Note: If you are using `plymouth`, replace the `plymouth-encrypt` hook with `encrypt`. `plymouth-encrypt` is reported to be buggy when the device is already unlocked. [More info.](https://github.com/kishorv06/arch-mkinitcpio-clevis-hook/issues/1)
4. Generate `initramfs` image.
    ```sh
    sudo mkinitcpio -P
    ```
5. Reboot.

## Manual Method

1. Install the following packages.
    ```sh
    sudo pacman --needed -S clevis tpm2-tools luksmeta libpwquality
    ```
2. Add `clevis` binding to your LUKS device.
    ```sh
    sudo clevis luks bind -d <device> tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
    ```
3. Install the `clevis` hook.
    ```sh
    sudo ./install.sh
    sudo vim /etc/mkinitcpio.conf
    # Edit the hooks and add clevis before the 'encrypt' hook. Eg:
    # HOOKS=(.. clevis encrypt ..)
    ```

    Note: If you are using `plymouth`, replace the `plymouth-encrypt` hook with `encrypt`. `plymouth-encrypt` is reported to be buggy when the device is already unlocked. [More info.](https://github.com/kishorv06/arch-mkinitcpio-clevis-hook/issues/1)
4. Generate `initramfs` image.
    ```sh
    sudo mkinitcpio -P
    ```
5. Reboot.

# Updating

If you have updated any of the settings in BIOS, changed anything in the kernel options, you have to recreate the  `clevis` binding as TPM will not be able to unlock the device.

```sh
sudo clevis luks unbind -d <device> -s <slot-id>
sudo clevis luks bind -d <device> tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
```

NOTE: `slot-id` is normally 1, but this can be checked by running `sudo cryptsetup luksDump <encrypted device>`

# Troubleshooting

Usually unlocking fails only when any of the TPM registers were updated as part of a system configuration change. Try rebooting the system and re adding the `clevis` LUKS binding. In most cases this should fix the issue. Feel free to create an issue if your problem is not resolved.

# Credits

Forked from [arch-clevis](https://gitlab.com/cosandr/arch-clevis) by [Andrei Costescu](https://gitlab.com/cosandr). I just simplified, fixed some bugs & added a clear readme, and @SimPilotAdamT just adapted it so this can be used in the AUR for easier install and uninstall.
