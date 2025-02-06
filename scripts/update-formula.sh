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
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-${VERSION}-aarch64-apple-darwin.tar.gz"
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"

echo "Generating checksums..."
DARWIN_INTEL_SHA=$(shasum -a 256 "hipc-${VERSION}-x86_64-apple-darwin.tar.gz" | cut -d ' ' -f 1)
DARWIN_ARM_SHA=$(shasum -a 256 "hipc-${VERSION}-aarch64-apple-darwin.tar.gz" | cut -d ' ' -f 1)
LINUX_SHA=$(shasum -a 256 "hipc-${VERSION}-x86_64-unknown-linux-gnu.tar.gz" | cut -d ' ' -f 1)

cd - > /dev/null
rm -rf "$TEMP_DIR"

FORMULA_FILE="Formula/hipc.rb"

echo "Updating formula..."
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA_FILE"

# Update Intel Mac SHA
sed -i '' "/Hardware::CPU.arm?/,/else/!{/REPLACE_WITH_ACTUAL_SHA.*$/{s/REPLACE_WITH_ACTUAL_SHA.*$/"${DARWIN_INTEL_SHA}" # Intel Mac/};}" "$FORMULA_FILE"

# Update ARM Mac SHA
sed -i '' "/Hardware::CPU.arm?/,/else/{/REPLACE_WITH_ACTUAL_SHA.*$/{s/REPLACE_WITH_ACTUAL_SHA.*$/"${DARWIN_ARM_SHA}" # ARM Mac/};}" "$FORMULA_FILE"

# Update Linux SHA
sed -i '' "/on_linux/,/end/{/REPLACE_WITH_ACTUAL_SHA.*$/{s/REPLACE_WITH_ACTUAL_SHA.*$/"${LINUX_SHA}" # Linux/};}" "$FORMULA_FILE"

echo "Testing formula..."
brew install --build-from-source "$FORMULA_FILE"

echo "Done! Please verify the changes and commit them."
