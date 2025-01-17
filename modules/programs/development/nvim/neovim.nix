{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nvf.nixosModules.default
  ];

  programs.nvf = {
    enable = true;
    
    # Your existing system packages
    extraPackages = with pkgs; [
      gopls
      rust-analyzer
      nodePackages.typescript-language-server
      lua-language-server
      nil
      python311Packages.pip
      luarocks
      ripgrep
      fd
      wl-clipboard
    ];

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
      };

      # Core settings
      clipboard.enable = true;
      clipboard.provider = "wl-clipboard";
    };

    # LSP configurations
    lsp = {
      enable = true;
      servers = {
        gopls.enable = true;
        rust-analyzer.enable = true;
        tsserver.enable = true;
        lua-ls.enable = true;
        nil.enable = true;
      };
    };
  };

  # Your existing systemd tmpfiles rules can be converted to:
  environment.persistence = lib.mkIf config.programs.nvf.enable {
    "/var/lib/nvim" = {
      user = "cameron";
      group = "cameron";
      mode = "0750";
      directories = [
        "config"
        "data"
        "state"
        "cache"
        "lsp"
        "mason"
        "undo"
        "swap"
        "backup"
      ];
    };
  };
}

