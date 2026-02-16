# Local CPU LLM with Docker Compose

This project runs an Ollama container in CPU mode with configurable limits.

## Prerequisites

- Docker Engine
- Docker Compose plugin (`docker compose`)

## Files

- `docker-compose.yml`: service definition and resource limits.
- `scripts/start_ollama.sh`: starts Ollama, waits for readiness, and pulls the model.

## Quick Start

1. Start the service:

```bash
docker compose --profile development up -d
```

2. Watch logs (first boot pulls the model and can take time):

```bash
docker compose --profile development logs -f llm
```

3. Check container status:

```bash
docker compose --profile development ps
```

## Configuration

Set environment variables in a local `.env` file (same directory as `docker-compose.yml`) or inline in your shell.

```env
LLM_PORT=11434
LLM_CPUS=12
LLM_THREADS=12
LLM_MEM_LIMIT=32g
LLM_CONTEXT_LENGTH=16000
RAG_LOCAL_LLM_MODEL=qwen2.5:7b
```

Meaning:

- `LLM_PORT`: host port mapped to Ollama (`11434` in container).
- `LLM_CPUS`: CPU quota for the container.
- `LLM_THREADS`: thread count exposed to runtime (`OMP_NUM_THREADS`).
- `LLM_MEM_LIMIT`: memory cap for container and swap cap.
- `LLM_CONTEXT_LENGTH`: default context window (`OLLAMA_CONTEXT_LENGTH`).
- `RAG_LOCAL_LLM_MODEL`: model pulled on startup.

## Test a Request

```bash
curl http://localhost:11434/api/generate \
  -d '{
    "model":"qwen2.5:7b",
    "prompt":"Say hello in one short sentence.",
    "stream": false
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
