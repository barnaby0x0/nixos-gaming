{ users, lib, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users = lib.mapAttrs (_: user: {
    extraGroups = lib.optionals user.enableVirt [
      "libvirtd"
      "kvm"
    ];
  }) users;
}
