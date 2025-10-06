local M = { "yetone/avante.nvim" }

M.build = "make"
M.event = "VeryLazy"
M.version = "*"

M.dependencies = {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	--- The below dependencies are optional,
	-- "echasnovski/mini.pick", -- for file_selector provider mini.pick
	-- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
	-- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
	"saghen/blink.cmp", -- autocompletion for avante commands and mentions
	"ibhagwan/fzf-lua", -- for file_selector provider fzf
	-- "stevearc/dressing.nvim", -- for input provider dressing
	"folke/snacks.nvim", -- for input provider snacks
	-- "echasnovski/mini.icons",
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
	"zbirenbaum/copilot.lua", -- for providers='copilot'
	{
		-- support for image pasting
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			-- recommended settings
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				drag_and_drop = { insert_mode = true },
				-- required for Windows users
				use_absolute_path = true,
			},
		},
	},
	"MeanderingProgrammer/render-markdown.nvim",
}

M.build = "make BUILD_FROM_SOURCE=true"
M.event = "VeryLazy"
M.version = false

function M.opts()
	return {
		instructions_file = "avante.md",
		provider = "openai",
		mode = "agentic",
		auto_suggestions_provider = "openai",
		rag_service = {
			enabled = true,
			host_mount = os.getenv("HOME"),
			runner = "docker",
			llm = {
				provider = "openai",
				endpoint = "https://api.openai.com/v1",
				api_key = "OPENAI_API_KEY",
				model = "gpt-4o-mini",
				extra = nil,
			},
			embed = {
				provider = "openai",
				endpoint = "https://api.openai.com/v1",
				api_key = "OPENAI_API_KEY",
				model = "text-embedding-3-large",
				extra = nil,
			},
			docker_extra_args = "",
		},
		web_search_engine = {
			provider = "tavily",
			proxy = nil,
		},
		providers = {
			openai = {
				endpoint = "https://api.openai.com/v1",
				model = "gpt-4o-mini",
				timeout = 30000,
				extra_request_body = { temperature = 0.75, max_tokens = 16384 },
			},
		},
		input = {
			provider = "snacks",
			provider_opts = {
				title = "Avante Input",
				icon = " ",
			},
		},
	}
end

return M
