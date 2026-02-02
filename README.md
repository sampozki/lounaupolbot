# LounauPolBot

A simple Telegram bot that creates the same time poll every time someone sends `/poll` in a group.

## Features
- `/poll` command posts a poll with default time options
- `/poll <question>` uses the text as the poll question
- Environment-based configuration
- Docker-ready and publishes to GHCR via GitHub Actions

## Requirements
- Python 3.11+
- A Telegram bot token

## Local Development
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export BOT_TOKEN="your-telegram-bot-token"
python bot.py
```

## Configuration
These variables are optional unless marked required.

- `BOT_TOKEN` (required)
- `POLL_QUESTION` (default: `Pick a time:`)
- `POLL_OPTIONS` (default: `10:00,10:30,11:00,11:30,12:00,12:30,13:00`)
- `POLL_ALLOW_MULTIPLE` (default: `true`)
- `POLL_ANONYMOUS` (default: `false`)
- `LOG_LEVEL` (default: `INFO`)

## Docker
```bash
docker build -t lounaupolbot .
docker run --rm -e BOT_TOKEN="your-telegram-bot-token" lounaupolbot
```

## CI/CD
GitHub Actions builds on PRs and publishes to GHCR on pushes to `main`.

## Argo CD
An example manifest is included at `argocd/lounaupolbot.yaml`. Replace placeholders:

- `BOT_TOKEN` in `bot-secrets`
- `.dockerconfigjson` in `ghcr-creds`
- `ghcr.io/<owner>/<repo>:latest` in the Deployment image
