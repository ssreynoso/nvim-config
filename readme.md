# Custom Keymaps

This repository contains my Neovim configuration. Below is a reference of the custom key mappings defined across the configuration files.

## Table of Contents

- [Leader keys](#leader-keys)
- [General keymaps (`lua/config/remap.lua`)](#general-keymaps-luaconfigremaplua)
- [Buffer management (`lua/keymaps/buffers.lua`)](#buffer-management-luakeymapsbufferslua)
- [NvimTree (`lua/keymaps/nvim-tree.lua`)](#nvimtree-luakeymapsnvim-treelua)
- [Todo Comments (`lua/plugins/todo-comment.lua`)](#todo-comments-luapluginstodo-commentlua)
- [Linting (`lua/plugins/linting.lua`)](#linting-luapluginslintinglua)
- [Formatting (`lua/plugins/formatting.lua`)](#formatting-luapluginsformattinglua)
- [Telescope (`lua/plugins/telescope.lua`)](#telescope-luapluginstelescopelua)
- [Commenting (`lua/plugins/comment.lua`)](#commenting-luapluginscommentlua)
- [Trouble (`lua/plugins/trouble.lua`)](#trouble-luapluginstroublelua)
- [Zen Mode (`lua/plugins/zenmode.lua`)](#zen-mode-luapluginszenmodelua)
- [LSP (`lua/plugins/lsp/lspconfig.lua`)](#lsp-luapluginslsplspconfiglua)
- [Treesitter incremental selection (`lua/plugins/tree-sitter.lua`)](#treesitter-incremental-selection-luapluginstree-sitterlua)
- [Completion (`lua/plugins/nvim-cmp.lua`)](#completion-luapluginsnvim-cmplua)

## Leader keys

- `mapleader` is set to **Space**
- `maplocalleader` is set to **\\**

## General keymaps (`lua/config/remap.lua`)

| Key         | Mode          | Action                                       |
| ----------- | ------------- | -------------------------------------------- |
| `<leader>w` | normal        | Save file                                    |
| `<leader>s` | normal        | Save file                                    |
| `x`         | normal/visual | Delete without affecting registers           |
| `X`         | normal/visual | Delete selection without affecting registers |
| `<leader>a` | normal        | Select all text                              |
| `<A-j>`     | normal        | Move current line down                       |
| `<A-j>`     | visual        | Move selection down                          |
| `<A-k>`     | normal        | Move current line up                         |
| `<A-k>`     | visual        | Move selection up                            |

## Buffer management (`lua/keymaps/buffers.lua`)

| Key               | Mode   | Action                                 |
| ----------------- | ------ | -------------------------------------- |
| `<Tab>`           | normal | Next buffer                            |
| `<S-Tab>`         | normal | Previous buffer                        |
| `<leader>w`       | normal | Smart close buffer (saves if modified) |
| `<leader><Right>` | normal | Move buffer right                      |
| `<leader><Left>`  | normal | Move buffer left                       |

## NvimTree (`lua/keymaps/nvim-tree.lua`)

| Key          | Mode   | Action                    |
| ------------ | ------ | ------------------------- |
| `<leader>e`  | normal | Toggle/focus NvimTree     |
| `<leader>E`  | normal | Close NvimTree and return |
| `<leader>pd` | normal | Open NvimTree fullscreen  |

## Todo Comments (`lua/plugins/todo-comment.lua`)

| Key  | Mode   | Action                        |
| ---- | ------ | ----------------------------- |
| `]t` | normal | Jump to next TODO comment     |
| `[t` | normal | Jump to previous TODO comment |

## Linting (`lua/plugins/linting.lua`)

| Key         | Mode   | Action                      |
| ----------- | ------ | --------------------------- |
| `<leader>l` | normal | Run linter for current file |

## Formatting (`lua/plugins/formatting.lua`)

| Key         | Mode          | Action                        |
| ----------- | ------------- | ----------------------------- |
| `<leader>I` | normal/visual | Format file or selected range |

## Telescope (`lua/plugins/telescope.lua`)

| Key                     | Mode   | Action                                                                            |
| ----------------------- | ------ | --------------------------------------------------------------------------------- |
| `<C-p>`                 | normal | Find files                                                                        |
| `<leader>pf`            | normal | Find git tracked files                                                            |
| `<leader>pF`            | normal | Live grep                                                                         |
| `<leader>ph`            | normal | Search help tags                                                                  |
| `<leader>pt`            | normal | Find TODOs                                                                        |
| Within Telescope prompt | insert | `<C-j>` next, `<C-k>` previous, `<C-q>` send to quickfix, `<C-t>` open in Trouble |

## Commenting (`lua/plugins/comment.lua`)

| Key         | Mode   | Action                      |
| ----------- | ------ | --------------------------- |
| `<leader>q` | normal | Toggle comment on line      |
| `<C-q>`     | normal | Toggle comment on line      |
| `<C-q>`     | visual | Toggle comment on selection |
| `<leader>q` | visual | Toggle comment on selection |

## Trouble (`lua/plugins/trouble.lua`)

| Key          | Mode   | Action                |
| ------------ | ------ | --------------------- |
| `<leader>xx` | normal | Toggle Trouble list   |
| `<leader>xw` | normal | Workspace diagnostics |
| `<leader>xd` | normal | Document diagnostics  |
| `<leader>xq` | normal | Quickfix list         |
| `<leader>xl` | normal | Location list         |
| `<leader>xt` | normal | TODOs in Trouble      |

## Zen Mode (`lua/plugins/zenmode.lua`)

| Key          | Mode   | Action          |
| ------------ | ------ | --------------- |
| `<leader>zz` | normal | Toggle Zen Mode |

## LSP (`lua/plugins/lsp/lspconfig.lua`)

These mappings are available when an LSP client attaches:

| Key          | Mode          | Action                |
| ------------ | ------------- | --------------------- |
| `gR`         | normal        | Show references       |
| `gD`         | normal        | Go to declaration     |
| `gd`         | normal        | Go to definition      |
| `gi`         | normal        | Go to implementation  |
| `gt`         | normal        | Go to type definition |
| `<leader>ca` | normal/visual | Code actions          |
| `<leader>rn` | normal        | Rename symbol         |
| `<leader>D`  | normal        | Buffer diagnostics    |
| `<leader>d`  | normal        | Line diagnostics      |
| `[d`         | normal        | Previous diagnostic   |
| `]d`         | normal        | Next diagnostic       |
| `K`          | normal        | Hover documentation   |
| `<leader>rs` | normal        | Restart LSP           |
| `<leader>si` | normal        | LSP information       |

## Treesitter incremental selection (`lua/plugins/tree-sitter.lua`)

| Key   | Mode   | Action                  |
| ----- | ------ | ----------------------- |
| `gnn` | normal | Start selection         |
| `grn` | normal | Expand to next node     |
| `grm` | normal | Shrink to previous node |

## Completion (`lua/plugins/nvim-cmp.lua`)

These mappings are active while completing in insert mode:

| Key         | Action              |
| ----------- | ------------------- |
| `<C-k>`     | Previous suggestion |
| `<C-j>`     | Next suggestion     |
| `<C-b>`     | Scroll docs up      |
| `<C-f>`     | Scroll docs down    |
| `<C-Space>` | Trigger completion  |
| `<C-e>`     | Abort completion    |
| `<CR>`      | Confirm selection   |
