-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
-- lvim.colorscheme = "dracula"

local dap = require('dap')
local dap_utils = pcall(require, "dap.utils")

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

vim.opt.relativenumber = true
vim.opt.wrap = true

-- custom escape keys
lvim.keys.insert_mode["jk"] = "<Esc>"
lvim.keys.insert_mode["kj"] = "<Esc>"

lvim.keys.normal_mode["J"] = "<C-d>"
lvim.keys.normal_mode["k>"] = false
lvim.keys.normal_mode["K"] = "<C-u>"

-- user plugins
lvim.plugins = {
  -- Navigation
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "kshenoy/vim-signature"
  },
  -- {
  --   'unblevable/quick-scope',
  --   event = "BufRead",
  --   config = function()
  --     vim.cmd "highlight QuickScopePrimary guibg='#1A1B26'"
  --     vim.cmd "highlight QuickScopeSecondary guibg='#1A1B26'"
  --   end,
  -- },
  -- {
  --   "andymass/vim-matchup",
  --   event = "CursorMoved",
  --   config = function()
  --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
  --   end,
  -- },
  -- {
  --   "karb94/neoscroll.nvim",
  --   -- event = "WinScrolled",
  --   config = function()
  --   require('neoscroll').setup({
  --     -- All these keys will be mapped to their corresponding default scrolling animation
  --     -- mappings = {
  --     --   -- '<C-u>': {'scroll', {'-vim.wo.scroll', 'true', '200', 'cubic'}},
  --     --   '<C-u>',
  --     --   '<C-d>',
  --     --   '<C-b>',
  --     --   '<C-f>',
  --     --   '<C-y>',
  --     --   '<C-e>',
  --     --   'zt',
  --     --   'zz',
  --     --   'zb'
  --     -- },
  --     hide_cursor = true,          -- Hide cursor while scrolling
  --     stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  --     use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
  --     respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  --     cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  --     easing_function = nil,    -- Default easing function
  --     pre_hook = nil,              -- Function to run before the scrolling animation starts
  --     post_hook = nil,              -- Function to run after the scrolling animation ends
  --   })
  --   end
  -- },
  -- [SECTION] Treesitter
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
  },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {     -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring"
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,             -- Width of the floating window
        height = 25,             -- Height of the floating window
        default_mappings = true, -- Bind default mappings
        debug = false,           -- Print debug information
        opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil     -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end
  },
  {
    "ahmedkhalf/lsp-rooter.nvim",
    event = "BufRead",
    config = function()
      require("lsp-rooter").setup()
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  -- [SECTION] Git
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = false }
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  -- [SECTION] Colorschemes
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true,   -- CSS rgb() and rgba() functions
        hsl_fn = true,   -- CSS hsl() and hsla() functions
        css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  -- [SECTION] Themes
  -- { "Mofiqul/dracula.nvim" },
  { "ray-x/starry.nvim" },
  -- General
  -- Lua
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = .55-- width will be 85% of the editor width
      }
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  { "tpope/vim-repeat" },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  -- {
  --   "zarb94/neoscroll.nvim",
  --   event = "WinScrolled",
  --   config = function()
  --   require('neoscroll').setup({
  --         -- All these keys will be mapped to their corresponding default scrolling anthe window cannot scroll further
  --         easing_function = nil,        -- Default easing function
  --         pre_hook = nil,              -- Function to run before the scrolling animation starts
  --         post_hook = nil,              -- Function to run after the scrolling animation ends
  --         })
  --   end
  -- },
  -- [SECTION] DAP and testing
  "mxsdev/nvim-dap-vscode-js",
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  'nvim-neotest/neotest',
  'nvim-neotest/neotest-jest'
}

-- Neoscroll
-- local neoscroll_mappings = {}
-- -- Syntax: t[keys] = {function, {function arguments}}
-- neoscroll_mappings['<C-u>'] = {'scroll', {'vim.wo.scroll', 'true', '1000', [['sine']]}}
-- neoscroll_mappings['<C-d>'] = {'scroll', { '-vim.wo.scroll', 'true', '1000', [['sine']]}}
-- neoscroll_mappings['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
-- neoscroll_mappings['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450'}}
-- neoscroll_mappings['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
-- neoscroll_mappings['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
-- neoscroll_mappings['zt']    = {'zt', {'250'}}
-- neoscroll_mappings['zz']    = {'zz', {'250'}}
-- neoscroll_mappings['zb']    = {'zb', {'250'}}

-- require('neoscroll.config').set_mappings(neoscroll_mappings)

-- Surround carriage return fix
vim.g["surround_" .. vim.fn.char2nr("\r") ] = "\n\r\n"

-- [SECTION] Copilot
table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration

      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})

