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
                -- Basic vim options
                vim.g.mapleader = " "
                vim.g.maplocalleader = " "

                -- Options
                vim.opt.number = true
                vim.opt.relativenumber = true
                vim.opt.mouse = 'a'
                vim.opt.showmode = false
                vim.opt.clipboard = 'unnamedplus'
                vim.opt.breakindent = true
                vim.opt.undofile = true
                vim.opt.ignorecase = true
                vim.opt.smartcase = true
                vim.opt.signcolumn = 'yes'
                vim.opt.updatetime = 250
                vim.opt.timeoutlen = 300
                vim.opt.splitright = true
                vim.opt.splitbelow = true
                vim.opt.list = true
                vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
                vim.opt.inccommand = 'split'
                vim.opt.cursorline = true
                  vim.opt.scrolloff = 10
                vim.opt.hlsearch = false

        		-- Add these with your other vim.opt settings
        		vim.opt.tabstop = 2       -- Number of spaces tabs count for
        		vim.opt.softtabstop = 2   -- Number of spaces a tab counts for during editing
        		vim.opt.shiftwidth = 2    -- Number of spaces for indentation
        		vim.opt.expandtab = true  -- Use spaces instead of tabs

                        -- Basic Keymaps
                        vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
                        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
                        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
                        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

                        -- Theme setup
                        vim.cmd.colorscheme("catppuccin")

                        -- LSP Keymaps
                        vim.api.nvim_create_autocmd('LspAttach', {
                          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                          callback = function(ev)
                            local opts = { buffer = ev.buf }
                            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set('n', '<leader>wl', function()
                              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)
                            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                          end,
                        })

                	-- Debug kubectl loading
                	  local status_ok, kubectl = pcall(require, "kubectl")
                	  if not status_ok then
                	    print("Failed to load kubectl plugin")
                	    return
                	  end
                	  
                	  -- Initialize kubectl with debug
                	  print("Setting up kubectl")
                	  kubectl.setup()
                	  
                	  -- Add explicit keybinding with debug
                	  vim.keymap.set("n", "<leader>k", function()
                	    print("Kubectl toggle triggered")
                	    kubectl.toggle()
                	  end, { noremap = true, silent = false })

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
