
FROM python:3.12.3-slim AS builder

LABEL Maintainer="sampozki"

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.10.2 /uv /uvx /bin/

# Copy dependency files first (for layer caching)
COPY pyproject.toml uv.lock ./

# Export locked deps to requirements.txt
RUN uv export --format=requirements.txt --no-dev > requirements.txt

# Install into system Python
RUN uv pip install --system --no-cache -r requirements.txt

# Copy app
COPY bot.py .

FROM gcr.io/distroless/python3-debian12:3.12

WORKDIR /app

# Copy installed Python runtime and packages
COPY --from=builder /usr/local /usr/local

# Copy app
COPY --from=builder /app/bot.py /app/bot.py

# Distroless already has ENTRYPOINT ["python3"]
CMD ["bot.py"]