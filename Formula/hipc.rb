class Hipc < Formula
  desc "CLI tool for managing Docker registries and compute resources on Hippius network"
  homepage "https://hippius.com"
  version "0.0.7"
  license "MIT"

  # hipc was the IPFS-era CLI. The Hippius console CLI is now `hip`, installed by the
  # hippius-cli formula from the thenervelab/hip releases.
  deprecate! date: "2026-11-01", because: "hipc is replaced by hip: run `brew install thenervelab/tap/hippius-cli`"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "ca0ad0aad2b07e05c037fcd503d25f4429455d1f143c2c2988f82c46f75f69f6" # ARM Mac
    else
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "1e360acd9681a77d8911cf4273de062a459eb3f34898934f1b3e59b038cc8ef1" # Intel Mac
    end
  end

  on_linux do
    url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "02628043b55cc610af11ff9d0c59c0449a0013fc3cf9cad75ee661bfeb72ccdd" # Linux
  end

  def install
    bin.install "hipc"
  end

  test do
    system "#{bin}/hipc", "--version"
  end
end
