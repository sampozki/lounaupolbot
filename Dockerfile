
FROM python:3.12-slim AS builder

LABEL Maintainer="sampozki"

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.10.2 /uv /uvx /bin/

# Copy dependency files first (better caching)
COPY pyproject.toml uv.lock ./

# Create virtual environment + install deps
RUN uv sync --no-dev

COPY bot.py .

# ---- Final image ----
FROM gcr.io/distroless/python3

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy the virtual environment
COPY --from=builder /app /app

ENTRYPOINT ["/app/.venv/bin/python"]
CMD ["bot.py"]
