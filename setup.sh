#!/bin/bash

# Test
dd if=/dev/zero bs=1M count=100 of=/root/test-luks.img
cryptsetup -y -v luksFormat --type luks2 /root/test-luks.img
cryptsetup open /root/test-luks.img test

mkfs.ext4 /dev/mapper/test
mkdir -p /mnt/test
mount /dev/mapper/test /mnt/test


echo "testpass" | clevis encrypt tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1,7"}' > test.jwe
clevis decrypt < test.jwe

# Bind to LUKS
clevis luks bind -d /root/test-luks.img tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1,7"}'

# Verify
cryptsetup luksDump /root/test-luks.img

clevis luks unlock -d /root/test-luks.img

pacman --needed -S clevis tpm2-tools luksmeta libpwquality

### Setup with keyfile
# Create new keyfile
dd bs=512 count=4 if=/dev/urandom iflag=fullblock of=/root/keyfile
# Add to LUKS
cryptsetup luksAddKey /root/test-luks.img /root/keyfile
# Encrypt with clevis
cat /root/keyfile | clevis encrypt tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1,7"}' > keyfile.jwe
# Open by decrypting keyfile with clevis, bash only
cryptsetup open /root/test-luks.img test --key-file <(clevis decrypt < keyfile.jwe)
# Keep keyfile in case SecureBoot or BIOS changes
