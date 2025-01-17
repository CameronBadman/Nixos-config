local M = {}

function M.setup()
    local group = vim.api.nvim_create_augroup("kubectl_mappings", { clear = true })
    
    -- Main toggle mapping
    vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })
    
    -- Setup autocmd for kubectl-specific mappings
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "k8s_*",
        callback = function(ev)
            local k = vim.keymap.set
            local opts = { buffer = ev.buf }
            
            -- Global
            k("n", "g?", "<Plug>(kubectl.help)", opts)
            k("n", "gr", "<Plug>(kubectl.refresh)", opts)
            k("n", "gs", "<Plug>(kubectl.sort)", opts)
            k("n", "gD", "<Plug>(kubectl.delete)", opts)
            k("n", "gd", "<Plug>(kubectl.describe)", opts)
            k("n", "gy", "<Plug>(kubectl.yaml)", opts)
            k("n", "ge", "<Plug>(kubectl.edit)", opts)
            k("n", "<C-l>", "<Plug>(kubectl.filter_label)", opts)
            k("n", "<BS>", "<Plug>(kubectl.go_up)", opts)
            k("v", "<C-f>", "<Plug>(kubectl.filter_term)", opts)
            k("n", "<CR>", "<Plug>(kubectl.select)", opts)
            k("n", "<Tab>", "<Plug>(kubectl.tab)", opts)
            k("n", "<S-Tab>", "<Plug>(kubectl.shift_tab)", opts)
            k("n", "", "<Plug>(kubectl.quit)", opts)
            k("n", "gk", "<Plug>(kubectl.kill)", opts)
            k("n", "<M-h>", "<Plug>(kubectl.toggle_headers)", opts)
            
            -- Views
            k("n", "<C-a>", "<Plug>(kubectl.alias_view)", opts)
            k("n", "<C-x>", "<Plug>(kubectl.contexts_view)", opts)
            k("n", "<C-f>", "<Plug>(kubectl.filter_view)", opts)
            k("n", "<C-n>", "<Plug>(kubectl.namespace_view)", opts)
            k("n", "gP", "<Plug>(kubectl.portforwards_view)", opts)
            k("n", "1", "<Plug>(kubectl.view_deployments)", opts)
            k("n", "2", "<Plug>(kubectl.view_pods)", opts)
            k("n", "3", "<Plug>(kubectl.view_configmaps)", opts)
            k("n", "4", "<Plug>(kubectl.view_secrets)", opts)
            k("n", "5", "<Plug>(kubectl.view_services)", opts)
            k("n", "6", "<Plug>(kubectl.view_ingresses)", opts)
            
            -- Deployment/DaemonSet actions
            k("n", "grr", "<Plug>(kubectl.rollout_restart)", opts)
            k("n", "gss", "<Plug>(kubectl.scale)", opts)
            k("n", "gi", "<Plug>(kubectl.set_image)", opts)
            
            -- Pod/Container logs
            k("n", "gl", "<Plug>(kubectl.logs)", opts)
            k("n", "gh", "<Plug>(kubectl.history)", opts)
            k("n", "f", "<Plug>(kubectl.follow)", opts)
            k("n", "gw", "<Plug>(kubectl.wrap)", opts)
            k("n", "gp", "<Plug>(kubectl.prefix)", opts)
            k("n", "gt", "<Plug>(kubectl.timestamps)", opts)
            k("n", "gpp", "<Plug>(kubectl.previous_logs)", opts)
            
            -- Node actions
            k("n", "gC", "<Plug>(kubectl.cordon)", opts)
            k("n", "gU", "<Plug>(kubectl.uncordon)", opts)
            k("n", "gR", "<Plug>(kubectl.drain)", opts)
            
            -- Top actions
            k("n", "gn", "<Plug>(kubectl.top_nodes)", opts)
            k("n", "gp", "<Plug>(kubectl.top_pods)", opts)
            
            -- CronJob actions
            k("n", "gss", "<Plug>(kubectl.suspend_cronjob)", opts)
            k("n", "gc", "<Plug>(kubectl.create_job)", opts)
            k("n", "gp", "<Plug>(kubectl.portforward)", opts)
            k("n", "gx", "<Plug>(kubectl.browse)", opts)
            k("n", "gy", "<Plug>(kubectl.yaml)", opts)
        end,
    })
end

return M
