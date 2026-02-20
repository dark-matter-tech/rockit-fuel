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
| Utilities | `writeFile`, `stringSplit`, `dirName`, `baseName`, `findFlag`, `hasFlag`, `stringContains`, `stripQuotes`, `isAllDigits`, `captureExec`, `homeDir`, `cacheDir`, `ensureCacheDir` |
| Version Parsing | `parseVersion`, `parseVersionLoose`, `isValidVersion`, `versionString`, `versionInt` |
| Version Constraints | `parseConstraint`, `satisfiesConstraint`, `bestMatchVersion` |
| Manifest Parser | `parseInlineTable`, `parseManifest`, `addDependencyToManifest`, `removeDependencyFromManifest` |
| Lock File | `parseLockFile`, `findLockedPackage`, `serializeLockFile`, `writeLockFile` |
| Package Cache | `packageCacheDir`, `isPackageCached` |
| Git Operations | `discoverVersions`, `fetchPackage` |
| Dependency Resolver | `resolveOneDep`, `resolveDependencies` |
| Commands | `cmdInit`, `cmdInstall`, `cmdAdd`, `cmdRemove`, `cmdBuild`, `cmdRun`, `cmdClean`, `cmdCacheClean`, `cmdVersion`, `cmdHelp` |
| Main | `main()` dispatcher |

## Available Builtins

Only C runtime builtins (no stdlib imports):

- **String**: `stringConcat`, `stringLength`, `substring`, `charAt`, `charCodeAt`, `stringIndexOf`, `startsWith`, `endsWith`, `stringTrim`, `toString`
- **File I/O**: `fileRead`, `fileWriteBytes`, `fileExists`, `fileDelete`
- **Process**: `processArgs`, `systemExec`, `getEnv`, `platformOS`
- **I/O**: `println`, `print`, `readLine`
- **Collections**: `listCreate`, `listAppend`, `listGet`, `listSet`, `listSize`, `listContains`, `listRemoveAt`, `mapCreate`, `mapPut`, `mapGet`, `mapKeys`
- **Type**: `toInt`, `isDigit`, `isLetter`, `isLetterOrDigit`

## Key Constraints

- No `fileWrite(path, string)` — use `stringToBytes()` + `fileWriteBytes()`
- No `mkdir` — use `systemExec("mkdir -p ...")`
- No `stringSplit` — implemented manually in utilities section
- No HTTP client — use `systemExec("curl ...")` when needed
- No `continue` in loops — use if/else chains
- `mapGet` returns `null` for missing keys — `toString(null)` gives `"null"`, always check for null before `toString`

## Dependency Resolution

Dependencies are declared in `Fuel.toml` under `[dependencies]`:

```toml
[dependencies]
json = "^1.0.0"
http = { version = "~2.1", git = "https://example.com/http.git" }
utils = { path = "../my-utils" }
```

### Version Constraints

| Syntax | Meaning |
|--------|---------|
| `^1.2.3` | >=1.2.3, <2.0.0 (compatible) |
| `^0.2.3` | >=0.2.3, <0.3.0 (zero-major caret) |
| `~1.2.3` | >=1.2.3, <1.3.0 (patch only) |
| `>=1.0.0` | Greater or equal |
| `1.2.3` | Exact match |
| `*` | Any version |

### Resolution Flow

1. Parse `Fuel.toml` for `[dependencies]`
2. If `fuel.lock` exists, prefer locked versions (if they still satisfy constraints)
3. Otherwise: `git ls-remote --tags <url>` to discover available versions
4. Pick highest version matching the constraint
5. Shallow-clone into `~/.rockit/packages/<name>-<version>/`
6. Write `fuel.lock`

### Cache Layout

```
~/.rockit/packages/
  json-1.2.4/
    Fuel.toml
    src/
      json.rok
  http-2.1.3/
    src/
      http.rok
```

## Testing

```bash
./fuel version
./fuel help
cd /tmp && ./fuel init test-project
cd /tmp/test-project && ./fuel install
cd /tmp/test-project && ./fuel add mylib --git <url> --version "^1.0"
cd /tmp/test-project && ./fuel remove mylib
./fuel cache-clean
cd /tmp/test-project && ./fuel build --compiler-path ... --runtime-path ...
cd /tmp/test-project && ./fuel run --compiler-path ... --runtime-path ...
```

## Branch Strategy

`develop` → `staging` → `master`. All work starts on `develop`.

## Related Projects

- **RockitCompiler** (`moon` repo) — The Rockit compiler
- **Silo** — Package registry (planned)
- **Probe** — Test framework (planned)
