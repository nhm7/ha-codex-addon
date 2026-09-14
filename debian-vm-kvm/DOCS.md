# Debian VM (KVM)

This x86-64 Home Assistant add-on runs a real Debian 13 virtual machine. Its
entire 32 GiB dynamically allocated QCOW2 disk lives at `/data/debian.qcow2`,
so packages, `/etc`, users, certificates, databases, and desktop files survive
add-on upgrades and recreation.

## First start

The first start copies a Debian cloud image to the persistent volume and uses
cloud-init to install Xfce and Chromium. This can take several minutes (and
considerably longer with software emulation). The installer output appears in
the Ingress display. The desktop logs in automatically as `debian`; its initial
password is `debian`. Change the password immediately with `passwd`.

The disk has a 32 GiB virtual capacity but QCOW2 only consumes space as data is
written. Home Assistant backups that include this add-on can therefore become
large. Debian updates are performed inside the guest with `sudo apt update` and
`sudo apt upgrade`; updating the add-on only updates QEMU and noVNC.

## Runtime

The VM has two virtual CPUs, 4 GiB of RAM, user-mode NAT networking, and a VNC
display available only through authenticated Home Assistant Ingress. No host
VNC port or SSH port is published. When stopped normally, the add-on sends an
ACPI power-button event and waits up to 30 seconds before terminating QEMU.

This edition requires hardware virtualization and access to `/dev/kvm`. If Home Assistant protection mode prevents device access, disable protection mode for this add-on. It will not work when the host does not expose KVM, including many nested-virtualization setups.
