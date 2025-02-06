class Hipc < Formula
  desc "CLI tool for managing Docker registries and compute resources on Hippius network"
  homepage "https://hippius.com"
  version "0.0.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "REPLACE_WITH_ACTUAL_SHA" # This will be replaced with actual SHA after first release
    else
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "REPLACE_WITH_ACTUAL_SHA" # This will be replaced with actual SHA after first release
    end
  end

  on_linux do
    url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "REPLACE_WITH_ACTUAL_SHA" # This will be replaced with actual SHA after first release
  end

  def install
    bin.install "hipc"
  end

  test do
    system "#{bin}/hipc", "--version"
  end
end
