# Build stage: use Debian for faster builds with pre-built wheels
FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Runtime stage: slim Debian
FROM python:3.11-slim-bookworm

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

ENV PORT=8000

EXPOSE $PORT

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT app:app"]