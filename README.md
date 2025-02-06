# Hippius CLI Homebrew Tap

This repository contains the Homebrew formula for installing [Hippius CLI](https://github.com/thenervelab/hippius-cli).

## Installation

```bash
# Add the tap
brew tap thenervelab/tap

# Install hipc
brew install hipc

# Upgrade hipc
brew upgrade hipc
```

## Development

### Updating the Formula

1. After a new release of hippius-cli, download the release tarballs:
```bash
VERSION="0.1.0" # Replace with actual version
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-${VERSION}-x86_64-apple-darwin.tar.gz"
curl -LO "https://github.com/thenervelab/hippius-cli/releases/download/v${VERSION}/hipc-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"
```

2. Generate SHA256 checksums:
```bash
shasum -a 256 hipc-*-darwin.tar.gz
shasum -a 256 hipc-*-linux-gnu.tar.gz
```

3. Update the version and SHA256 checksums in `Formula/hipc.rb`

4. Test the formula locally:
```bash
brew install --build-from-source Formula/hipc.rb
```

5. Commit and push changes
