#!/usr/bin/env bash
# Smoke test pós-deploy: verifica se o site publicado responde e se a
# versão publicada (version.json gerado pelo Flutter) é a esperada.
# Uso: bash scripts/smoke_test.sh <url_base_com_barra_final> <versao_esperada>
set -euo pipefail

URL="${1:?informe a URL base}"
EXPECTED="${2:?informe a versão esperada}"
ATTEMPTS="${3:-20}"
WAIT="${4:-15}"

for i in $(seq 1 "$ATTEMPTS"); do
  TS=$(date +%s)
  BODY=$(curl -fsS "${URL}version.json?t=${TS}" 2>/dev/null || true)
  if echo "$BODY" | grep -Eq "\"version\" ?: ?\"${EXPECTED}\""; then
    curl -fsS -o /dev/null "${URL}?t=${TS}"
    curl -fsS -o /dev/null "${URL}main.dart.js?t=${TS}"
    echo "Smoke test OK: ${URL} está no ar com a versão ${EXPECTED}"
    exit 0
  fi
  echo "Tentativa ${i}/${ATTEMPTS}: versão ${EXPECTED} ainda não publicada (${BODY:-sem resposta}). Aguardando ${WAIT}s..."
  sleep "$WAIT"
done

echo "::error::Smoke test falhou: ${URL} não respondeu com a versão ${EXPECTED}"
exit 1
