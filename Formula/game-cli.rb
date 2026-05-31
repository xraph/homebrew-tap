# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "1.2.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "0b9889d59323e9b88dbf48c8944c48731677c3d36e72f53a94515bf7fc0f6e23"
    else
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "61e128f11805b53768672b4eaa846e76d83476611499ce06e1e8d3b394239910"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "b3b4aacb6d98caec5ae13fe879b04fd635a35c97c818a1644689068749f85b70"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
