# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "0.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "d1aa861282d2315aefeca74bc9ba368bfbb6761153c60d51683567b233ac3f11"
    else
      url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "39e12f1b0369e9b98856728e87b5e863254efa3f699856e504a522ccbb776efc"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "30f1e5dcf524c5cb0bb848427615f7df3afbc69af4cdc4ddd0dfbb9985ffd8d0"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
