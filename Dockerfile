# ---------- Builder ----------
FROM python:3.12-slim AS builder

LABEL Maintainer="sampozki"

WORKDIR /app

# Copy uv
COPY --from=ghcr.io/astral-sh/uv:0.10.2 /uv /uvx /bin/

# Copy dependency definition
COPY pyproject.toml uv.lock ./

# Install dependencies only
RUN uv pip install --system --no-cache-dir .

# ---------- Final ----------
FROM python:3.12-slim

WORKDIR /app

# Copy only installed packages (not uv, not build layers)
COPY --from=builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy app
COPY bot.py .

CMD ["python", "bot.py"]