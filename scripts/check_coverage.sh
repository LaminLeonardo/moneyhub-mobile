#!/usr/bin/env bash
# Quality gate de cobertura de testes.
# Uso: bash scripts/check_coverage.sh <caminho/lcov.info> <percentual_minimo>
set -euo pipefail

FILE="${1:-coverage/lcov.info}"
MIN="${2:-70}"

if [[ ! -f "$FILE" ]]; then
  echo "::error::Arquivo de cobertura não encontrado: $FILE"
  exit 1
fi

read -r LF LH < <(awk -F: '/^LF:/{lf+=$2} /^LH:/{lh+=$2} END{print lf+0, lh+0}' "$FILE")
PCT=$(awk -v lh="$LH" -v lf="$LF" 'BEGIN{ if (lf == 0) print "0.00"; else printf "%.2f", lh * 100 / lf }')

echo "Cobertura de linhas: ${PCT}% (${LH}/${LF}) — mínimo exigido: ${MIN}%"

if awk -v p="$PCT" -v m="$MIN" 'BEGIN{ exit !(p >= m) }'; then
  echo "Quality gate de cobertura: OK"
else
  echo "::error::Cobertura ${PCT}% abaixo do mínimo de ${MIN}%"
  exit 1
fi
