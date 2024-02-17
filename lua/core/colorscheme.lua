local status, _ = pcall(require, "catppuccin")
-- local status, _ = pcall(vim.cmd, "colorscheme moonfly")
-- local status, _ = pcall(vim.cmd, "colorscheme gruvbox")

if not status then
	print("Colorscheme not found!")
	return
end

vim.cmd("colorscheme catppuccin-mocha")
