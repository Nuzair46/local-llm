#!/bin/sh

set -eu

MODEL="${RAG_LOCAL_LLM_MODEL:-qwen2.5:7b}"

ollama serve &
SERVER_PID=$!

cleanup() {
  if kill -0 "$SERVER_PID" >/dev/null 2>&1; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
    wait "$SERVER_PID" >/dev/null 2>&1 || true
  fi
}

trap cleanup INT TERM

until ollama list >/dev/null 2>&1; do
  sleep 1
done

echo "Pulling local LLM model: $MODEL"
ollama pull "$MODEL"

wait "$SERVER_PID"
