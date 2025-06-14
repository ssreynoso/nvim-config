# Custom Keymaps

This repository contains my Neovim configuration. Below is a reference of the custom key mappings defined across the configuration files.

## Dependencies

- Quicktype, install with `npm install -g quicktype`

## Table of Contents

- [Leader keys](#leader-keys)
- [General keymaps (`lua/config/remap.lua`)](#general-keymaps-luaconfigremaplua)
- [Buffer management (`lua/keymaps/buffers.lua`)](#buffer-management-luakeymapsbufferslua)
- [NvimTree (`lua/keymaps/nvim-tree.lua`)](#nvimtree-luakeymapsnvim-treelua)
- [Todo Comments (`lua/plugins/todo-comment.lua`)](#todo-comments-luapluginstodo-commentlua)
- [Linting (`lua/plugins/linting.lua`)](#linting-luapluginslintinglua)
- [Formatting (`lua/plugins/formatting.lua`)](#formatting-luapluginsformattinglua)
- [Colorizer (`lua/plugins/nvim-colorizer.lua`)](#colorizer-luapluginsnvim-colorizerlua)
- [Floating terminal & notepad (`lua/modules/floatter.lua`)](#floating-terminal--notepad-luamodulesfloatterlua)
- [Terminal (`lua/config/options.lua`)](#terminal-luaconfigoptionslua)
- [Telescope (`lua/plugins/telescope.lua`)](#telescope-luapluginstelescopelua)
- [Commenting (`lua/plugins/comment.lua`)](#commenting-luapluginscommentlua)
- [Trouble (`lua/plugins/trouble.lua`)](#trouble-luapluginstroublelua)
- [Zen Mode (`lua/plugins/zenmode.lua`)](#zen-mode-luapluginszenmodelua)
- [Session (`lua/plugins/session.lua`)](#session-luapluginssessionlua)
- [Git (`lua/plugins/git/neogit.lua`)](#git-luapluginsgitneogitlua)
- [LSP (`lua/plugins/lsp/lspconfig.lua`)](#lsp-luapluginslsplspconfiglua)
- [User commands (`lua/config/user-commands.lua`)](#user-commands-luaconfiguser-commandslua)
- [Treesitter incremental selection (`lua/plugins/tree-sitter.lua`)](#treesitter-incremental-selection-luapluginstree-sitterlua)
- [Completion (`lua/plugins/nvim-cmp.lua`)](#completion-luapluginsnvim-cmplua)
- [Flash (`lua/plugins/flash.lua`)](#flash-luapluginsflashlua)
- [Visual Multi (`lua/plugins/vim-visual-multi.lua`)](#visual-multi-luapluginsvim-visual-multilua)

## Leader keys

- `mapleader` is set to **Space**
- `maplocalleader` is set to **\\**

## General keymaps (`lua/config/remap.lua`)

| Key         | Mode          | Action                                       |
| ----------- | ------------- | -------------------------------------------- |
| `<leader>s` | normal        | Save file                                    |
| `x`         | normal/visual | Delete without affecting registers           |
| `X`         | normal/visual | Delete selection without affecting registers |
| `<leader>a` | normal        | Select all text                              |
| `<A-j>`     | normal        | Move current line down                       |
| `<A-j>`     | visual        | Move selection down                          |
| `<A-k>`     | normal        | Move current line up                         |
| `<A-k>`     | visual        | Move selection up                            |
| `<C-d>`     | normal        | Scroll down and center                      |
| `<C-u>`     | normal        | Scroll up and center                        |
| `n`         | normal        | Search current word forward and center      |
| `N`         | normal        | Search current word backward and center     |
| `<leader>mv` | normal | Move files with Telescope |
| `<C-p>` | normal | Pick and open multiple files |
| `<leader>qq` | normal | Save all and quit |

## Buffer management (`lua/keymaps/buffers.lua`)

| Key               | Mode   | Action                                       |
| ----------------- | ------ | -------------------------------------------- |
| `<Tab>`           | normal | Next buffer                                  |
| `<S-Tab>`         | normal | Previous buffer                              |
| `<leader>w`       | normal | Smart close buffer (saves if modified)       |
| `<leader>W`       | normal | Close all buffers (except terminal/NvimTree) |
| `<leader>T`       | normal | Reopen last closed buffer                    |
| `<leader><Right>` | normal | Move buffer right                            |
| `<leader><Left>`  | normal | Move buffer left                             |

## NvimTree (`lua/keymaps/nvim-tree.lua`)

| Key          | Mode   | Action                    |
| ------------ | ------ | ------------------------- |
| `<leader>e`  | normal | Toggle/focus NvimTree     |
| `<leader>E`  | normal | Close NvimTree and return |
| `<leader>pd` | normal | Open NvimTree fullscreen  |
| `<Tab>` | normal | Open item under cursor |

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

## Colorizer (`lua/plugins/nvim-colorizer.lua`)

| Key          | Mode   | Action           |
| ------------ | ------ | ---------------- |
| `<leader>tc` | normal | Toggle Colorizer |

## Floating terminal & notepad (`lua/modules/floatter.lua`)

| Key         | Mode   | Action          |
| ----------- | ------ | --------------- |
| `<leader>t` | normal | Toggle terminal |
| `<leader>n` | normal | Toggle notepad  |

## Terminal (`lua/config/options.lua`)

| Key          | Mode     | Action              |
| ------------ | -------- | ------------------- |
| `<leader>tn` | normal   | Open new terminal   |
| `<Esc><Esc>` | terminal | Exit to normal mode |
| `<C-b>`      | insert   | Delete previous word |
| `p`          | visual   | Paste after without overwriting |
| `P`          | visual   | Paste before without overwriting |
| `<leader>d`  | normal   | Duplicate line |

## Telescope (`lua/plugins/telescope.lua`)

| Key                     | Mode   | Action |
| ----------------------- | ------ | ------ |
| `<C-p>`                 | normal | Find files |
| `<leader>p`             | normal | Find git tracked files |
| `<leader>pf`            | normal | Live grep |
| `<leader>ph`            | normal | Search help tags |
| `<leader>pt`            | normal | Find TODOs |
| `<leader>pb`            | normal | Search open buffers |
| `<leader>pe`            | normal | Search `.env*` files |
| `<leader>pq`            | normal | Paste JSON as code with quicktype |
| `<leader>gb`            | normal | Git branches |
| `<leader>P`             | normal | Command palette |
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

## Session (`lua/plugins/session.lua`)

| Key | Mode | Action |
| --- | ---- | ------ |
| `<leader>qs` | normal | Select session |
| `<leader>ql` | normal | Load last session |
| `<leader>qd` | normal | Stop session saving |

## Git (`lua/plugins/git/neogit.lua`)

| Key | Mode | Action |
| --- | ---- | ------ |
| `<leader>gs` | normal | Open Neogit |
| `<leader>gh` | normal | File history in Diffview |
| `<C-x>` | normal (Diffview) | Close Diffview |
| `<C-e>` | normal (Diffview) | Toggle file panel |

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
| `[d`         | normal        | Previous diagnostic   |
| `]d`         | normal        | Next diagnostic       |
| `K`          | normal        | Hover documentation   |
| `<leader>rs` | normal        | Restart LSP           |
| `<leader>si` | normal        | LSP information       |

## User commands (`lua/config/user-commands.lua`)

| Key/Command | Mode    | Action |
| ----------- | ------- | ------ |
| `<leader>cd` | normal  | Copy document diagnostics |
| `<leader>ar` | normal  | Insert arrow function and enter insert mode |
| `<leader>fh` | normal  | Floating help prompt |
| `:GitHelp`   | command | Show Git keymap help |
| `:FloatHelp <topic>`   | command | Open help topic in floating window |
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

## Flash (`lua/plugins/flash.lua`)

| Key      | Mode            | Action             |
| -------- | --------------- | ------------------ |
| `m`      | normal/visual/o | Flash              |
| `M`      | normal/visual/o | Flash Treesitter   |
| `r`      | operator        | Remote Flash       |
| `R`      | operator/visual | Treesitter Search  |
| `<C-s>`  | command         | Toggle Flash Search |

## Visual Multi (`lua/plugins/vim-visual-multi.lua`)

| Key     | Action            |
| ------- | ----------------- |
| `<C-j>` | Add cursor down   |
| `<C-k>` | Add cursor up     |
