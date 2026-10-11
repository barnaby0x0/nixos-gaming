# { users, lib, ... }:

# {
#   # Activer la virtualisation si au moins un utilisateur en a besoin
#   config = lib.mkIf (lib.any (user: user.enableVirt) (builtins.attrValues users)) {
#     virtualisation.libvirtd.enable = true;
#     programs.virt-manager.enable = true;
#     users.users = lib.mapAttrs (_: user: {
#       extraGroups = lib.optionals user.enableVirt [
#         "libvirtd"
#         "kvm"
#       ];
#     }) users;
#   };
# }

{ users, lib, ... }:

lib.mkMerge [
  # Activer la virtualisation si au moins un utilisateur en a besoin
  (lib.mkIf (lib.any (user: user.enableVirt) (builtins.attrValues users)) {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  })

  # Ajouter les groupes uniquement aux utilisateurs autorisés
  {
    users.users = lib.mapAttrs (_: user: {
      extraGroups = lib.optionals user.enableVirt [
        "libvirtd"
        "kvm"
      ];
    }) users;
  }
]

# { users, lib, ... }:

# {
#   virtualisation.libvirtd.enable = true;
#   programs.virt-manager.enable = true;

#   users.users = lib.mapAttrs (_: user: {
#     extraGroups = lib.optionals user.enableVirt [
#       "libvirtd"
#       "kvm"
#     ];
#   }) users;
# }
