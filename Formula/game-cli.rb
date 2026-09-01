# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "1.2.15"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "d3196e6a21271429d40990ebeb00b49315aed7bc0731cde3be2007daf0479019"
    else
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "4757dedc04c0c00f83989179e6a40174d28fe927f79bab26c7865c1b13ef5b15"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "84fb9836fb4959dcbf149a14a0dd1c8fb111085d154526608a258d8511fb2a54"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
