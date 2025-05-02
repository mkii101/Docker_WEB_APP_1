# Build stage
FROM python:3.9-slim as builder
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --user -r requirements.txt

# Runtime stage
FROM python:3.9-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY ./app .

EXPOSE 8000

ENV PATH=/root/.local/bin:$PATH
CMD ["uvicorn", "main.py:app", "--host", "0.0.0.0", "--port", "8000"]