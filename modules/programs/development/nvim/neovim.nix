{ pkgs, ... }:

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
        # Package management
        lazy-nvim

        # Core plugins
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
	telescope-fzf-native-nvim
        neo-tree-nvim
        lualine-nvim



	catppuccin-nvim
        
        # Syntax and languages
        (nvim-treesitter.withPlugins (plugins: with plugins; [
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

        -- Basic Keymaps
        vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

        -- Theme setup
        vim.cmd.colorscheme("catppuccin")

        -- LSP Configuration
        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- LSP servers setup
        local servers = {
          gopls = {},
          rust_analyzer = {},
          ts_ls = {},  -- Changed from tsserver
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = { globals = {'vim'} }
              }
            }
          },
          nil_ls = {},
        }

        -- Simple LSP setup for now, we'll move this to its own file later
        for server, config in pairs(servers) do
          if server == "ts_ls" then  -- Special case for typescript
            config.capabilities = capabilities
            config.root_dir = lspconfig.util.root_pattern("package.json")
            lspconfig[server].setup(config)
          else
            config.capabilities = capabilities
            lspconfig[server].setup(config)
          end
        end


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

        -- Completion setup
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
          },
        })

        -- Telescope setup
        local telescope = require('telescope')
        telescope.setup()
        
        local telescope_builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Find files' })
        vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Find buffers' })
        vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Help tags' })
	
	-- Lualine setup
        require('lualine').setup({
          options = {
            theme = 'catpuccin',
            icons_enabled = true,
          },
        })

        -- Git signs setup
        require('gitsigns').setup()
	require("config")
      '';
    };



xdg.configFile = {
      "nvim/lua/config/init.lua".source = ./config/init.lua;
      "nvim/lua/config/treesitter.lua".source = ./config/treesitter.lua;
      "nvim/lua/config/neo-tree.lua".source = ./config/neo-tree.lua;
      "nvim/lua/config/lualine.lua".source = ./config/lualine.lua;
      "nvim/lua/config/telescope.lua".source = ./config/telescope.lua;
      "nvim/lua/config/git.lua".source = ./config/git.lua;
    };
  };
}
