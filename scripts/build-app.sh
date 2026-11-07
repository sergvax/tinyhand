#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
cd "$ROOT"

BUILD_ARGS=(-c release)
if [[ -n "${TINYHAND_SDK:-}" ]]; then
    BUILD_ARGS+=(--sdk "$TINYHAND_SDK")
fi
swift build "${BUILD_ARGS[@]}"
quit_running_app

APP="dist/$APP_NAME.app"
BUILD_NUMBER="${TINYHAND_BUILD_NUMBER:-$(date +%Y%m%d%H%M)}"
make_bundle .build/release/$APP_NAME "$APP" "$BUILD_NUMBER"

IDENTITY="${CODESIGN_IDENTITY:-Developer ID Application}"
sign_app "$APP" "$IDENTITY"
echo "Built $APP $VERSION (signed with: $IDENTITY)"
