#!/usr/bin/env bash

install_dependencies() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Detected macOS system"
        
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        echo "Installing dependencies via Homebrew..."
        brew install cmake gettext lua libtool automake pkg-config
        
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Detected Linux system"
        
        if command -v apt-get &> /dev/null; then
            echo "Installing dependencies via apt..."
            sudo apt-get update
            sudo apt-get install -y cmake gettext lua5.1 liblua5.1-0-dev
        elif command -v dnf &> /dev/null; then
            echo "Installing dependencies via dnf..."
            sudo dnf install -y cmake gettext lua lua-devel
        elif command -v yum &> /dev/null; then
            echo "Installing dependencies via yum..."
            sudo yum install -y cmake gettext lua lua-devel
        elif command -v pacman &> /dev/null; then
            echo "Installing dependencies via pacman..."
            sudo pacman -S --needed cmake gettext lua
        else
            echo "Unsupported Linux distribution. Please install dependencies manually:"
            echo "  - cmake"
            echo "  - gettext"
            echo "  - lua (and development libraries)"
            exit 1
        fi
    else
        echo "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

install_rose_pine_theme() {
    echo "=== Installing Rose Pine Theme ==="
    
    # Create tmux plugin directory if it doesn't exist
    mkdir -p ~/.tmux/plugins
    
    # Install tpm (Tmux Plugin Manager) if not already installed
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        echo "Installing tmux plugin manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    
    echo "Rose Pine theme setup complete!"
    echo "Please restart tmux with 'tmux source ~/.tmux.conf' and press prefix + I to install tmux plugins"
    echo "Open Neovim for the Rose Pine theme to be installed automatically via lazy.nvim"
}

main() {
    echo "=== Neovim Installation Script ==="
    echo "This script will install Neovim v0.10.1 from source"
    
    install_dependencies
    
    mkdir -p $HOME/personal
    
    if [ -d "$HOME/personal/neovim" ]; then
        echo "Neovim directory already exists. Removing it for a fresh installation..."
        rm -rf "$HOME/personal/neovim"
    fi
    
    echo "Cloning Neovim repository..."
    git clone -b v0.10.1 https://github.com/neovim/neovim.git $HOME/personal/neovim
    
    cd $HOME/personal/neovim
    
    echo "Building Neovim (this may take a while)..."
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    
    echo "Installing Neovim..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # On macOS, we might not need sudo if using Homebrew's path
        make install
    else
        # On Linux, we typically need sudo
        sudo make install
    fi
    
    echo "Checking Neovim installation..."
    if command -v nvim &> /dev/null; then
        echo "Neovim installation successful!"
        nvim --version | head -n 1
    else
        echo "Neovim installation may have failed. Please check the output for errors."
        exit 1
    fi
    
    # Install Rose Pine theme
    install_rose_pine_theme
}

# Run the main function
main
