class OctopusCli < Formula
  desc "CLI for Octopus API Gateway"
  homepage "https://octopus.io"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.4/octopus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4c06d75e2b53628e5844193f4a2b6d4ac27e4351b0b84bbcc9ef582e0d931a5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.4/octopus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a1dfe9b75a7dfc749a4c20ada41e68a13e2629aef75df0fff40e39368299d2f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.4/octopus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18c1216fb6b87576a289e1d26f5222d583cdb71265bc1bc1d03c452964913489"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.4/octopus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e32ae6e9a597473a6cc911b6a96f24cf6169e698f63739e1d41f97b8f2c165c"
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
