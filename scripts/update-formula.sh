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
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-v${VERSION}-x86_64-apple-darwin.tar.gz"
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-v${VERSION}-aarch64-apple-darwin.tar.gz"
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-v${VERSION}-x86_64-unknown-linux-gnu.tar.gz"

echo "Generating checksums..."
DARWIN_INTEL_SHA=$(shasum -a 256 "hipc-v${VERSION}-x86_64-apple-darwin.tar.gz" | cut -d ' ' -f 1)
DARWIN_ARM_SHA=$(shasum -a 256 "hipc-v${VERSION}-aarch64-apple-darwin.tar.gz" | cut -d ' ' -f 1)
LINUX_SHA=$(shasum -a 256 "hipc-v${VERSION}-x86_64-unknown-linux-gnu.tar.gz" | cut -d ' ' -f 1)

cd - > /dev/null
rm -rf "$TEMP_DIR"

FORMULA_FILE="Formula/hipc.rb"

echo "Updating formula..."

# Create a new formula file with updated version and checksums
cat > "$FORMULA_FILE" << 'EOL'
class Hipc < Formula
  desc "CLI tool for managing Docker registries and compute resources on Hippius network"
  homepage "https://hippius.com"
  version "${VERSION}"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "${DARWIN_ARM_SHA}" # ARM Mac
    else
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "${DARWIN_INTEL_SHA}" # Intel Mac
    end
  end

  on_linux do
    url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "${LINUX_SHA}" # Linux
  end

  def install
    bin.install "hipc"
  end

  test do
    system "#{bin}/hipc", "--version"
  end
end
EOL

# Replace variables in the formula
sed -i '' "s/\${VERSION}/${VERSION}/g" "$FORMULA_FILE"
sed -i '' "s/\${DARWIN_ARM_SHA}/${DARWIN_ARM_SHA}/g" "$FORMULA_FILE"
sed -i '' "s/\${DARWIN_INTEL_SHA}/${DARWIN_INTEL_SHA}/g" "$FORMULA_FILE"
sed -i '' "s/\${LINUX_SHA}/${LINUX_SHA}/g" "$FORMULA_FILE"

echo "Testing formula..."
brew install --build-from-source "$FORMULA_FILE"

echo "Done! Please verify the changes and commit them."