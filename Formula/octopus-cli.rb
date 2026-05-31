class OctopusCli < Formula
  desc "CLI for Octopus API Gateway"
  homepage "https://octopus.io"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.3/octopus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "13c3043360b8fa52e8b2811f5d8807ab0afafe4a8a7f3cdf3e2c36a76dc6db64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.3/octopus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2f199e8d6865b622bf96e8cd59584ca8338722bcc1760c4c3a74638b88e5bc37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.3/octopus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c475256c2fcd0fd8cb546097fc6b1e9ee0768f7e31e4fa16c1e8f33dee3527f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.3/octopus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dd7ed4ae25054d82de6788be07e4e85ea9dcb78ff0223a868bc03da6db3c39c6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "octopus" if OS.mac? && Hardware::CPU.arm?
    bin.install "octopus" if OS.mac? && Hardware::CPU.intel?
    bin.install "octopus" if OS.linux? && Hardware::CPU.arm?
    bin.install "octopus" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
