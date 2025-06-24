{ config, lib, pkgs, inputs, ... }: {
  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" "users" "docker" "networkmanager" "video" "audio" "input" "render" ];
    initialPassword = "temppass";
    shell = pkgs.bash;
    home = "/home/cameron";
    createHome = true;
    homeMode = "755";
  };
  
  system.activationScripts = {
    fixHomePermissions = {
      text = ''
        mkdir -p /home/cameron/.config /home/cameron/.local /home/cameron/.cache/gopls
        chown -R cameron:users /home/cameron
        chmod 755 /home/cameron
        chmod -R u+rw /home/cameron/.config /home/cameron/.local /home/cameron/.cache
        chmod 755 /home/cameron/.cache/gopls
      '';
      deps = [];
    };
  };
}
