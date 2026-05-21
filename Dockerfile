# ─── Курсовая работа: чат-бот для продажи смартфонов (Вариант 24) ───
# Образ с Python, ffmpeg (для голоса) и всеми зависимостями
FROM python:3.11-slim

# Системные зависимости:
#   ffmpeg        — конвертация голосовых OGG → WAV
#   portaudio/gcc — для сборки PyAudio
#   curl          — служебное
RUN apt-get update && apt-get install -y --no-install-recommends \
        ffmpeg \
        flac \
        gcc \
        portaudio19-dev \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Сначала зависимости (для кеширования слоёв Docker)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Предзагрузка данных NLTK (чтобы не качать при каждом запуске)
RUN python -c "import nltk; nltk.download('punkt', quiet=True)"

# Код бота и датасет диалогов
COPY chatbot_var24.py .
COPY dialogues.txt .

# По умолчанию запускаем Telegram-бота
CMD ["python", "chatbot_var24.py", "--telegram"]
