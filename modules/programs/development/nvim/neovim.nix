{ config, lib, pkgs, ... }:

{
  home-manager.users.cameron = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

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

      plugins = with pkgs.vimPlugins; [
        # Core plugins
        lazy-nvim
        plenary-nvim
        nvim-web-devicons

        # LSP Support
        nvim-lspconfig
        mason-nvim
        mason-lspconfig-nvim

        # Completion
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        luasnip
        cmp_luasnip

        # Git
        gitsigns-nvim
        vim-fugitive

        # File navigation and UI
        telescope-nvim
        neo-tree-nvim
        lualine-nvim
        
        # Syntax and languages
        nvim-treesitter.withAllGrammars
        
        # Theme
        cyberdream-nvim
      ];

      extraLuaConfig = ''
        -- Basic settings
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.clipboard = "unnamedplus"
        
        -- Leader key
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        -- Theme setup
        vim.cmd.colorscheme("cyberdream")
      '';
    };
  };
}

