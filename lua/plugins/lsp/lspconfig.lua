local lspconfig_status, lspconfig = pcall(require, "lspconfig")

if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not cmp_nvim_lsp_status then
	return
end

local typescript_setup, typescript = pcall(require, "typescript")

if not typescript_setup then
	return
end

local keymap = vim.keymap

-- enable keybinds for available lsp servers
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
		keymap.set("n", "<C-s>", ":EslintFixAll<CR>") -- format with eslint
	end

	-- if client.name == "omnisharp" then
	-- 	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	-- end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["clangd"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
})

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["astro"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["eslint"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["gopls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["pyright"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["prismals"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["dockerls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["jdtls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["gradle_ls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["terraformls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig["docker_compose_language_service"].setup({
	filetypes = { "yaml.docker-compose", "yml.docker-compose" },
	root_dir = lspconfig.util.root_pattern("docker-compose.*"),
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			completion = {
				postfix = {
					enable = false,
				},
			},
			cargo = {
				features = "all",
				allFeatures = true,
			},
		},
	},
})

-- local csharp_ls_bin = "/home/suetham/.dotnet/tools/csharp-ls"
--
-- lspconfig["csharp_ls"].setup({
-- 	cmd = { csharp_ls_bin },
-- 	AutomaticWorkspaceInit = true,
-- 	root_dir = function(startpath)
-- 		return lspconfig.util.root_pattern("*.sln")(startpath)
-- 			or lspconfig.util.root_pattern("*.csproj")(startpath)
-- 			or lspconfig.util.root_pattern("*.fsproj")(startpath)
-- 			or lspconfig.util.root_pattern(".git")(startpath)
-- 	end,
-- 	on_attach,
-- 	capabilities,
-- })

local omnisharp_bin = "/home/suetham/.local/share/nvim/mason/packages/omnisharp/OmniSharp.dll"

lspconfig["omnisharp"].setup({
	-- on_attach = on_attach,
	-- capabilities = capabilities,
	--
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "dotnet", omnisharp_bin },
	useMono = true,

	-- Enables support for reading code style, naming convention and analyzer
	-- settings from .editorconfig.
	enable_editorconfig_support = true,

	-- If true, MSBuild project system will only load projects for files that
	-- were opened in the editor. This setting is useful for big C# codebases
	-- and allows for faster initialization of code navigation features only
	-- for projects that are relevant to code that is being edited. With this
	-- setting enabled OmniSharp may load fewer projects and may thus display
	-- incomplete reference lists for symbols.
	enable_ms_build_load_projects_on_demand = true,

	-- Enables support for roslyn analyzers, code fixes and rulesets.
	enable_roslyn_analyzers = false,

	-- Specifies whether 'using' directives should be grouped and sorted during
	-- document formatting.
	organize_imports_on_format = true,

	-- Enables support for showing unimported types and unimported extension
	-- methods in completion lists. When committed, the appropriate using
	-- directive will be added at the top of the current file. This option can
	-- have a negative impact on initial completion responsiveness,
	-- particularly for the first few completion sessions after opening a
	-- solution.
	enable_import_completion = true,

	-- Specifies whether to include preview versions of the .NET SDK when
	-- determining which version to use for project loading.
	sdk_include_prereleases = true,

	-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
	-- true
	analyze_open_documents_only = false,
})
