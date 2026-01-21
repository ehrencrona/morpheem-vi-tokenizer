FROM alpine:latest

RUN apk add --update python3 py3-pip

WORKDIR /app

COPY requirements.txt .

# Create virtual environment
RUN python3 -m venv venv

# This is the key change - properly activate the venv and use its pip
RUN . venv/bin/activate && pip3 install --no-cache-dir -r requirements.txt

COPY . .

# Default to port 8000 if PORT isn't set
ENV PORT=8000

# EXPOSE is just documentation
EXPOSE $PORT

# Modify CMD to use the virtual environment's Python/Gunicorn
CMD . venv/bin/activate && venv/bin/gunicorn --bind 0.0.0.0:$PORT app:app