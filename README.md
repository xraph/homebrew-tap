# Xraph Homebrew Tap

Official Homebrew tap for Xraph CLI tools.

## Installation

Add the tap and install your desired tool:

```bash
brew tap xraph/tap
brew install forge         # Backend framework
brew install forgeui       # UI framework
brew install game-cli      # Game development CLI
```

Or install directly without explicitly adding the tap:

```bash
brew install xraph/tap/forge
brew install xraph/tap/forgeui
brew install xraph/tap/game-cli
```

## Available Tools

- **forge** - Comprehensive backend framework for Go with enterprise-grade features
- **forgeui** - SSR-first UI framework for Go with 35+ components, Tailwind CSS, and Alpine.js integration
- **game-cli** - CLI tool for GameFramework - automate Unity/Unreal exports and integration

## Updating

To update tools installed from this tap:

```bash
brew update
brew upgrade forge forgeui game-cli  # or specify individual tools
```

## Uninstalling

```bash
brew uninstall forge         # Uninstall individual tools
brew uninstall forgeui
brew uninstall game-cli
brew untap xraph/tap         # Optional: remove the tap if no longer needed
```

## Requirements

- macOS 10.13+ or Linux
- Homebrew 2.5.0+

## Contributing

Issues and contributions should be directed to the specific tool's repository.

## License

MIT
