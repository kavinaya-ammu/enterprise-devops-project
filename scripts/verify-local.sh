#!/usr/bin/env bash
set -euo pipefail
command -v java >/dev/null && java -version
command -v mvn >/dev/null && mvn -version
(cd "$(dirname "$0")/../application" && mvn -B clean verify)
