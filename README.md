# Introduction

A simple hook to unlock LUKS devices on boot using TPM and `clevis`.

Tested System:
* Manjaro Linux 20.2.1 with `systemd-boot` and `mkinitcpio`.

# Installing

1. Install the following packages.
    ```sh
    sudo pacman --needed -S clevis tpm2-tools luksmeta libpwquality
    ```
2. Add `clevis` binding to your LUKS device
    ```sh
    sudo clevis luks bind -d <device> tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
    ```
3. Install the `clevis` hook
    ```sh
    sudo ./install.sh
    sudo vim /etc/mkinitcpio.conf
    # Edit the hooks and add clevis before the 'encrypt' hook. Eg:
    # HOOKS=(.. clevis encrypt ..) 
    ```
4. Generate `initramfs` image.
    ```sh
    sudo mkinitcpio -P
    ```
5. Reboot

# Updating

If you have updated any of the settings in BIOS, changed anything in the kernel options, you have to recreate the  `clevis` binding as TPM will not be able to unlock the device.

```sh
sudo clevis luks unbind -d <device> -s <slot-id> # slot-id is usually 1
sudo clevis luks bind -d <device> tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
```

# Troubleshooting

Usually unlocking fails only when any of the TPM registers were updated as part of a system configuration change. Try rebooting the system and re adding the `clevis` LUKS binding. In most cases this should fix the issue. Feel free to create an issue if your problem is not resolved.

# Credits

Forked from [arch-clevis](https://gitlab.com/cosandr/arch-clevis) by [Andrei Costescu](https://gitlab.com/cosandr). I just simplified, fixed some bugs and added a clear readme.