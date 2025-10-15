# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a highly customized Neovim configuration built with modern Lua-based plugin management. The configuration uses **Lazy.nvim** for plugin management with strategic lazy loading for optimal performance.

### Directory Structure

```
lua/
├── config/           # Core configuration (remap, options, auto-commands, etc.)
├── keymaps/          # Modular keymaps for complex plugins (buffers, nvim-tree)
├── modules/          # Custom utility modules and helpers
└── plugins/          # Plugin configurations organized by category
    ├── git/          # Git workflow plugins (neogit, diffview)
    └── lsp/          # LSP ecosystem (lspconfig, mason, completion)
```

### Plugin Management Pattern

Each plugin file in `lua/plugins/` returns a Lazy.nvim spec table:

```lua
return {
    "plugin/name",
    event = "BufReadPre",          -- Strategic lazy loading
    dependencies = { ... },         -- Plugin dependencies
    config = function() ... end,    -- Configuration function
}
```

### Key Components

- **LSP Stack**: Mason + lspconfig + nvim-cmp for language server management
- **Navigation**: Telescope (highly customized) + nvim-tree + Flash for movement
- **Git Integration**: Neogit + Diffview with custom branch selector
- **Theme**: Catppuccin with extensive LSP semantic token customization
- **Custom Modules**: Located in `lua/modules/` - utilities for git workflows, file operations, and UI components

## Development Commands

### Plugin Management

- **Install plugins**: `:Lazy install`
- **Update plugins**: `:Lazy update`
- **Plugin status**: `:Lazy`

### Configuration Testing

- **Reload config**: `:source %` (when editing Lua files)
- **Check health**: `:checkhealth`
- **LSP info**: `<leader>si` or `:LspInfo`

### Dependencies

The configuration requires:

- **Quicktype**: `npm install -g quicktype` (for JSON-to-code conversion)
- **Git**: For version control operations and plugin management
- **Node.js**: For LSP servers and formatting tools managed by Mason

## Custom Features

### Git Workflow

- Custom git branch selector: `<leader>gb`
- File history with Diffview: `<leader>gh`
- Git status with Neogit: `<leader>gs`

### File Operations

- Smart file picker: `<C-p>` (opens multiple files with Telescope)
- File moving utility: `<leader>mv` (moves files with Telescope)
- Project directory explorer: `<leader>e` (nvim-tree)

### Development Tools

- Format code: `<leader>I` (conform.nvim with smart Prettier detection)
- Run linter: `<leader>l` (nvim-lint)
- Code actions: `<leader>ca` (LSP-based)
- Diagnostics: `<leader>D` (custom Telescope picker with clipboard integration)

### Custom Modules Location

- **Git utilities**: `lua/modules/git-branch-selector.lua`, `lua/modules/git_help.lua`
- **File operations**: `lua/modules/move_files.lua`, `lua/modules/pick_files.lua`
- **UI components**: `lua/modules/floatter/`, `lua/modules/loader.lua`
- **Quicktype integration**: `lua/modules/quicktype.lua`

## Configuration Files

### Entry Point

- **init.lua**: Main entry point, loads all configuration modules
- **lua/config/lazy.lua**: Lazy.nvim bootstrap and plugin imports

### Key Configuration Files

- **lua/config/options.lua**: Neovim options and some terminal/editing keymaps
- **lua/config/remap.lua**: Core keymaps and leader key configuration
- **lua/config/auto-commands.lua**: Autocommands for various behaviors
- **lua/config/user-commands.lua**: Custom user commands

### Theme Customization

The Catppuccin theme is heavily customized in `lua/plugins/catpuccin.lua` with extensive LSP semantic token highlighting and color overrides.

## Performance Considerations

This configuration is optimized for performance through:

- **Aggressive lazy loading**: Most plugins load on specific events
- **Modular architecture**: Plugin configurations are split into focused files
- **Custom utilities**: Optimized custom modules instead of heavy plugins where possible
- **Smart detection**: Context-aware configuration (e.g., Prettier config detection)

## Key Mappings Reference

- **Leader key**: `<Space>`
- **Local leader**: `\`
- **Save file**: `<leader>s`
- **File finder**: `<C-p>`
- **Command palette**: `<leader>P`
- **Toggle terminal**: `<leader>t`
- **LSP rename**: `<leader>rn`
- **Git status**: `<leader>gs`

For a complete keymap reference, see the existing `readme.md` file in the repository.

