# Gemini Project: dot-files

## Description

This repository contains personal dotfiles and configurations for various tools and shells. It's designed to be easily cloned and linked on a new system.

## Relevant Files

- `README.md`: The main README file for the project.
- `setup/clone_and_link.sh`: A key script for setting up the dotfiles by cloning dependent repositories and creating symbolic links.
- `local/bin/link_dot_files_local.sh`: Script to link the dotfiles to the home directory.
- `files/.vimrc`: Vim configuration file.
- `files/.bashrc`: Bash shell configuration.
- `files/.config/tmux/tmux.conf`: Tmux configuration file.
- `local/bin/genai-cli`: CLI tool for managing and rendering GenAI prompts.
- `prompts/`: Directory containing prompt templates (.j2) and definitions (.yml).

## Commands

- **link**: 
  - **Command**: `local/bin/link_dot_files_local.sh`
  - **Description**: Creates symbolic links for the dotfiles in the home directory.
- **setup**:
  - **Command**: `sh setup/clone_and_link.sh`
  - **Description**: Runs the main setup script to clone submodules and link files.

### GenAI CLI

- **genai-cli**:
  - **Command**: `local/bin/genai-cli`
  - **Description**: Manage and render AI prompts.
  - **Subcommands**:
    - `list`: List available prompts (use `--detail` for parameters).
    - `render <key>`: Render a specific prompt (use `--interactive` for input).
    - `repl`: Start interactive shell.
    - `export`: Export prompts to CSV.

