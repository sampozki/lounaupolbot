import logging
import os
from typing import List

from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes


def _get_poll_question(message_text: str | None) -> str:
    if message_text:
        return message_text
    return os.getenv("POLL_QUESTION", "Lounau? ")


def _get_poll_options() -> List[str]:
    raw = os.getenv(
        "POLL_OPTIONS",
        "10:30,11:00,11:30,12:00",
    )
    options = [item.strip() for item in raw.split(",") if item.strip()]
    if len(options) < 2:
        raise ValueError("POLL_OPTIONS must contain at least 2 comma-separated options.")
    return options


async def poll_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.message is None:
        logging.info("Received /poll without a message payload. Ignoring.")
        return

    message_text = None
    if update.message.text:
        parts = update.message.text.split(maxsplit=1)
        if len(parts) > 1:
            message_text = parts[1].strip()
    question = _get_poll_question(message_text)
    options = _get_poll_options()
    allows_multiple = os.getenv("POLL_ALLOW_MULTIPLE", "true").lower() == "true"
    is_anonymous = os.getenv("POLL_ANONYMOUS", "false").lower() == "true"

    logging.info(
        "Creating poll. chat_id=%s question=%r options=%s",
        update.effective_chat.id if update.effective_chat else "unknown",
        question,
        options,
    )
    await update.message.reply_poll(
        question=question,
        options=options,
        is_anonymous=is_anonymous,
        allows_multiple_answers=allows_multiple,
    )


async def error_handler(update: object, context: ContextTypes.DEFAULT_TYPE) -> None:
    logging.exception("Unhandled error while processing update.", exc_info=context.error)


def main() -> None:
    logging.basicConfig(
        level=os.getenv("LOG_LEVEL", "INFO").upper(),
        format="%(asctime)s %(levelname)s %(name)s %(message)s",
    )

    token = os.getenv("BOT_TOKEN")
    if not token:
        raise SystemExit("BOT_TOKEN is required.")

    application = Application.builder().token(token).build()
    application.add_handler(CommandHandler("poll", poll_command))
    application.add_error_handler(error_handler)

    logging.info("Starting bot.")
    application.run_polling()


if __name__ == "__main__":
    main()
