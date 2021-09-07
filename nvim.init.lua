-- aliases
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

cmd 'packadd paq-nvim'               -- load the package manager
-- modules
local saga = require ('lspsaga')
local paq = require('paq-nvim').paq  -- a convenient alias
local nvim_lsp = require('lspconfig')

paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
paq {'nvim-treesitter/nvim-treesitter'}
paq {'neovim/nvim-lspconfig'}
paq {'glepnir/lspsaga.nvim'}
paq {'tpope/vim-commentary'}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}

vim.wo.number = true
vim.wo.relativenumber = true

-- Space as leader
vim.g.mapleader = " "
-- roll keys for ESC
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'kk', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^', { noremap = true })

-- Telescope fuzzy finder config
vim.api.nvim_set_keymap('n', '<c-p>', '<Cmd>Telescope find_files<cr>', { noremap = true })
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
    layout_strategy = "vertical"
  }
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-i>', [[lua vim.lsp.buf.formatting_seq_sync()]], opts)
  buf_set_keymap('n', 'K', [[<Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]], { noremap = true })
  buf_set_keymap('n', 'KK', [[<Cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], { noremap = true })
-- nnoremap <silent> [g :Lspsaga diagnostic_jump_previous<CR>
-- nnoremap <silent> ]g :Lspsaga diagnostic_jump_next<CR>
  buf_set_keymap('n', '[g', [[<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]], { noremap = true })
  buf_set_keymap('n', ']g', [[<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]], { noremap = true })
  buf_set_keymap('n', '"', [[<Cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>]], { noremap = true })

   if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

-- TypeScript
nvim_lsp.tsserver.setup {
  on_attach = on_attach
}

-- setup LSP UI support
saga.init_lsp_saga {
  error_sign = 'X',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

-- eslint and prettier diagnostic
nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'markdown' },
  init_options = {
    linters = {
      eslint = {
        command = 'eslint_d',
        rootPatterns = { 'package.json' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint_d',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
    },
    formatters = {
      eslint_d = {
        command = 'eslint_d',
        args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
        rootPatterns = { '.git' },
      },
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'eslint_d',
      javascriptreact = 'eslint_d',
      json = 'prettier',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'eslint_d',
      typescriptreact = 'eslint_d',
      json = 'prettier',
      markdown = 'prettier',
    }
  }
}

-- configure languages for syntax support
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "json",
    "yaml",
    "html",
    "css"
  },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
