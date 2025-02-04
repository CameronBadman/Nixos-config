{ pkgs, inputs, ... }: {
  home-manager.users.cameron = {
    home.packages = with pkgs; [ golangci-lint ];
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      
      imports = [ 
        ./config/lsp 
        ./nixvim/plugins/neo-tree.nix  
      ];
      
      extraPackages = with pkgs; [
        gopls rust-analyzer nodePackages.typescript-language-server
        lua-language-server nil sonarlint-ls pylint shellcheck eslint
        python311Packages.pip luarocks black stylua nodePackages.prettier
        shfmt nixfmt codespell ripgrep fd wl-clipboard kubectl
        clang-tools cpplint
      ];

      colorschemes.kanagawa = {
        enable = true;
        theme = "wave";
        transparent = true;
      };

      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "kubectl-nvim";
          src = inputs.kubectl-nvim;
        })
      ];

      plugins = {
        cmp = {
          enable = true;
          settings = {
            snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "buffer"; }
              { name = "path"; }
              { name = "calc"; }
            ];
            mapping = {
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping.close()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
              "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
            };
          };
        };

        luasnip.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true;
        cmp-calc.enable = true;
        cmp_luasnip.enable = true;

        treesitter = {
          enable = true;
          ensureInstalled = [
            "lua" "python" "typescript" "javascript" "go" "rust"
            "c" "cpp" "java" "json" "yaml" "toml" "html" "css"
            "markdown" "markdown_inline" "vim" "vimdoc" "query"
          ];
        };
      };

      extraConfigLua = ''
        -- Enable transparency
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
        require("config")
      '';
    };

    xdg.configFile = {
      "nvim/lua/config" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
