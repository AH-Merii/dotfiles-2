local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true } },
}

function M.config()
	local wk = require("which-key")
	local builtin = require("telescope.builtin")

	-- Variables to track the last used command and hidden files status
	local last_command = "find_files"
	local show_hidden = false

	-- Function to launch find_files
	local function find_files()
		last_command = "find_files"
		builtin.find_files({ hidden = show_hidden })
	end

	-- Function to launch live_grep
	local function live_grep()
		last_command = "live_grep"
		builtin.live_grep({ hidden = show_hidden })
	end

	-- Function to toggle hidden files
	local function toggle_hidden_files()
		show_hidden = not show_hidden

		if last_command == "find_files" then
			find_files()
		elseif last_command == "live_grep" then
			live_grep()
		end
	end

	-- Setting up the which-key bindings
	wk.add({
		{ "<leader>f", group = "Find" }, -- group
		{ "<leader>fB", "<cmd>Telescope buffers<cr>", desc = "Find" },
		{ "<leader>fb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
		{ "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
		{ "<leader>ff", find_files, desc = "Find files" },
		{ "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
		{ "<leader>ft", live_grep, desc = "Find Text" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
		{ "<leader>fn", "<cmd>Telescope noice<cr>", desc = "Noice" },
		{ "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
		{ "<C-h>", toggle_hidden_files, desc = "Toggle Hidden Files in Telescope", mode = "i" },
	})

	local icons = require("user.icons")
	local actions = require("telescope.actions")

	require("telescope").setup({
		defaults = {
			prompt_prefix = icons.ui.Telescope .. " ",
			selection_caret = icons.ui.Forward .. " ",
			entry_prefix = "   ",
			initial_mode = "insert",
			selection_strategy = "reset",
			path_display = { "smart" },
			color_devicons = true,
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
				n = {
					["<esc>"] = actions.close,
					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,
					["q"] = actions.close,
				},
			},
		},
		pickers = {
			buffers = {
				initial_mode = "normal",
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer,
					},
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			},
			planets = {
				show_pluto = true,
				show_moon = true,
			},
			colorscheme = {
				enable_preview = true,
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- "ignore_case" or "respect_case"
			},
		},
	})
end

return M
