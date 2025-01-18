{ pkgs, inputs, ... }:

{
  home-manager.users.cameron = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        gopls # Go language server
        rust-analyzer # Rust language server
        nodePackages.typescript-language-server # TypeScript/JavaScript language server
        lua-language-server # Lua language server
        nil # Nix language server
        sonarlint-ls # SonarLint language server

        # Language Tools & Package Managers
        python311Packages.pip # Python package manager
        luarocks # Lua package manager

        # Code Formatters
        black # Python formatter
        stylua # Lua formatter
        nodePackages.prettier # JavaScript/TypeScript/JSON/YAML/HTML/CSS formatter
        shfmt # Shell script formatter
        nixfmt # Nix formatter

        # Linters & Code Quality
        codespell # Spell checker for code

        # System Tools
        ripgrep # Fast grep replacement
        fd # Fast find replacement
        wl-clipboard # Wayland clipboard utility

        # Kubernetes Tools
        kubectl # Kubernetes command-line tool

        # Additional C/C++ Tools (from previous discussion)
        clang-tools # Includes clang-format
        cpplint # Google's C++ linter

        # Additional Go Tools (from previous discussion)
        golangci-lint # Go linter suite
      ];
      plugins = with pkgs.vimPlugins; [
        # Package management
        lazy-nvim

        # Core plugins
        plenary-nvim
        nvim-web-devicons
        conform-nvim
        nvim-lint

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
        cmp-calc

        # Git
        gitsigns-nvim
        vim-fugitive

        # File navigation and UI
        telescope-nvim
        telescope-fzf-native-nvim
        neo-tree-nvim
        lualine-nvim

        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "kubectl-nvim";
            src = inputs.kubectl-nvim;
          };
          type = "lua"; # Add this line
        }

        catppuccin-nvim

        # Syntax and languages
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            lua
            python
            typescript
            javascript
            go
            rust
            c
            cpp
            java
            json
            yaml
            toml
            html
            css
            markdown
            markdown_inline
            vim
            vimdoc
            query
          ]))
      ];

      extraLuaConfig = ''
           -- Theme setup
        vim.cmd.colorscheme("catppuccin")
        require('gitsigns').setup()
        require("config")
      '';
    };

    xdg.configFile = {
      "nvim/lua/config" = {
        source = ./config;
        recursive =
          true; # This will copy all files in the directory recursively
      };
    };
  };
}
