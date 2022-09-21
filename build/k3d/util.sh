#!/usr/bin/env bash
# This script contains general helper functions for bash scripting.
set -Eeuo pipefail

util::info() {
    printf "💡 %s\n" "$@"
}

util::warn() {
    printf "⚠️ %s\n" "$@"
}

util::error() {
    printf "❌ %s\n" "$@"
}

util::success() {
  printf "✅ %s\n" "$@"
}
