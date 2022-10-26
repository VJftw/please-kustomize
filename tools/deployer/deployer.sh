#!/usr/bin/env bash
set -Eeuo pipefail

main() {
    set +e
    "$HELM_DIFF_UPGRADE"
    ec="$?"
    set -e

    case "$ec" in
        0)
            log::success "No changes to deploy. Exiting."
            return
        ;;
        1)
            log::error "Could not determine changes to deploy."
            exit 1
        ;;
        2)
            log::info "Changes found. Deploying..."
            "$HELM_PUSH_IMAGES"
            "$HELM_UPGRADE"
            log::success "Deployed changes."
        ;;
    esac
}

# define utils
log::info() {
    printf "💡 %s\n" "$@"
}

log::warn() {
    printf "⚠️ %s\n" "$@"
}

log::error() {
   printf "❌ %s\n" "$@"
}

log::success() {
   printf "✅ %s\n" "$@"
}

main
