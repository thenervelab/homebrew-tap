class Hipc < Formula
  desc "CLI tool for managing Docker registries and compute resources on Hippius network"
  homepage "https://hippius.com"
  version "0.0.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "6867f2d5f496bb9686e41136233fa7e33f1743784defd8100e4be8d33abc8d26" # ARM Mac
    else
      url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "6786adc2317e38bf0345f99062b559782e9e4fa9a06642a39de13921575c152f" # Intel Mac
    end
  end

  on_linux do
    url "https://github.com/thenervelab/hippius-cli/releases/download/v#{version}/hipc-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "71cae55490f1ef4a90fb71638018251a68a6843e157d6b8c107734e10699146d" # Linux
  end

  def install
    bin.install "hipc"
  end

  test do
    system "#{bin}/hipc", "--version"
  end
end
