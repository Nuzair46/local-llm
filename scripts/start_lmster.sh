#!/usr/bin/env bash

set -euo pipefail

if [[ ! -x /root/.lmstudio/bin/lms ]]; then
  mkdir -p /root/.lmstudio/bin
  install -m 0755 /opt/lmstudio/bin/lms /root/.lmstudio/bin/lms
fi

export PATH="/opt/lmstudio/bin:/root/.lmstudio/bin:${PATH}"

cleanup() {
  lms server stop >/dev/null 2>&1 || true
  lms daemon down >/dev/null 2>&1 || true
}

trap cleanup INT TERM

lms daemon up

if [[ "${LM_STUDIO_INSTALL_GGUF_RUNTIME:-false}" == "true" ]] && lms runtime --help >/dev/null 2>&1; then
  lms runtime get llama.cpp || true
fi

lms server start &
SERVER_PID=$!

wait "${SERVER_PID}"
