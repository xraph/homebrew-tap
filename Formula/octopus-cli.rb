class OctopusCli < Formula
  desc "CLI for Octopus API Gateway"
  homepage "https://octopus.io"
  version "0.3.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.10/octopus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "df431eb2eee558b734462a77742f2f4bd9766a30ff95eea386c69ae2a61a973b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.10/octopus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "cf60e2f8c4b2895eaa299e34efcefa72230ed356d9995efcde0d43ace67e81fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.10/octopus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c663b0111dd99dd154d64c66c650d2a787ea4c00f30ed577d44d2413d9c06023"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.10/octopus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "384eef5a62e377d48f1971eb6e47fa907996bcc17f348a02c851cad3d9fcf536"
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
