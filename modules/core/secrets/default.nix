{ config, ... }:
{
  age = {
    identityPaths = [ 
      "/home/cameron/.config/sops/age/keys.txt"
      "/home/cameron/.ssh/id_ed25519"
    ];
    secrets = {
      test = {
        file = ../../../secrets/test.age;  # Point to secrets directory
        owner = "cameron";
        group = "users";
        mode = "400";
      };
    };
  };
}

