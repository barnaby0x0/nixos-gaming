NixOS Gaming

A reproducible NixOS gaming environment inspired by CachyOS.

The goal is to combine:

NixOS

CachyOS kernel optimizations

Steam

Proton / GE-Proton

DXVK / VKD3D

Gamescope

GameMode

MangoHud

Mesa / Vulkan

zram

declarative performance tuning

The entire system is managed declaratively using Nix flakes.

Architecture

NixOS
│
├── CachyOS Kernel
│
├── KDE Plasma
│
├── Mesa / Vulkan
│
└── Gaming
    ├── Steam
    ├── Proton
    ├── GE-Proton
    ├── Gamescope
    ├── GameMode
    └── MangoHud

Project structure

nixos-gaming/
├── flake.nix
├── flake.lock
├── README.md
├── hosts/
│   └── gaming/
│       ├── default.nix
│       ├── hardware-configuration.nix
│       └── disko.nix
├── modules/
│   ├── cachyos.nix
│   ├── desktop.nix
│   ├── gaming.nix
│   └── performance.nix
└── home/
    └── gaming.nix

Requirements

x86_64 machine

UEFI firmware

NixOS Live ISO for a clean installation

Internet connection

A target disk dedicated to the installation

Warning: hosts/gaming/disko.nix currently targets /dev/nvme0n1.
Disko is destructive when run in disko mode. Always verify the target disk with
lsblk before running Disko.

CachyOS kernel

The project uses nix-cachyos-kernel and the linuxPackages-cachyos-latest kernel.

The current configuration uses the pinned overlay so that the kernel can use the
upstream project's binary cache when available.

The CachyOS kernel cache is:

https://attic.xuyh0120.win/lantian

with public key:

lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=

Local development / validation

The following commands are intentionally run with sudo when testing the full
system configuration. This avoids the restricted-setting problem encountered when
the Attic substituter is supplied by the flake to an untrusted Nix client.

1. Check the flake

sudo nix flake check

2. Build the complete NixOS system without activating it

sudo nix build \
  .#nixosConfigurations.gaming.config.system.build.toplevel \
  -L

This verifies the complete system generation without changing the running system.

3. Verify the configured kernel

sudo nix eval \
  .#nixosConfigurations.gaming.config.boot.kernelPackages.kernel.name

Expected:

"linux-cachyos-latest-7.2.4"

The exact version may change when flake.lock is updated.

4. Verify the NixOS state version

sudo nix eval \
  .#nixosConfigurations.gaming.config.system.stateVersion

Expected:

"26.05"

stateVersion intentionally remains at the compatibility version and is independent
from the nixpkgs channel used to build the system.

5. Dry-build a NixOS generation

Before activating a configuration on an installed system:

sudo nixos-rebuild dry-build --flake .#gaming

No system generation is activated by this command.

6. Activate the configuration

Only after the checks above succeed:

sudo nixos-rebuild switch --flake .#gaming

Binary cache

The project declares the CachyOS kernel cache in the flake configuration.

On NixOS, /etc/nix/nix.conf is generated and should not be edited manually.
System-wide Nix settings should be declared through NixOS configuration, for example:

nix.settings = {
  trusted-users = [
    "root"
    "user"
  ];

  substituters = [
    "https://cache.nixos.org/"
    "https://attic.xuyh0120.win/lantian"
  ];

  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];
};

If the cache is supplied through the flake and the command is run as an untrusted
user, Nix may print:

ignoring untrusted substituter
ignoring the client-specified setting 'trusted-public-keys'

Using sudo nix ... for the validation/build commands above avoids this problem
because the active Nix configuration currently trusts root.

Clean installation from a NixOS Live ISO

The project does not need to be cloned onto the Live ISO.

The repository can be consumed directly from GitHub:

github:barnaby0x0/nixos-gaming#gaming

1. Boot the NixOS Live ISO

Open a root shell:

sudo -i

Make sure networking works.

2. Identify the target disk

Before doing anything destructive:

lsblk -o NAME,SIZE,MODEL,SERIAL,FSTYPE,LABEL,PARTLABEL,MOUNTPOINTS

Also useful:

blkid

The current disko.nix expects:

/dev/nvme0n1

Do not continue if this is not the intended installation disk.

3. Preview Disko's target

If the configuration has not been applied yet, inspect the configuration and
verify the target disk before executing it.

4. Partition, format and mount with Disko

Disko can consume the remote flake directly:

sudo nix \
  --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode disko \
  --flake github:barnaby0x0/nixos-gaming#gaming

DESTRUCTIVE: --mode disko will partition and format the disks described by
the configuration.

After Disko completes, verify the mounts:

mount | grep /mnt

and:

lsblk -o NAME,SIZE,FSTYPE,LABEL,PARTLABEL,MOUNTPOINTS

Expected layout:

nvme0n1
├─nvme0n1p1   vfat   disk-main-EFI    /mnt/boot
└─nvme0n1p2   ext4   disk-main-NIXOS  /mnt

The exact device names can differ, but the EFI and NIXOS partition labels should
match the Disko configuration.

5. Install NixOS directly from GitHub

No repository clone is required.

Use:

sudo nixos-install \
  --no-write-lock-file \
  --flake github:barnaby0x0/nixos-gaming#gaming

Why --no-write-lock-file?

A remote GitHub flake is read-only from the Live ISO. nixos-install may otherwise
try to update the flake lock file and fail with:

cannot write modified lock file of flake
(use '--no-write-lock-file' to ignore this)

The option prevents Nix from trying to write the remote repository's lock file.

6. Reboot

After a successful installation:

reboot

Remove the Live ISO/USB and boot from the installed system.

Important installation notes

Do not use this

sudo nixos-install --extra-experimental-features "nix-command flakes" ...

--extra-experimental-features is not a nixos-install option.

If flakes need to be enabled for a command, use the Nix command's option, for
example:

sudo nix \
  --experimental-features "nix-command flakes" \
  ...

The NixOS Live environment used for this project already supports the required
flake functionality.

Disko and hardware-configuration.nix

Disko generates the filesystem configuration from disko.nix.

Therefore hosts/gaming/hardware-configuration.nix must not define a duplicate
fileSystems."/" or swapDevices entry for the Disko-managed partitions.

Otherwise NixOS can fail with conflicting filesystem definitions.

Do not run Disko during a normal rebuild

A normal:

sudo nixos-rebuild switch --flake .#gaming

does not mean "repartition the disk".

Disko is used during installation/initial disk preparation. The Disko configuration
is also imported into the NixOS configuration so that the resulting filesystem
definitions remain declarative.

Current status

Validated during development:

Flake evaluation

Disko module integration

EFI + ext4 root layout

NixOS system build

CachyOS kernel selection

CachyOS kernel binary cache access

KDE Plasma configuration

Steam / gaming stack configuration

The configured kernel currently evaluates to:

linux-cachyos-latest-7.2.4

The exact version is pinned by flake.lock and can change after a flake update.

TODO

The current configuration is intentionally generic.

K8 Plus-specific work will be done separately:

identify exact CPU and GPU

select the appropriate CachyOS microarchitecture package

evaluate x86-64-v3/v4 or Zen-specific kernel variants

AMDGPU / Mesa / RADV tuning

ReBAR / VRR / HDR

Gamescope configuration

CPU frequency and power-management tuning

scheduler comparison

EEVDF vs BORE

benchmark stock vs CachyOS configuration

evaluate sched_ext where appropriate

The generic configuration should remain usable independently from the K8 Plus
hardware-specific profile.