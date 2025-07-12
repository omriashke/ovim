# Ovim

A Neovim configuration code editor that runs inside a Docker container for an isolated development experience.

## Description

Ovim provides a containerized Neovim environment that keeps your development setup isolated from your host system. It allows you to mount local directories as volumes, manage multiple workspaces, and maintain consistent development environments across different machines.

## Features

- **Isolated Environment**: Complete Neovim setup running in Docker
- **Volume Management**: Easy mounting and unmounting of local directories
- **tmux Integration**: Built-in tmux session management
- **Workspace Management**: List and manage multiple development directories
- **Container Lifecycle**: Simple start/stop/rebuild operations

## Requirements

Before installing Ovim, ensure you have the following installed:

- **curl** - For downloading the installation script
- **git** - For cloning the repository
- **docker** - For running the containerized environment

### macOS Docker Setup

For macOS users, you'll need to enable Docker host sharing:

1. Open Docker Desktop
2. Go to **Settings** → **Resources** → **File Sharing**
3. Ensure your development directories are shared with Docker

## Installation

Run the following command to install Ovim:

```bash
curl -sSL https://raw.githubusercontent.com/omriashke/ovim/refs/heads/main/install.sh | bash
```

After installation, restart your terminal or run:

```bash
source ~/.bashrc  # or ~/.zshrc for zsh users
```

### Font Setup (Recommended)

For the best experience, install a Nerd Font in your terminal:

1. **iTerm2** (Recommended for macOS):
   - Download a Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/)
   - Install the font on your system
   - In iTerm2: Preferences → Profiles → Text → Font → Select your Nerd Font

2. **Other Terminals**:
   - Install any Nerd Font and configure it in your terminal's settings

## Configuration

### Environment Variables

Ovim supports custom configuration through a `.env` file in the .ovim directory. This file is sourced during the container build process.

**⚠️ Security Warning**: Be careful with sensitive information in your `.env` file. Do not upload Docker images containing sensitive environment variables to public registries.

Example `.env` file:
```bash
# Development tools
NODE_VERSION=18
PYTHON_VERSION=3.11

# Personal settings
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"

# Api keys
AVANTE_ANTHROPIC_API_KEY=your-claude-api-key
AVANTE_OPENAI_API_KEY=your-openai-api-key
```

## Usage

### Commands

#### `add` - Mount Directory
Mount a local directory to the container workspace:

```bash
ovim add /path/to/your/project
```

#### `remove` - Unmount Directory
Remove a directory from the container workspace:

```bash
ovim remove /path/to/your/project
```

#### `list` - Show Workspaces
List all mounted directories:

```bash
ovim list
```

**Flags:**
- `--path` - Show full workdir paths

```bash
ovim list --path
```

#### `start` - Start Container
Start the Ovim container with tmux:

```bash
ovim start
```

**Flags:**
- `--build` - Rebuild the container before starting

**Arguments:**
- `session_name` - Name of tmux session (creates new or attaches to existing)

```bash
# Start with default session
ovim start

# Start with custom session name
ovim start my-project

# Rebuild container and start
ovim start --build

# Rebuild and use custom session
ovim start --build my-project
```

#### `down` - Stop and Clean
Stop the container and remove all workdirs:

```bash
ovim down
```

### Example Workflow

```bash
# Add your project directory
ovim add ~/my-awesome-project

# Start Ovim with a named session
ovim start awesome-session

# List your workspaces
ovim list --path

# When done, clean up
ovim down
```

## Troubleshooting

### Common Issues

**Command not found**: 
- Ensure you've restarted your terminal or sourced your shell configuration file
- Check that `~/.ovim` is in your PATH

**Docker permission issues**:
- Ensure Docker is running
- On Linux, you may need to add your user to the docker group

**Font rendering issues**:
- Install and configure a Nerd Font in your terminal
- iTerm2 is recommended for the best experience on macOS

**Container won't start**:
- Try rebuilding: `ovim start --build`
- Check Docker logs for error messages

### Getting Help

If you encounter issues:

1. Check that all requirements are installed
2. Ensure Docker is running and properly configured
3. Try rebuilding the container with `ovim start --build`
4. Open an issue on the GitHub repository

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Ovim is licensed under the MIT License.

---

**Note**: This project creates an isolated development environment. Your local files are mounted as volumes and remain on your host system.
