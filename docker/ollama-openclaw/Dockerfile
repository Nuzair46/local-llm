FROM node:22-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl git zstd \
  && curl -fsSL https://ollama.com/install.sh | sh \
  && npm install -g openclaw@latest \
  && npm cache clean --force \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN ollama --version
