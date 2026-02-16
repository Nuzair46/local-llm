# Local CPU LLM with LM Studio (llmster)

This project runs LM Studio headless server (`lmstudio/llmster-preview:cpu`) in CPU mode with configurable limits.

## Prerequisites

- Docker Engine
- Docker Compose plugin (`docker compose`)

## Quick Start

1. Start the service:

```bash
docker compose --profile development up -d llm
```

2. Watch logs:

```bash
docker compose --profile development logs -f llm
```

3. Download a model in the LM Studio catalog format:

```bash
docker compose --profile development exec llm lms get qwen/qwen2.5-7b --yes
```

4. Load the model with a 16k context window and a stable identifier:

```bash
docker compose --profile development exec llm \
  lms load qwen/qwen2.5-7b \
  --identifier "${LM_STUDIO_MODEL_IDENTIFIER:-qwen2.5-7b-ctx16k}" \
  --context-length "${LLM_CONTEXT_LENGTH:-16000}" \
  --gpu off \
  --yes
```

5. Verify the model is loaded:

```bash
docker compose --profile development exec llm lms ps --json
```

## Configuration

Set environment variables in a local `.env` file (same directory as `docker-compose.yml`) or inline in your shell.

```env
LLM_PORT=1234
LLM_CPUS=12
LLM_THREADS=12
LLM_MEM_LIMIT=32g
LLM_CONTEXT_LENGTH=16000
RAG_LOCAL_LLM_MODEL=qwen2.5-7b-instruct-1m
LM_STUDIO_MODEL_IDENTIFIER=qwen2.5-7b-ctx16k
```

Meaning:

- `LLM_PORT`: host port mapped to LM Studio server (`1234` in container).
- `LLM_CPUS`: CPU quota for the container.
- `LLM_THREADS`: thread count exposed to runtime (`OMP_NUM_THREADS`, `GGML_NUM_THREADS`, `OPENBLAS_NUM_THREADS`).
- `LLM_MEM_LIMIT`: memory cap for container and swap cap.
- `LLM_CONTEXT_LENGTH`: context window passed to `lms load`.
- `RAG_LOCAL_LLM_MODEL`: LM Studio model key (`qwen2.5-7b-instruct-1m`).
- `LM_STUDIO_MODEL_IDENTIFIER`: model name served on OpenAI-compatible endpoints.

## OpenAI-Compatible Test

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

## Stop and Cleanup

Stop services:

```bash
docker compose --profile development down
```

Stop and remove volumes (deletes downloaded models):

```bash
docker compose --profile development down -v
```
