
FROM python:3.12.3-slim AS builder

LABEL Maintainer="sampozki"

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.10.2 /uv /uvx /bin/

# Copy dependency files first (better caching)
COPY pyproject.toml uv.lock ./
RUN uv pip install --system .

COPY bot.py .

FROM gcr.io/distroless/python3-debian12

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=builder /usr/local/bin /usr/local/bin

COPY --from=builder /app/bot.py /app/bot.py

CMD ["bot.py"]