{ config, lib, pkgs, inputs, ... }: {
  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" "users" "docker" ];
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
  home-manager.users.cameron = { config, pkgs, ... }: {
    home.stateVersion = "23.11";
    fonts.fontconfig.enable = false;
    xdg.enable = true;
    xdg.cacheHome = "/home/cameron/.cache";
    
    # Create .cache/gopls directory
    home.file.".cache/gopls/.keep".text = "";
    programs.git = {
      enable = true;
      package = pkgs.git;
      userName = "CameronBadman";
      userEmail = "cbadwork@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/github_key";
          extraOptions = { AddKeysToAgent = "yes"; };
        };
        "moss" = {
          hostname = "moss.labs.eait.uq.edu.au";
          user = "sNNNNNNN";  # Replace with actual username
          addKeysToAgent = true;
          extraOptions = { UseKeychain = "no"; };
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
    home.packages = [ inputs.nvim-flake.packages.${pkgs.system}.default ];
  };
}
