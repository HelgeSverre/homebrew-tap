# Homebrew Tap

Homebrew formulae for tools by [Helge Sverre](https://github.com/HelgeSverre).

## Install

```bash
brew tap helgesverre/tap
```

## Available Formulae

| Formula | Description | Install |
|---------|-------------|---------|
| [sema-lang](https://sema-lang.com) | Sema — a Lisp dialect with first-class LLM primitives | `brew install helgesverre/tap/sema-lang` |

## Usage

```bash
# Install a formula
brew install helgesverre/tap/<formula-name>

# Update to latest version
brew update && brew upgrade helgesverre/tap/<formula-name>
```

## How It Works

Formulae are automatically published by [cargo-dist](https://github.com/axodotdev/cargo-dist) when a new version is tagged in the source repository. No manual updates needed.
