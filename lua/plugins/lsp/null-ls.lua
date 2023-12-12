local setup, null_ls = pcall(require, "null-ls")

if not setup then
	print("null_ls not initialized")
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- formatting.prettier,
		formatting.stylua,
		formatting.gofmt,
		diagnostics.eslint_d,
		diagnostics.staticcheck,
		-- diagnostics.revive,
		formatting.eslint_d,
		formatting.yamlfmt,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.formatting.rustfmt,
		formatting.clang_format,
		null_ls.builtins.formatting.autopep8,
		null_ls.builtins.formatting.csharpier,
		null_ls.builtins.formatting.google_java_format,
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
						timeout_ms = 7000,
					})
				end,
			})
		end
	end,
})
