# Contributing to Xraph Homebrew Tap

This tap serves multiple Xraph CLI tools. Follow these conventions to maintain consistency and avoid conflicts.

## Architecture

This is a **multi-package Homebrew tap** using formula-specific workflows to avoid event-type collisions.

### Directory Structure

```
.
├── Formula/
│   ├── forge.rb          # Forge formula
│   ├── game-cli.rb       # Game CLI formula
│   └── <package>.rb      # Future formulas
├── .github/workflows/
│   ├── update-forge.yml       # Auto-updates forge formula
│   ├── update-game-cli.yml    # Auto-updates game-cli formula
│   └── update-<package>.yml   # Future auto-update workflows
└── README.md
```

## Adding a New Formula

### 1. Create the Formula File

Add `Formula/<package-name>.rb` following [Homebrew formula conventions](https://docs.brew.sh/Formula-Cookbook):

```ruby
# typed: false
# frozen_string_literal: true

class PackageName < Formula
  desc "Short description of your package"
  homepage "https://github.com/xraph/<package-name>"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xraph/<package-name>/releases/download/v#{version}/<package-name>-v#{version}-macos-aarch64.tar.gz"
      sha256 "PLACEHOLDER_MACOS_ARM_SHA256"
    else
      url "https://github.com/xraph/<package-name>/releases/download/v#{version}/<package-name>-v#{version}-macos-x86_64.tar.gz"
      sha256 "PLACEHOLDER_MACOS_X86_SHA256"
    end
  end

  on_linux do
    url "https://github.com/xraph/<package-name>/releases/download/v#{version}/<package-name>-v#{version}-linux-x64.tar.gz"
    sha256 "PLACEHOLDER_LINUX_SHA256"
  end

  def install
    bin.install "<binary-name>"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/<binary-name> --version")
  end
end
```

### 2. Create Auto-Update Workflow

Create `.github/workflows/update-<package-name>.yml`:

```yaml
name: Update <package-name> Formula

on:
  repository_dispatch:
    types: [update-<package-name>]  # Must be unique per formula

jobs:
  update:
    name: Update <package-name> formula
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Update formula
        env:
          VERSION: ${{ github.event.client_payload.version }}
          MACOS_X86_SHA: ${{ github.event.client_payload.macos_x86_sha }}
          MACOS_ARM_SHA: ${{ github.event.client_payload.macos_arm_sha }}
          LINUX_SHA: ${{ github.event.client_payload.linux_sha }}
        run: |
          echo "Updating <package-name> formula to version ${VERSION}"
          
          cat > Formula/<package-name>.rb << EOF
          # typed: false
          # frozen_string_literal: true

          class PackageName < Formula
            desc "Short description"
            homepage "https://github.com/xraph/<package-name>"
            version "${VERSION}"
            license "MIT"

            on_macos do
              if Hardware::CPU.arm?
                url "https://github.com/xraph/<package-name>/releases/download/v#{version}/<package-name>-v#{version}-macos-aarch64.tar.gz"
                sha256 "${MACOS_ARM_SHA}"
              else
                url "https://github.com/xraph/<package-name>/releases/download/v#{version}/<package-name>-v#{version}-macos-x86_64.tar.gz"
                sha256 "${MACOS_X86_SHA}"
              end
            end

            on_linux do
              url "https://github.com/xraph/<package-name>/releases/download/v#{version}/<package-name>-v#{version}-linux-x64.tar.gz"
              sha256 "${LINUX_SHA}"
            end

            def install
              bin.install "<binary-name>"
            end

            test do
              assert_match version.to_s, shell_output("#{bin}/<binary-name> --version")
            end
          end
          EOF

          # Remove leading whitespace from heredoc
          sed -i 's/^          //' Formula/<package-name>.rb
          cat Formula/<package-name>.rb

      - name: Commit and push
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add Formula/<package-name>.rb
          git commit -m "chore: update <package-name> to v${{ github.event.client_payload.version }}" || echo "No changes to commit"
          git push
```

**Key points:**
- Event type must be `update-<package-name>` (unique per formula)
- Workflow updates only its own formula file
- Include SHA256 for all platforms

### 3. Update Source Repository Release Workflow

In your package's repository (e.g., `xraph/<package-name>`), add this to your release workflow:

```yaml
jobs:
  # ... your existing release jobs ...

  update-homebrew:
    name: Update Homebrew Formula
    needs: [release]  # Wait for release artifacts
    runs-on: ubuntu-latest
    if: ${{ !contains(needs.release.outputs.version, '-') }}  # Only stable releases
    steps:
      - name: Update Homebrew Formula
        uses: peter-evans/repository-dispatch@v3
        with:
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          repository: xraph/homebrew-tap
          event-type: update-<package-name>  # Must match workflow event type
          client-payload: |
            {
              "version": "${{ needs.release.outputs.version }}",
              "macos_x86_sha": "${{ needs.release.outputs.macos_x86_sha }}",
              "macos_arm_sha": "${{ needs.release.outputs.macos_arm_sha }}",
              "linux_sha": "${{ needs.release.outputs.linux_sha }}"
            }
```

**Required GitHub Secret:**
- Add `HOMEBREW_TAP_TOKEN` to your package repository secrets
- Token needs `repo` scope with write access to `xraph/homebrew-tap`

### 4. Update README.md

Add your package to the "Available Tools" section:

```markdown
- **<package-name>** - Short description of the package
```

Update installation examples if needed.

## Testing Formula Locally

Before committing, test your formula:

```bash
# Audit formula syntax
brew audit --strict Formula/<package-name>.rb

# Test installation locally
brew install --build-from-source Formula/<package-name>.rb

# Verify it works
<binary-name> --version

# Clean up
brew uninstall <package-name>
```

## Conventions

### Event Type Naming
- Pattern: `update-<package-name>`
- Must match between workflow file and source repository dispatch
- Examples: `update-forge`, `update-game-cli`, `update-stellar`

### Workflow File Naming
- Pattern: `update-<package-name>.yml`
- Must match the package/formula name
- Examples: `update-forge.yml`, `update-game-cli.yml`

### Formula Class Naming
- Must be PascalCase
- Remove hyphens: `game-cli` → `GameCli`
- Remove special characters: `my-tool-2` → `MyTool2`

### Commit Messages
- Use conventional commits format
- Auto-update commits: `chore: update <package-name> to v1.2.3`
- Manual changes: `feat: add <package-name> formula`

## Troubleshooting

### Formula not updating after release
1. Check GitHub Actions in source repository - did dispatch succeed?
2. Check GitHub Actions in tap repository - did workflow trigger?
3. Verify `HOMEBREW_TAP_TOKEN` is set correctly
4. Verify event-type matches between source dispatch and workflow

### Formula syntax errors
```bash
brew audit --strict Formula/<package-name>.rb
brew style Formula/<package-name>.rb
```

### SHA256 mismatch errors
- Workflow auto-calculates SHA256 from release artifacts
- Verify release artifacts uploaded correctly
- Check SHA256 calculation in source repository workflow

## References

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Acceptable Formulae](https://docs.brew.sh/Acceptable-Formulae)
- [peter-evans/repository-dispatch action](https://github.com/peter-evans/repository-dispatch)

## Questions?

Open an issue in the specific tool's repository for support.
