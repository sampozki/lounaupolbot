FROM python:3.12-slim

LABEL Maintainer="sampozki"

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:0.10.2 /uv /uvx /bin/

COPY pyproject.toml uv.lock ./

RUN uv pip install --system .

COPY bot.py .

CMD ["python", "bot.py"]