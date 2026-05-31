# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "1.2.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "92d50348f0f57f2430bbefd4be7f095d421785d066162c068692e5f614acf25c"
    else
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "6f0aa5479657090f2f0461bef70b46e1bdceb2107d44adad7dc8a7b9850177dc"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "4e3e5815b701ae7bd7e93a87475030c6ca50a167dc197657ee6643af96cb5e5a"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
