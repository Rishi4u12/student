#!/bin/bash

# Setup local directories
mkdir -p ~/.local/gems
mkdir -p ~/.local/bin

# Add to bashrc if not already present
if ! grep -q "GEM_HOME" ~/.bashrc; then
    echo 'export GEM_HOME="$HOME/.local/gems"' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/gems/bin:$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Reload bashrc
source ~/.bashrc

# Install required packages locally
gem install bundler --user-install
bundle config set --local path ~/.local/gems
bundle install

# Create python virtual environment
python3 -m venv ~/.local/venv
source ~/.local/venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
