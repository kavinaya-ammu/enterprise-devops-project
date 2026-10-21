#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
command -v trivy >/dev/null || { echo 'ERROR: trivy is not installed' >&2; exit 127; }
echo '[1/3] Filesystem/dependency/secret/misconfiguration scan'
trivy fs --scanners vuln,misconfig,secret --severity HIGH,CRITICAL --exit-code 1 .
if [[ -f application/Dockerfile ]]; then
  echo '[2/3] Dockerfile configuration scan'
  trivy config --severity HIGH,CRITICAL --exit-code 1 application/Dockerfile
fi
if [[ -n "${IMAGE_REF:-}" ]]; then
  echo "[3/3] Image scan: ${IMAGE_REF}"
  trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMAGE_REF"
else
  echo '[3/3] IMAGE_REF not set; image scan skipped. Set IMAGE_REF=registry/name:tag to scan an image.'
fi
