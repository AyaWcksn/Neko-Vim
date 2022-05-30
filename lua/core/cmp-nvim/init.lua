local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
vim.o.completeopt = "menu,menuone,noselect,noinsert"

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	mapping = {
        ['<S-k>'] = cmp.mapping.scroll_docs(-4),
        ['<S-j>'] = cmp.mapping.scroll_docs(4),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<S-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable,
		["<S-w>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "vsnip" },
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine" },
		{ name = "calc" },
		{ name = "emoji" },
		{ name = "treesitter" },
		{ name = "orgmode" },
		{ name = "crates" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "neorg" },
	},
    view = {
      entries = "native" -- can be "custom", "wildmenu" or "native"
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
    },
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = ({
				Text = " Text",
				Method = " Method",
				Function = " Function",
				Constructor = " Constructor",
				Field = "ﰠ Field",
				Variable = " Variable",
				Class = "ﴯ Class",
				Interface = " Interface",
				Module = " Module",
				Property = "ﰠ Property",
				Unit = "塞Unit",
				Value = " Value",
				Enum = " Enum",
				Keyword = " Keyword",
				Snippet = " Snippets",
				Color = " Color",
				File = " File",
				Reference = " Reference",
				Folder = " Folder",
				EnumMember = " EnumMember",
				Constant = " Constant",
				Struct = "פּ Struct",
				Event = " AI",
				Operator = " Operator",
				TypeParameter = "",
			})[vim_item.kind]
			local source_mapping = {
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				cmp_tabnine = "[TabNine]",
				path = "[Path]",
				emoji = "[Emoji]",
				calc = "[Calc]",
				latex_symbol = "[Latex]",
			}
			local menu = source_mapping[entry.source.name]
			vim_item.menu = menu
            vim_item.abbr = string.sub(vim_item.abbr, 1, 30)
			return vim_item
		end,
	},
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
  end
})

vim.cmd([[
    augroup NvimCmp
    au!
    au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
    augroup END
]])
