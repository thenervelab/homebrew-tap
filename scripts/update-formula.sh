#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 0.1.0"
    exit 1
fi

VERSION=$1
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Downloading release tarballs..."
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-${VERSION}-x86_64-apple-darwin.tar.gz"
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"

echo "Generating checksums..."
DARWIN_SHA=$(shasum -a 256 "hipc-${VERSION}-x86_64-apple-darwin.tar.gz" | cut -d ' ' -f 1)
LINUX_SHA=$(shasum -a 256 "hipc-${VERSION}-x86_64-unknown-linux-gnu.tar.gz" | cut -d ' ' -f 1)

cd - > /dev/null
rm -rf "$TEMP_DIR"

FORMULA_FILE="Formula/hipc.rb"

echo "Updating formula..."
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA_FILE"
sed -i '' "s/sha256 \".*\" # macOS/sha256 \"${DARWIN_SHA}\" # macOS/" "$FORMULA_FILE"
sed -i '' "s/sha256 \".*\" # Linux/sha256 \"${LINUX_SHA}\" # Linux/" "$FORMULA_FILE"

echo "Testing formula..."
brew install --build-from-source "$FORMULA_FILE"

echo "Done! Please verify the changes and commit them."
