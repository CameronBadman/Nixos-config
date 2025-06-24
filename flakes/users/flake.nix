{
  description = "User configuration for Cameron";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };
  
  outputs = { self, nixpkgs, home-manager }: {
    nixosModules.default = { config, lib, pkgs, inputs, ... }: {
      # User configuration
      users.users.cameron = {
        isNormalUser = true;
        extraGroups = [ "wheel" "users" "docker" "networkmanager" "video" "audio" "input" "render" ];
        initialPassword = "temppass";
        shell = pkgs.bash;
      };
      
      # Home Manager configuration
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        
        users.cameron = { pkgs, ... }: {
          home.username = "cameron";
          home.homeDirectory = "/home/cameron";
          home.stateVersion = "23.11";
          
          # Desktop packages managed by home-manager
          home.packages = with pkgs; [
            # Custom Neovim from your flake
            inputs.nvim-flake.packages.x86_64-linux.default
            
            # Browsers
            firefox
            google-chrome
            
            # File manager
            nautilus
            
            # Terminal
            kitty
            
            # Screenshots and utilities
            grim
            slurp
            
            # Notifications
            dunst
            libnotify
            
            # App launcher - REMOVED rofi-wayland from here since we enable it in programs
            
            # Wallpaper management
            hyprpaper
            
            # Network manager GUI
            networkmanagerapplet
            
            # System utilities
            brightnessctl
            neofetch
            htop
            usbutils
            pciutils
            lshw
            
            # Fonts
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            liberation_ttf
            fira-code
            fira-code-symbols
            nerd-fonts.fira-code
            nerd-fonts.droid-sans-mono
            nerd-fonts.jetbrains-mono
          ];

          # Font configuration
          fonts.fontconfig.enable = true;

          # Program configurations
          programs = {
            git = {
              enable = true;
              userName = "CameronBadman";
              userEmail = "cbadwork@gmail.com";
            };
            
            firefox.enable = true;
            
            kitty = {
              enable = true;
              # Add kitty configuration here if needed
            };
            
            rofi = {
              enable = true;
              package = pkgs.rofi-wayland;  # Use the Wayland version
              # Add rofi configuration here
            };
            
            home-manager.enable = true;
          };
        };
      };
    };
  };
}
