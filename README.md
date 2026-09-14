# NixOS Gaming

A reproducible NixOS gaming environment inspired by CachyOS.

The goal is to combine:

- NixOS
- CachyOS kernel optimizations
- Steam
- Proton
- GE-Proton
- DXVK
- VKD3D
- Gamescope
- GameMode
- MangoHud
- Mesa / Vulkan
- zram
- performance tuning

The entire system is managed declaratively using Nix flakes.

---

## Architecture

```text
NixOS
 │
 ├── CachyOS Kernel
 │
 ├── KDE Plasma
 │
 ├── AMDGPU / Mesa / Vulkan
 │
 └── Gaming
      ├── Steam
      ├── Proton
      ├── GE-Proton
      ├── Gamescope
      ├── GameMode
      └── MangoHud
