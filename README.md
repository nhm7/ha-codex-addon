# Persistent Debian VMs for Home Assistant

[![Open your Home Assistant instance and add this repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fnhm7%2Fhomeassistant-desktop-vm)

This repository provides two x86-64 Home Assistant add-ons that run a complete
Debian 13 Xfce virtual machine. Both store the whole guest disk at
`/data/debian.qcow2`, preserving installed packages, system configuration,
users, certificates, databases, browser profiles, and other guest state across
container replacement and add-on upgrades.

## Choose an add-on

| Add-on | Acceleration | Requirements | Best for |
| --- | --- | --- | --- |
| **Debian VM (KVM)** | Hardware KVM | An amd64 host exposing `/dev/kvm`; protection mode may need to be disabled | Recommended when KVM is available |
| **Debian VM (Software)** | QEMU TCG | Any amd64 Home Assistant host | Compatibility when KVM is unavailable; substantially slower |

Do not install both expecting them to share a machine: Home Assistant gives
each add-on its own persistent `/data` volume and therefore its own VM disk.

## Install

1. Use the badge above, or add
   `https://github.com/nhm7/homeassistant-desktop-vm` under **Settings → Add-ons
   → Add-on store → Repositories**.
2. Install one of the two editions.
3. For the KVM edition, disable protection mode if required to make `/dev/kvm`
   available.
4. Start the add-on, enable **Show in sidebar**, and open it.
5. Allow the first-boot cloud-init installation to finish. The initial desktop
   account and password are both `debian`; change the password immediately.

The browser connection is available only through authenticated Home Assistant
Ingress. The add-ons publish no host VNC or SSH port. The dynamically allocated
disk has a 32 GiB virtual maximum, so snapshots and Home Assistant backups may
be large. Debian must be updated from inside the VM; add-on updates update only
the VM runner and web frontend.

See the edition-specific documentation for operational and performance details.

## License

MIT — see [LICENSE](LICENSE).
