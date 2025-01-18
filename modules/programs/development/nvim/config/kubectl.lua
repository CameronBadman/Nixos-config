local M = {}

function M.setup()
	-- Create augroup for kubectl mappings
	local group = vim.api.nvim_create_augroup("kubectl_mappings", { clear = true })

	-- Main toggle mapping for kubectl window
	vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', {
		noremap = true,
		silent = true,
		desc = "Toggle kubectl window",
	})

	-- Setup autocmd for kubectl-specific mappings
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "k8s_*",
		callback = function(ev)
			local k = vim.keymap.set
			local opts = { buffer = ev.buf }

			-- Navigation and Global Actions
			k("n", "g?", "<Plug>(kubectl.help)", opts) -- Show help
			k("n", "gr", "<Plug>(kubectl.refresh)", opts) -- Refresh view
			k("n", "gs", "<Plug>(kubectl.sort)", opts) -- Sort items
			k("n", "<CR>", "<Plug>(kubectl.select)", opts) -- Select item
			k("n", "<Tab>", "<Plug>(kubectl.tab)", opts) -- Next tab
			k("n", "<S-Tab>", "<Plug>(kubectl.shift_tab)", opts) -- Previous tab
			k("n", "<BS>", "<Plug>(kubectl.go_up)", opts) -- Go up one level
			k("n", "", "<Plug>(kubectl.quit)", opts) -- Quit kubectl

			-- Resource Management
			k("n", "gD", "<Plug>(kubectl.delete)", opts) -- Delete resource
			k("n", "gd", "<Plug>(kubectl.describe)", opts) -- Describe resource
			k("n", "gy", "<Plug>(kubectl.yaml)", opts) -- Show YAML
			k("n", "ge", "<Plug>(kubectl.edit)", opts) -- Edit resource
			k("n", "gk", "<Plug>(kubectl.kill)", opts) -- Kill resource

			-- Filtering and Views
			k("n", "<C-l>", "<Plug>(kubectl.filter_label)", opts) -- Filter by label
			k("v", "<C-f>", "<Plug>(kubectl.filter_term)", opts) -- Filter by term
			k("n", "<M-h>", "<Plug>(kubectl.toggle_headers)", opts) -- Toggle headers

			-- Resource Views
			k("n", "<C-a>", "<Plug>(kubectl.alias_view)", opts) -- Alias view
			k("n", "<C-x>", "<Plug>(kubectl.contexts_view)", opts) -- Contexts view
			k("n", "<C-f>", "<Plug>(kubectl.filter_view)", opts) -- Filter view
			k("n", "<C-n>", "<Plug>(kubectl.namespace_view)", opts) -- Namespace view
			k("n", "gP", "<Plug>(kubectl.portforwards_view)", opts) -- Port forwards

			-- Numbered Resource Views
			k("n", "1", "<Plug>(kubectl.view_deployments)", opts) -- View deployments
			k("n", "2", "<Plug>(kubectl.view_pods)", opts) -- View pods
			k("n", "3", "<Plug>(kubectl.view_configmaps)", opts) -- View configmaps
			k("n", "4", "<Plug>(kubectl.view_secrets)", opts) -- View secrets
			k("n", "5", "<Plug>(kubectl.view_services)", opts) -- View services
			k("n", "6", "<Plug>(kubectl.view_ingresses)", opts) -- View ingresses

			-- Deployment Actions
			k("n", "grr", "<Plug>(kubectl.rollout_restart)", opts) -- Rollout restart
			k("n", "gss", "<Plug>(kubectl.scale)", opts) -- Scale deployment
			k("n", "gi", "<Plug>(kubectl.set_image)", opts) -- Set image

			-- Logs and Monitoring
			k("n", "gl", "<Plug>(kubectl.logs)", opts) -- View logs
			k("n", "gh", "<Plug>(kubectl.history)", opts) -- View history
			k("n", "f", "<Plug>(kubectl.follow)", opts) -- Follow logs
			k("n", "gw", "<Plug>(kubectl.wrap)", opts) -- Wrap logs
			k("n", "gp", "<Plug>(kubectl.prefix)", opts) -- Toggle prefix
			k("n", "gt", "<Plug>(kubectl.timestamps)", opts) -- Toggle timestamps
			k("n", "gpp", "<Plug>(kubectl.previous_logs)", opts) -- Previous logs

			-- Node Management
			k("n", "gC", "<Plug>(kubectl.cordon)", opts) -- Cordon node
			k("n", "gU", "<Plug>(kubectl.uncordon)", opts) -- Uncordon node
			k("n", "gR", "<Plug>(kubectl.drain)", opts) -- Drain node

			-- Resource Usage
			k("n", "gn", "<Plug>(kubectl.top_nodes)", opts) -- Top nodes
			k("n", "gp", "<Plug>(kubectl.top_pods)", opts) -- Top pods

			-- CronJob and Job Management
			k("n", "gss", "<Plug>(kubectl.suspend_cronjob)", opts) -- Suspend cronjob
			k("n", "gc", "<Plug>(kubectl.create_job)", opts) -- Create job
			k("n", "gp", "<Plug>(kubectl.portforward)", opts) -- Port forward
			k("n", "gx", "<Plug>(kubectl.browse)", opts) -- Browse resource
			k("n", "gy", "<Plug>(kubectl.yaml)", opts) -- View YAML
		end,
	})
end

return M
