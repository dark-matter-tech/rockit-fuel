# CLAUDE.md — Fuel (Rockit Package Manager)

## Project

Fuel is the package manager for the Rockit programming language. Written in Rockit, compiled with the Stage 1 compiler (`command build-native`). First real application built with Rockit outside the compiler.

## Build

```bash
./build.sh
```

Or manually:

```bash
command build-native src/fuel.rok -o fuel --runtime-path /path/to/rockit_runtime.c
```

## Source Structure

Single file: `src/fuel.rok`

| Section | What it does |
|---------|-------------|
| Constants | `FUEL_VERSION()` |
| Utilities | `writeFile`, `stringSplit`, `dirName`, `baseName`, `findFlag` |
| Manifest Parser | `parseManifest` — line-based TOML-like parser |
| Commands | `cmdInit`, `cmdBuild`, `cmdRun`, `cmdVersion`, `cmdHelp` |
| Main | `main()` dispatcher |

## Available Builtins

Only C runtime builtins (no stdlib imports):

- **String**: `stringConcat`, `stringLength`, `substring`, `charAt`, `charCodeAt`, `stringIndexOf`, `startsWith`, `endsWith`, `stringTrim`, `toString`
- **File I/O**: `fileRead`, `fileWriteBytes`, `fileExists`, `fileDelete`
- **Process**: `processArgs`, `systemExec`
- **I/O**: `println`, `print`, `readLine`
- **Collections**: `listCreate`, `listAppend`, `listGet`, `listSet`, `listSize`, `listContains`, `listRemoveAt`, `mapCreate`, `mapPut`, `mapGet`, `mapKeys`
- **Type**: `toInt`, `isDigit`, `isLetter`, `isLetterOrDigit`

## Key Constraints

- No `fileWrite(path, string)` — use `stringToBytes()` + `fileWriteBytes()`
- No `mkdir` — use `systemExec("mkdir -p ...")`
- No `stringSplit` — implemented manually in utilities section
- No HTTP client — use `systemExec("curl ...")` when needed
- No `continue` in loops — use if/else chains

## Testing

```bash
./fuel version
./fuel help
cd /tmp && ./fuel init test-project
cd /tmp/test-project && ./fuel build --compiler-path ... --runtime-path ...
cd /tmp/test-project && ./fuel run --compiler-path ... --runtime-path ...
```

## Branch Strategy

`develop` → `staging` → `master`. All work starts on `develop`.

## Related Projects

- **RockitCompiler** (`moon` repo) — The Rockit compiler
- **Silo** — Package registry (planned)
- **Probe** — Test framework (planned)
