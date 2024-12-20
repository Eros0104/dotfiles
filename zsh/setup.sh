#!/bin/bash

# Abort on error
set -e

echo "Setting up zsh..."

echo "Installing dependencies from Brewfile..."
brew bundle --file=Brewfile

echo "Creating symlink for .zshrc..."
ln -sf $(pwd)/.zshrc ~/.zshrc

echo "Reloading terminal..."
source ~/.zshrc

echo "Setup complete!"

