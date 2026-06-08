#!/usr/bin/env bash
set -euo pipefail

# Build Mine Wallet APK with env-specific config by flavor.
# Usage:
#   ./build_apk.sh --flavor local
#   ./build_apk.sh --flavor development
#   ./build_apk.sh --flavor production --release
#   ./build_apk.sh --flavor development --debug

FLAVOR=""
BUILD_MODE="--release"
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --flavor)
      FLAVOR="${2:-}"
      shift 2
      ;;
    --debug|--profile|--release)
      BUILD_MODE="$1"
      shift
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ -z "$FLAVOR" ]]; then
  echo "Error: missing --flavor. Use local, development, or production."
  exit 1
fi

case "$FLAVOR" in
  local)
    CONFIG_FILE="assets/config.local.yaml"
    ;;
  development)
    CONFIG_FILE="assets/config.development.yaml"
    ;;
  production)
    # Prefer config.yml if present, fallback to existing config.yaml.
    if [[ -f "assets/config.yml" ]]; then
      CONFIG_FILE="assets/config.yml"
    else
      CONFIG_FILE="assets/config.yaml"
    fi
    ;;
  *)
    echo "Error: unsupported flavor '$FLAVOR'. Use local, development, or production."
    exit 1
    ;;
esac

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: config file not found: $CONFIG_FILE"
  exit 1
fi

if command -v fvm >/dev/null 2>&1; then
  FLUTTER_CMD=(fvm flutter)
else
  FLUTTER_CMD=(flutter)
fi

read_yaml_value() {
  local key="$1"
  awk -v key="$key" '
    $0 ~ "^[[:space:]]*" key ":[[:space:]]*" {
      value = substr($0, index($0, ":") + 1)
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      sub(/[[:space:]]+#.*$/, "", value)
      gsub(/^["'"'"']|["'"'"']$/, "", value)
      print value
      exit
    }
  ' "$CONFIG_FILE"
}

BUILD_NAME="$(read_yaml_value "build_name")"
BUILD_NUMBER="$(read_yaml_value "build_number")"

if [[ -n "$BUILD_NUMBER" && ! "$BUILD_NUMBER" =~ ^[0-9]+$ ]]; then
  echo "Error: build_number in $CONFIG_FILE must be an integer."
  exit 1
fi

echo "Building flavor=$FLAVOR mode=$BUILD_MODE with $CONFIG_FILE"
BUILD_CMD=(
  "${FLUTTER_CMD[@]}" build apk
  --flavor "$FLAVOR"
  "$BUILD_MODE"
  --dart-define="APP_CONFIG_FILE=$CONFIG_FILE"
)

if [[ -n "$BUILD_NAME" ]]; then
  BUILD_CMD+=(--build-name "$BUILD_NAME")
fi

if [[ -n "$BUILD_NUMBER" ]]; then
  BUILD_CMD+=(--build-number "$BUILD_NUMBER")
fi

if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  BUILD_CMD+=("${EXTRA_ARGS[@]}")
fi

"${BUILD_CMD[@]}"
