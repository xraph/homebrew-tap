class OctopusCli < Formula
  desc "CLI for Octopus API Gateway"
  homepage "https://octopus.io"
  version "0.3.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.9/octopus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9baf32536da2aa93abb713e7757f83d82b8b5227064cef1faf97e33b96421004"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.9/octopus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1b2d85efe86c01997e3396d988cf2cad4ccd7d2771c654c7841c9231d5d17d22"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.9/octopus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4fe0782450b003c07cfc38c1ed108bec0c1be3a154be34b59e86a2f2a9029577"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.9/octopus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b6c3df943f2dd0a8a058b0d1dcc981466d7f070aa6364d706b4d257928f5215"
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
