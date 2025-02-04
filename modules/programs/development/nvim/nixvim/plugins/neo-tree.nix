{
  plugins.neo-tree = {
    enable = true;
    closeIfLastWindow = false;
    enableGitStatus = true;
    enableDiagnostics = true;
    filesystem = {
      followCurrentFile = {
        enabled = true;
        leaveDirsOpen = true;
      };
      useLibuvFileWatcher = true;
      filteredItems = {
        visible = true;
        hideDotfiles = false;
        hideGitignored = false;
        hideByName = [
          ".DS_Store"
          "thumbs.db"
          ".git"
        ];
        neverShow = [
          ".git"
          ".cache"
        ];
      };
    };
    window = {
      position = "left";
      width = 35;
      mappings = {
        "<space>" = "toggle_node";
        "<2-LeftMouse>" = "open";
        "<cr>" = "open";
        "<esc>" = "revert_preview";
        "P" = "toggle_preview";
        "l" = "focus_preview";
        "S" = "open_split";
        "s" = "open_vsplit";
        "t" = "open_tabnew";
        "w" = "open_with_window_picker";
        "C" = "close_node";
        "z" = "close_all_nodes";
        "Z" = "expand_all_nodes";
        "a" = "add";
        "A" = "add_directory";
        "d" = "delete";
        "r" = "rename";
        "y" = "copy_to_clipboard";
        "x" = "cut_to_clipboard";
        "p" = "paste_from_clipboard";
        "c" = "copy";
      };
    };
  };

  # Keep your custom focus functions
  extraConfigLua = ''
    -- Function to handle Neo-tree focus
    local function focus_neo_tree()
        local neo_tree_wins = vim.tbl_filter(function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            return vim.bo[buf].filetype == "neo-tree"
        end, vim.api.nvim_list_wins())
        if #neo_tree_wins > 0 then
            vim.api.nvim_set_current_win(neo_tree_wins[1])
        else
            vim.cmd("Neotree show")
        end
    end

    -- Function to handle startup behavior
    local function setup_startup_behavior()
        local argc = vim.fn.argc()
        if argc == 0 then
            -- No files specified, open and focus Neo-tree
            vim.defer_fn(function()
                vim.cmd("Neotree show")
                focus_neo_tree()
            end, 10)
        else
            -- Files specified, open Neo-tree but don't focus it
            vim.defer_fn(function()
                vim.cmd("Neotree show")
                -- Focus the file window
                local file_wins = vim.tbl_filter(function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    return vim.bo[buf].filetype ~= "neo-tree"
                end, vim.api.nvim_list_wins())
                if #file_wins > 0 then
                    vim.api.nvim_set_current_win(file_wins[1])
                end
            end, 10)
        end
    end

    -- Make FocusNeoTree available globally
    _G.FocusNeoTree = focus_neo_tree

    -- Set up autocommand for startup behavior
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = setup_startup_behavior,
    })

    -- Map leader-e to focus rather than toggle
    vim.keymap.set("n", "<leader>e", function()
        focus_neo_tree()
    end, { noremap = true, silent = true, desc = "Focus Neo-tree" })
  '';
}
