FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-install-project

COPY dbt_project.yml /app/
COPY models /app/models
COPY seeds /app/seeds
COPY macros /app/macros
COPY snapshots /app/snapshots
COPY tests /app/tests
COPY analyses /app/analyses
COPY ecs ./ecs

ENV PATH="/app/.venv/bin:$PATH"

ENTRYPOINT ["dbt"]