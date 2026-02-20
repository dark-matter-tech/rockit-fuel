# Fuel

The package manager for the Rockit programming language.

Built with Rockit. Build once, deploy anywhere.

## Quick Start

```bash
# Build Fuel from source
./build.sh

# Create a new project
fuel init my-app

# Build and run
cd my-app
fuel build
fuel run
```

## Installation

### From Source

Requires the Rockit Stage 1 compiler (`command`) and `clang`.

```bash
git clone https://rustygits.com/Dark-Matter/fuel.git
cd fuel
./build.sh
```

The build script looks for the compiler at the default path. Override with environment variables:

```bash
ROCKIT_COMPILER=/path/to/command ROCKIT_RUNTIME=/path/to/rockit_runtime.c ./build.sh
```

### Add to PATH

```bash
cp fuel /usr/local/bin/
```

## Commands

### fuel init [name]

Create a new Rockit project with the standard directory structure.

```bash
fuel init my-app
```

### fuel build

Compile the project. Reads `Fuel.toml` for configuration and produces a native binary in `build/`.

```bash
fuel build
fuel build --compiler-path /path/to/command --runtime-path /path/to/rockit_runtime.c
```

### fuel run

Build and run the project.

```bash
fuel run
```

### fuel install

Resolve and fetch all dependencies declared in `Fuel.toml`. Writes `fuel.lock` for reproducible builds.

```bash
fuel install
```

### fuel add \<package\>

Add a dependency to `Fuel.toml` and install it.

```bash
fuel add json --git https://example.com/json.git --version "^1.0"
fuel add utils --path ../my-utils
```

### fuel remove \<package\>

Remove a dependency from `Fuel.toml`.

```bash
fuel remove json
```

### fuel update [package]

Update dependencies to the latest versions matching their constraints. Optionally update a single package.

```bash
fuel update          # update all
fuel update json     # update only json
```

### fuel list

List project dependencies and their status.

```bash
fuel list
```

### fuel clean

Remove build artifacts.

```bash
fuel clean
```

### fuel cache-clean

Clear the global package cache (`~/.rockit/packages/`).

```bash
fuel cache-clean
```

### fuel version

```bash
fuel version
```

### fuel help

```bash
fuel help
```

## Project Structure

`fuel init` creates:

```
my-project/
├── Fuel.toml          # Project manifest
├── src/
│   └── main.rok       # Entry point
└── README.md
```

## Fuel.toml Format

```toml
[package]
name = my-project
version = 0.1.0
description = A Rockit project

[dependencies]
```

### [package]

| Key | Description |
|-----|-------------|
| `name` | Project name (required) |
| `version` | Semantic version |
| `description` | One-line project description |

### [dependencies]

```toml
[dependencies]
json = "^1.0.0"
http = { version = "~2.1", git = "https://example.com/http.git" }
utils = { path = "../my-utils" }
```

## Architecture

Fuel is written in Rockit and compiled to a native binary with the Stage 1 compiler. It's the first real application built with Rockit outside of the compiler itself.

- **Source**: `src/fuel.rok` (single file)
- **Build**: `./build.sh` compiles with Stage 1 `command build-native`
- **Runtime**: Links against `rockit_runtime.c` (same as all native Rockit programs)

## Roadmap

### Done
- [x] `fuel init` — Project scaffolding
- [x] `fuel build` — Native compilation via `command`
- [x] `fuel run` — Build and run
- [x] `fuel clean` — Remove build artifacts
- [x] `fuel version` / `fuel help`
- [x] `Fuel.toml` manifest parsing
- [x] CI pipeline (Gitea Actions)
- [x] Compiler progress output (`Parsing... Type checking... Generating IR... Linking...`)
- [x] `fuel install` — Resolve and fetch git-based dependencies
- [x] `fuel add <package>` — Add dependencies to Fuel.toml
- [x] `fuel remove <package>` — Remove dependencies from Fuel.toml
- [x] Lock file (`fuel.lock`) for reproducible builds
- [x] Version constraint solving (`^`, `~`, `>=`, exact, `*`)
- [x] Package cache (`~/.rockit/packages/`)
- [x] `fuel cache-clean` — Clear the global package cache
- [x] Windows support
- [x] `fuel update` — Update dependencies to latest matching versions
- [x] `fuel list` — List project dependencies with status
- [x] Transitive dependency resolution with cycle detection
- [x] Lock file integrity verification (commit hash)
- [x] Exit codes for error conditions

### Next
- [ ] Standard library (`stdlib/rockit/`)
- [ ] `fuel test` — Probe test framework integration
- [ ] Multi-file project support (`src/**/*.rok`)
- [ ] Pre-built binary distribution per platform (macOS ARM64, macOS x86, Linux x86)
- [ ] Install script (`curl | sh` one-liner)

### Future
- [ ] `fuel publish` — Publish to Silo registry
- [ ] `fuel search` — Search Silo registry
- [ ] Cross-compilation (`--target-triple`)
- [ ] Docker CI image (pre-built compiler for faster CI)

## Contributing

Branch strategy: `develop` → `staging` → `master`

All work starts on `develop`. PRs to `staging` for pre-release testing, then to `master` for production.

## Requirements

- Rockit Stage 1 compiler (`command`)
- clang (for native compilation)
- macOS or Linux

## License

Copyright 2026 Dark Matter Tech. All rights reserved.
