FROM ollama/ollama:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends nodejs npm \
  && npm install -g openclaw@latest \
  && npm cache clean --force \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
