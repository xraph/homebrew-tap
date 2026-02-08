# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "PLACEHOLDER_MACOS_ARM_SHA256"
    else
      url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "PLACEHOLDER_MACOS_X86_SHA256"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "PLACEHOLDER_LINUX_SHA256"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match "game-cli #{version}", shell_output("#{bin}/game --version")
  end
end
