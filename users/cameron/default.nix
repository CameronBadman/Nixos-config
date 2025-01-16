# users/cameron/default.nix
{ pkgs, ... }: {
  home.stateVersion = "23.11";
  home.username = "cameron";
  home.homeDirectory = "/home/cameron";
  
  programs.home-manager.enable = true;  # Add this line

  # Your existing configurations can go here
  fonts.fontconfig.enable = false;
  xdg.enable = false;
  
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github_key";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
