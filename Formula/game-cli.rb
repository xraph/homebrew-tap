# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework (Demo - cloud features disabled)"
  homepage "https://github.com/xraph/game-cli"
  version "0.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64-demo.tar.gz"
      sha256 "db1512543b446d9dc806ff86b1fbb4c13b0a82065fbb50ba5e652585c25c8a44"
    else
      url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64-demo.tar.gz"
      sha256 "612eeebeb8bb97dd8d1d3000ea3517c2c9eaa70ebb57a8dcb6867a6312f5514c"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-linux-x64-demo.tar.gz"
    sha256 "643818b533c301c40a2678bfbca525be6e5a51df089973ddf43147bf79b2bf80"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
