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

### fuel clean

Remove build artifacts.

```bash
fuel clean
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

Dependencies will be listed as `name = source` pairs. Format TBD — git URLs with version tags planned for first release.

## Architecture

Fuel is written in Rockit and compiled to a native binary with the Stage 1 compiler. It's the first real application built with Rockit outside of the compiler itself.

- **Source**: `src/fuel.rok` (single file)
- **Build**: `./build.sh` compiles with Stage 1 `command build-native`
- **Runtime**: Links against `rockit_runtime.c` (same as all native Rockit programs)

## Roadmap

### MVP (current)
- [x] `fuel init` — Project scaffolding
- [x] `fuel build` — Native compilation via `command`
- [x] `fuel run` — Build and run
- [x] `fuel version` / `fuel help`
- [x] `Fuel.toml` manifest parsing
- [x] CI pipeline (Gitea Actions)

### Next
- [ ] `fuel test` — Probe test framework integration
- [ ] `fuel add <package>` — Add dependencies to Fuel.toml
- [ ] `fuel install` — Resolve and fetch git-based dependencies
- [x] `fuel clean` — Remove build artifacts
- [ ] Lock file (`Fuel.lock`) for reproducible builds
- [ ] Multi-file project support (`src/**/*.rok`)

### Future
- [ ] `fuel publish` — Publish to Silo registry
- [ ] `fuel search` — Search Silo registry
- [ ] Cross-compilation (`--target-triple`)
- [ ] Pre-built binary distribution per platform (macOS ARM64, macOS x86, Linux x86)

## Contributing

Branch strategy: `develop` → `staging` → `master`

All work starts on `develop`. PRs to `staging` for pre-release testing, then to `master` for production.

## Requirements

- Rockit Stage 1 compiler (`command`)
- clang (for native compilation)
- macOS or Linux

## License

Copyright 2026 Dark Matter Tech. All rights reserved.
