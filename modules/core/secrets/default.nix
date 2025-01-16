{ config, ... }:
{
  age = {
    identityPaths = [ "/home/cameron/.config/sops/age/keys.txt" ];
    secrets = {
      test = {
        file = ../../../../secrets/test.age;
        owner = "cameron";
        group = "users";
        mode = "400";
      };
    };
  };
}
