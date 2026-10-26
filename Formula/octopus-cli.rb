class OctopusCli < Formula
  desc "CLI for Octopus API Gateway"
  homepage "https://octopus.io"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.5.0/octopus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9ca063c276156c7e098acd7d84577d328873a3225425359050e3865a730de6b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.5.0/octopus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5a52664223d132f49b32517ecf0f7581e2b6fac623009b4a6b5bb99172a6e7d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xraph/octopus/releases/download/v0.5.0/octopus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2844c320f9e59f1b8e50e98a2e9157ddae1bcdc47c95726bbe6ee6e0d41dccd5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xraph/octopus/releases/download/v0.5.0/octopus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "551d262baa96c86c24036e3822dc70331a0f5983579ae60a9e2518ccc1cb1be0"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "octopus"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "octopus"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "octopus"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "octopus"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
