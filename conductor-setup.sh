#!/bin/bash
set -e  # Exit on any error

echo "🚀 Setting up Rails workspace..."

# Load mise if available
if command -v mise &> /dev/null; then
    eval "$(mise activate bash)"
fi

# Check for required tools
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby is not installed. Please install Ruby first."
    exit 1
fi

# Check Ruby version
RUBY_VERSION=$(ruby -v | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
REQUIRED_VERSION="3.2.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "❌ Ruby version $RUBY_VERSION is too old. Rails 8.0.3 requires Ruby >= $REQUIRED_VERSION"
    echo "   Please update Ruby using a version manager like rbenv, rvm, or asdf."
    exit 1
fi

if ! command -v bundle &> /dev/null; then
    echo "❌ Bundler is not installed. Please install Bundler first."
    exit 1
fi

# Copy environment files from root if they exist
if [ -f "$CONDUCTOR_ROOT_PATH/.env" ]; then
    echo "📋 Copying .env file from root..."
    cp "$CONDUCTOR_ROOT_PATH/.env" .env
fi

if [ -f "$CONDUCTOR_ROOT_PATH/.env.local" ]; then
    echo "📋 Copying .env.local file from root..."
    cp "$CONDUCTOR_ROOT_PATH/.env.local" .env.local
fi

# Install Ruby dependencies
echo "📦 Installing Ruby gems..."
bundle install

# Clear logs and temp files
echo "🧹 Cleaning logs and temp files..."
bin/rails log:clear tmp:clear

echo "✅ Setup complete! Click the Run button to start the Rails server."