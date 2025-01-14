{ config, lib, pkgs, ... }:
{
  environment.etc = {
    "xdg/nvim".source = pkgs.fetchFromGitHub {
      owner = "CameronBadman";
      repo = "nvim-config";
      rev = "main";
      sha256 = "0wld074v5r13gij32jgrpdjd8r767rrcpbqwj8i8ffiffx88ykx6";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        lua << EOF
        -- Set up XDG paths
        vim.env.XDG_CONFIG_HOME = '/var/lib/nvim/config'
        vim.env.XDG_DATA_HOME = '/var/lib/nvim/data'
        vim.env.XDG_STATE_HOME = '/var/lib/nvim/state'
        vim.env.XDG_CACHE_HOME = '/var/lib/nvim/cache'

        -- Set up lazy.nvim paths before loading anything
        vim.g.lazy_path = '/var/lib/nvim/lazy'
        -- Configure lazy to use our writable directory
        vim.g.lazy_config = {
          root = vim.g.lazy_path,
          lockfile = vim.g.lazy_path .. '/lazy-lock.json',
          state = vim.g.lazy_path .. '/state.json',
          readme = {
            root = vim.g.lazy_path .. '/readme',
          },
        }

        -- Add config directories to runtimepath
        vim.opt.runtimepath:prepend("/etc/xdg/nvim")
        vim.opt.runtimepath:prepend(vim.g.lazy_path)
        vim.opt.runtimepath:append("/etc/xdg/nvim/lua")
        
        -- Add lua path for plugins
        package.path = package.path .. ";/etc/xdg/nvim/lua/?.lua"
        package.path = package.path .. ";/etc/xdg/nvim/lua/?/init.lua"
        
        -- Set up clipboard
        vim.g.clipboard = {
          name = 'wl-clipboard',
          copy = {
            ['+'] = 'wl-copy',
            ['*'] = 'wl-copy',
          },
          paste = {
            ['+'] = 'wl-paste',
            ['*'] = 'wl-paste',
          },
          cache_enabled = 1,
        }
        
        -- Load init.lua
        dofile("/etc/xdg/nvim/init.lua")
        EOF
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ 
          lazy-nvim
          nvim-treesitter
          plenary-nvim
          telescope-nvim
          nvim-lspconfig
          nvim-jdtls
          rust-tools-nvim
          typescript-tools-nvim
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          which-key-nvim
          vim-illuminate
          nvim-web-devicons
          mason-nvim
          mason-lspconfig-nvim
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/nvim 0755 root root -"
    "d /var/lib/nvim/config 0750 cameron cameron -"
    "d /var/lib/nvim/data 0750 cameron cameron -"
    "d /var/lib/nvim/state 0750 cameron cameron -"
    "d /var/lib/nvim/cache 0750 cameron cameron -"
    "d /var/lib/nvim/lazy 0750 cameron cameron -"
  ];
}


