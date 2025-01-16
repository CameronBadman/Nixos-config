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

  # Add required system packages
  environment.systemPackages = with pkgs; [
    # Language Servers
    gopls
    rust-analyzer
    nodePackages.typescript-language-server
    lua-language-server
    nil # Nix LSP
    
    # Required dependencies
    python311Packages.pip
    luarocks
    
    # Development tools
    ripgrep
    fd
    
    # For clipboard support
    wl-clipboard
  ];

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
        
        -- Create config directory if it doesn't exist
        local config_dir = '/var/lib/nvim/config/nvim'
        if vim.fn.isdirectory(config_dir) == 0 then
          vim.fn.mkdir(config_dir, 'p')
        end
        
        -- Set up lazy.nvim paths
        vim.g.lazy_path = '/var/lib/nvim/lazy'
        vim.g.lazy_config = {
          root = vim.g.lazy_path,
          lockfile = vim.g.lazy_path .. '/lazy-lock.json',
          state = vim.g.lazy_path .. '/state.json',
          readme = {
            root = vim.g.lazy_path .. '/readme',
          },
        }

        -- Disable luarocks warning
        vim.g.lazy_rocks = {
          enabled = false
        }

        -- Set up Mason and LSP paths
        vim.env.MASON_INSTALL_DIR = '/var/lib/nvim/mason'
        vim.env.LSP_SERVERS_DIR = '/var/lib/nvim/lsp'
        
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
          # ... your existing plugins ...
        ];
      };
    };
  };

  # Directory structure with additional directories
  systemd.tmpfiles.rules = [
    # Base directories
    "d /var/lib/nvim 0755 root root -"
    "d /var/lib/nvim/config 0750 cameron cameron -"
    "d /var/lib/nvim/config/nvim 0750 cameron cameron -" # Add this line
    "d /var/lib/nvim/data 0750 cameron cameron -"
    "d /var/lib/nvim/state 0750 cameron cameron -"
    "d /var/lib/nvim/cache 0750 cameron cameron -"
    "d /var/lib/nvim/lazy 0750 cameron cameron -"
    "d /var/lib/nvim/lsp 0750 cameron cameron -"
    "d /var/lib/nvim/mason 0750 cameron cameron -"
    "d /var/lib/nvim/undo 0750 cameron cameron -"
    "d /var/lib/nvim/swap 0750 cameron cameron -"
    "d /var/lib/nvim/backup 0750 cameron cameron -"
  ];
}
