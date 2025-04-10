# CLAUDE.md - Configuration Guide

## Commands
- Formatting (Python): Automatically runs Black on save
- Linting (Python): Flake8 for diagnostics
- Neovim package management: `:Lazy` to update/install packages

## Code Style Guidelines
- Indentation: 4 spaces (no tabs)
- Line length: 100 characters maximum
- Quote style: Double quotes preferred
- Python typing: Use type annotations with basedpyright checking
- Error handling: Use descriptive error messages

## Naming Conventions
- Variables/functions: snake_case
- Classes: PascalCase
- Constants: UPPER_SNAKE_CASE
- Private members: Prefix with underscore (_private_var)

## Neovim Configuration
- Leader key: Space
- Buffer navigation: <leader>p (prev), <leader>n (next), <leader>x (close)
- LSP: gd (definition), K (hover), <leader>f (format), <leader>rn (rename)
- File navigation: <leader>ff (find files), <leader>fg (live grep)
- Use lazy.nvim for plugin management
- Modular configuration in lua/plugins/ directory