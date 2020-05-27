# Introduction

The systemd version doesn't work.

The busybox version should be placed before the 'encrypt' hook (the encrypt hook is required).

###
```sh
# 1. Check which slot clevis is using
    clevis luks list -d /dev/nvme0n1p2
1: tpm2 '{"hash":"sha256","key":"ecc","pcr_bank":"sha256","pcr_ids":"0,1,7"}'
# 2. Unbind slot (DOUBLE CHECK SLOT!)
    clevis luks unbind -d /dev/nvme0n1p2 -s 1
The unbind operation will wipe a slot. This operation is unrecoverable.
Do you wish to erase LUKS slot 1 on /dev/nvme0n1p2? [ynYN] Y
Enter any remaining passphrase:
# 3. Bind again
    clevis luks bind -d /dev/nvme0n1p2 tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1,7"}'
Enter existing LUKS password:
```