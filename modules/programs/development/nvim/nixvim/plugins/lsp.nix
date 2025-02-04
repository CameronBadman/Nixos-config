{
  plugins = {
    # Enable LSP support
    lsp = {
      enable = true;
      
      # Configure specific servers
      servers = {
        # Python LSP (pyright)
        pyright.enable = true;
        
        # Lua LSP (lua-language-server)
        lua-ls.enable = true;
        
        # Rust analyzer
        rust-analyzer.enable = true;
        
        # Nix language server
        nixd.enable = true;
        
        # TypeScript/JavaScript (tsserver)
        tsserver.enable = true;
        
        # Go language server
        gopls = {
          enable = true;
          settings = {
            # Analyses configuration goes here
            analyses = {
              # Core language analyses
              unusedparams = true;
              shadow = true;
              assign = true;
              structtag = true;
              unreachable = true;
              unusedregexp = true;
              typeassert = true;
              unusedwrite = true;
              switch = true;
              printf = true;
              atomic = true;
              naked = true;
              ineffectiveassign = true;
              comparisons = true;
              nilness = true;
              
              # Additional potential analyses
              fieldalignment = true;
              unusedvariable = true;
              simplifycompositelit = true;
              httpresponse = true;
            };
            
            # Other gopls settings
            staticcheck = true;
            usePlaceholders = true;
            completeUnimported = true;
            deepCompletion = true;
          };
        };
      };
    };

    # Optional: Add lsp-related plugins for better experience
    lsp-lines.enable = true;  # Show diagnostics in a more readable way
    trouble.enable = true;    # Better diagnostics view
  };

  # Optional: Additional LSP keymappings
  keymaps = [
    # Go to definition
    { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; }
    # Show hover documentation
    { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; }
    # Show code actions
    { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; }
    # Open diagnostics list
    { mode = "n"; key = "<leader>dl"; action = "<cmd>TroubleToggle<CR>"; }
  ];

  # Optional: Additional LSP configuration in Lua
  extraConfigLua = ''
    -- Additional LSP setup
    local lspconfig = require('lspconfig')
    
    -- Custom server configurations
    lspconfig.pyright.setup {
      settings = {
        pyright = {
          autoImportCompletions = true,
        }
      }
    }

    -- Additional diagnostic configuration
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- LSP handler improvements
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded"
      }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded"
      }
    )
  '';
}
