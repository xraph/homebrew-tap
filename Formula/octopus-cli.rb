class OctopusCli < Formula
  desc "CLI for Octopus API Gateway"
  homepage "https://octopus.io"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.7/octopus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5ed80d56a5db95bfb106594824ad1d56409ddb4a37a7b26577e19d4828be3350"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.7/octopus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8a6254c200203938ab53d8646bb368b0132af3f53158c2966037c744bcc320dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.3.7/octopus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e55f9ba68d3d13c3da61e92d02d5c49fd0f2f2fe6abae117d59736c95e4e360c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.3.7/octopus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ee94682ce8f71d1f2a5c0e69fa3442fd266b77bada92d2ad0f39dc93ad85ab4"
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
