# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "1.2.11"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "6b5ca39270e0c02d7b7322aaab6e4bf674c2cd229523ceb48c8df88e80b1753d"
    else
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "e6ce493c16084ee27a2ec9cb68729169d6febd8cd22d32aabc60e75771602c9e"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "8d45e5862603ab2c7aa28c6f4370a5fb5ca6000040bfffeba1915d20c5170f07"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
