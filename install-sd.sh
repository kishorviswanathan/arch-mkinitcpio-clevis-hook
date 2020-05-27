#!/bin/sh

install -Dm644 ./install/sd-clevis /etc/initcpio/install/
install -Dm644 ./systemd-clevis-unlock.path /etc/systemd/system/systemd-clevis-unlock.path
install -Dm644 ./systemd-clevis-unlock.service /etc/systemd/system/systemd-clevis-unlock.service
