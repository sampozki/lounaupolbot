
FROM python:3.12-slim AS builder

LABEL Maintainer="sampozki"

WORKDIR /app

# Install uv
RUN pip install --no-cache-dir uv

# Copy dependency files first (better caching)
COPY pyproject.toml uv.lock ./

# Create virtual environment + install deps
RUN uv sync --no-dev

# ---- Final image ----
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy the virtual environment
COPY --from=builder /app/.venv /app/.venv

# Make sure venv is used
ENV PATH="/app/.venv/bin:$PATH"

COPY bot.py .

CMD ["python", "bot.py"]
