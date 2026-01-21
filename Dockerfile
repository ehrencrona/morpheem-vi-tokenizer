# Build stage: Alpine with build tools
FROM python:3.11-alpine AS builder

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache gcc g++ musl-dev linux-headers python3-dev && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

# Runtime stage: clean Alpine without build tools
FROM python:3.11-alpine

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

ENV PORT=8000

EXPOSE $PORT

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT app:app"]