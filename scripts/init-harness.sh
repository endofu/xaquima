#!/bin/bash
# Xaquima Harness Binder

echo "🔗 Binding Xaquima to Host Project..."
HOST_ROOT=$(pwd)
FRAMEWORK_DIR=".xaquima"

echo "Select CLI harness:"
echo "1) Claude Code"
echo "2) OpenCode"
echo "3) Gemini CLI"
read -p "Select (1-3): " choice

case $choice in
    1) CONFIG="claude.json" ;;
    2) CONFIG="opencode.json" ;;
    3) CONFIG="gemini.json" ;;
    *) echo "Invalid choice."; exit 1 ;;
esac

TARGET="$HOST_ROOT/$CONFIG"
SOURCE="$FRAMEWORK_DIR/configs/$CONFIG"

if [ -L "$TARGET" ]; then
    echo "✅ Already symlinked."
    exit 0
fi

ln -s "$SOURCE" "$CONFIG"
echo "🚀 Success! $CONFIG is now symlinked to Xaquima."
