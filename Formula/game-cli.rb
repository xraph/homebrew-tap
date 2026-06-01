# typed: false
# frozen_string_literal: true

class GameCli < Formula
  desc "CLI tool for GameFramework - automate Unity/Unreal exports and integration"
  homepage "https://github.com/xraph/game-cli"
  version "1.2.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-aarch64.tar.gz"
      sha256 "b3018650a7f285237627fa3901ad585cdf7aae5c23db26bc6de2e51d630c18d1"
    else
      url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-macos-x86_64.tar.gz"
      sha256 "4234237557c2a23d9c84e8dcf72373a6b30ae6f97f69e2ec9e2837726f406366"
    end
  end

  on_linux do
    url "https://github.com/xraph/game-cli-dist/releases/download/v#{version}/game-cli-v#{version}-linux-x64.tar.gz"
    sha256 "1d1b1d49844799fb717a5dc33debda2586c60f53045062b98f590af84d56a440"
  end

  def install
    bin.install "game"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/game --version")
  end
end