-- config debugger for js


-- enable treesitter integration
-- lvim.builtin.treesitter.matchup.enable = true

-- Them
-- lvim.colorscheme = "dracula
--
-- nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
-- nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
-- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
-- nnoremap gpD <cmd>lua require('goto-preview').goto_preview_declaration()<CR>
-- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
-- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>


-- Linting formatting
-- lvim.format_on_save.enabled = true
-- lvim.format_on_save.pattern = { "*.lua", "*.py" }

-- DAP Configuration
lvim.builtin.dap.active = true

-- require("dap-vscode-js").setup({
--   debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
--   debugger_cmd = { "js-debug-adapter" },
--   adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
-- })

require("dap-vscode-js").setup({
  debugger_path = "/home/sigill/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug",
  -- debugger_cmd = { "js-debug-adapter" },
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

local exts = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "vue",
  "svelte",
}

-- dap.configurations = {}

for i, ext in ipairs(exts) do
  dap.configurations[ext] = {
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch Chrome with \"localhost\"",
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node)",
      cwd = vim.fn.getcwd(),
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with ts-node)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "--loader", "ts-node/esm" },
      runtimeExecutable = "node",
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with deno)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
      runtimeExecutable = "deno",
      attachSimplePort = 9229,
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with jest)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
      runtimeExecutable = "node",
      args = { "${file}", "--coverage", "false" },
      rootPath = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with vitest)",
      cwd = vim.fn.getcwd(),
      program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
      args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
      autoAttachChildProcesses = true,
      smartStep = true,
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with deno)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
      runtimeExecutable = "deno",
      attachSimplePort = 9229,
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach Program (pwa-chrome, select port)",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      port = function()
        return vim.fn.input("Select port: ", 9222)
      end,
      webRoot = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach Program (pwa-node, select pid)",
      cwd = vim.fn.getcwd(),
      processId = require 'dap.utils'.pick_process,
      skipFiles = { "<node_internals>/**" },
    },
  }
end

-- Test configuration
require('neotest').setup({
  adapters = {
    require('neotest-jest')({
      jestCommand = "npm test --",
      jestConfigFile = function ()
        return vim.fn.getcwd() .. "*jest.config.{js,ts}"
      end,
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    }),
  }
})

-- Which Key
-- Treesitter
lvim.builtin.which_key.mappings["Ts"] = {
  ":SymbolsOutline<cr>", "Symbols Outline Toggle"
}
-- Window
lvim.builtin.which_key.mappings["t"] = {
  name = "Toggle",
  m = { ":MinimapToggle<cr>", "Minimap" }
}

-- LSP
lvim.builtin.which_key.mappings["lR"] = {}
lvim.builtin.which_key.mappings["lR"] = {
  "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"
}

-- lvim.builtin.which_key.mappings["lr"] = {}
lvim.builtin.which_key.mappings["lr"] = {
  "<cmd>lua require('goto-preview').goto_preview_references()<CR>", "Preview references"
}

lvim.builtin.which_key.mappings["lD"] = {}
lvim.builtin.which_key.mappings["lD"] = {
  "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer diagnostics"
}

lvim.builtin.which_key.mappings["ld"] = {}
lvim.builtin.which_key.mappings["ld"] = {
  "<cmd>lua require('goto-preview').goto_preview_references()<CR>", "Preview references"
}
-- Debug
lvim.builtin.which_key.mappings["db"] = {}
lvim.builtin.which_key.mappings["db"] = {
  "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle Breakpoint"
}

lvim.builtin.which_key.mappings["dB"] = {}
lvim.builtin.which_key.mappings["dB"] = {
  "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional Breakpoint"
}
-- Test
lvim.builtin.which_key.mappings["dm"] = {
  "<cmd>lua require('neotest').run.run()<cr>", "Test Method"
}

lvim.builtin.which_key.mappings["dM"] = {
  "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP"
}

lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class"
}

lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP"
}

lvim.builtin.which_key.mappings["dS"] = {
  "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary"
}

lvim.builtin.which_key.mappings["z"] = {
  "<cmd>ZenMode<cr>", "Zen Mode"
}

-- Toggle
lvim.builtin.which_key.mappings["tt"] = { "<cmd>ToggleTerm direction=horizontal<cr>", "Toggle Horizontal Terminal" }
lvim.builtin.which_key.mappings["tv"] = { "<cmd>ToggleTerm direction=vertical size=55<cr>", "Toggle Vertical Terminal" }
