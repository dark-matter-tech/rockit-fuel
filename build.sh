#!/bin/bash
# Build the Fuel package manager
# Compiles fuel.rok to a native binary using the Stage 1 Rockit compiler.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPILER="${ROCKIT_COMPILER:-/Users/micahburnside/Developer/LLVM/moon/RockitCompiler/Stage1/command}"
RUNTIME="${ROCKIT_RUNTIME:-/Users/micahburnside/Developer/LLVM/moon/RockitCompiler/Runtime/rockit_runtime.c}"

if [ ! -f "$COMPILER" ]; then
    echo "error: Rockit compiler not found at $COMPILER"
    echo "Set ROCKIT_COMPILER to the path of the Stage 1 'command' binary."
    exit 1
fi

if [ ! -f "$RUNTIME" ]; then
    echo "error: Rockit runtime not found at $RUNTIME"
    echo "Set ROCKIT_RUNTIME to the path of rockit_runtime.c."
    exit 1
fi

"$COMPILER" build-native "$SCRIPT_DIR/src/fuel.rok" -o "$SCRIPT_DIR/fuel" --runtime-path "$RUNTIME"
