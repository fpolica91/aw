#!/usr/bin/env bash
# murmel CLI installer — downloads a prebuilt binary, no clone or Go toolchain needed.
#   curl -fsSL https://raw.githubusercontent.com/fpolica91/aw/main/install.sh | bash
set -euo pipefail

REPO="fpolica91/aw"
BINARY="murmel"
INSTALL_DIR="${MURMEL_INSTALL_DIR:-/usr/local/bin}"

os="$(uname -s)"; arch="$(uname -m)"
case "$os" in Darwin) os=darwin ;; Linux) os=linux ;; *) echo "unsupported OS: $os" >&2; exit 1 ;; esac
case "$arch" in arm64|aarch64) arch=arm64 ;; x86_64|amd64) arch=amd64 ;; *) echo "unsupported arch: $arch" >&2; exit 1 ;; esac

asset="murmel-${os}-${arch}"
base="https://github.com/${REPO}/releases/latest/download"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

echo "Downloading ${asset}…"
curl -fsSL "${base}/${asset}" -o "${tmp}/murmel"
chmod +x "${tmp}/murmel"

# Best-effort checksum verification.
if curl -fsSL "${base}/checksums.txt" -o "${tmp}/checksums.txt" 2>/dev/null; then
  want="$(grep "  ${asset}\$" "${tmp}/checksums.txt" | awk '{print $1}')"
  if [ -n "$want" ]; then
    if command -v shasum >/dev/null 2>&1; then got="$(shasum -a 256 "${tmp}/murmel" | awk '{print $1}')";
    else got="$(sha256sum "${tmp}/murmel" | awk '{print $1}')"; fi
    [ "$want" = "$got" ] || { echo "checksum mismatch for ${asset}" >&2; exit 1; }
    echo "checksum OK"
  fi
fi

if [ -w "$INSTALL_DIR" ]; then
  mv "${tmp}/murmel" "${INSTALL_DIR}/${BINARY}"
else
  echo "Installing to ${INSTALL_DIR} (requires sudo)…"
  sudo mv "${tmp}/murmel" "${INSTALL_DIR}/${BINARY}"
fi

echo "✓ murmel installed → ${INSTALL_DIR}/${BINARY}"
"${INSTALL_DIR}/${BINARY}" version 2>/dev/null || true
echo
echo "Server: https://aweb-production-e89d.up.railway.app  (override with AWEB_URL)"
echo "Authenticate:  murmel login        # or: export AW_TOKEN=<jwt from the web app>"
echo "Then:          murmel whoami"
