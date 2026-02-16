# Local CPU LLM with LM Studio (llmster)

This project builds a custom Docker image from `ubuntu:24.04`, installs `llmster`/`lms`, and runs LM Studio headless in CPU mode.

## Prerequisites

- Docker Engine
- Docker Compose plugin (`docker compose`)

## Files

- `docker-compose.yml`: service definition and resource limits.
- `docker/lmster/Dockerfile`: base image + LM Studio CLI installation.
- `scripts/start_lmster.sh`: starts LM Studio daemon and API server.

## Quick Start

1. Build and start:

```bash
docker compose --profile development up -d --build llm
```

2. Check logs:

```bash
docker compose --profile development logs -f llm
```

3. Install GGUF runtime (one-time on a fresh volume):

```bash
docker compose --profile development exec llm lms runtime get llama.cpp
```

4. Download Qwen 2.5 7B Instruct:

```bash
docker compose --profile development exec llm lms get qwen/qwen2.5-7b --yes
```

5. Load model with 16k context and stable identifier:

```bash
docker compose --profile development exec llm \
  lms load qwen/qwen2.5-7b \
  --identifier qwen2.5-7b-ctx16k \
  --context-length 16000 \
  --gpu off \
  --yes
```

6. Verify loaded model:

```bash
docker compose --profile development exec llm lms ps --json
```

7. Test OpenAI-compatible endpoint:

```bash
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model":"qwen2.5-7b-ctx16k",
    "messages":[
      {"role":"user","content":"Say hello in one short sentence."}
    ],
    "temperature":0.2
  }'
```

## Compose Variables

Only these variables are used by `docker-compose.yml`:

```env
LLM_PORT=1234
LLM_CPUS=12
LLM_MEM_LIMIT=32g
```

- `LLM_PORT`: host port mapped to LM Studio server (`1234` in container).
- `LLM_CPUS`: CPU quota for container.
- `LLM_MEM_LIMIT`: memory cap for container and swap cap.

## Stop and Cleanup

Stop services:

```bash
docker compose --profile development down
```

Stop and remove volumes (deletes downloaded models and runtimes):

```bash
docker compose --profile development down -v
```
