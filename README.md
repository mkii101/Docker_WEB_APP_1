# 🧊 Dockerized Web Application

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=FastAPI&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

A production-ready containerized web application with FastAPI, PostgreSQL, Redis, and Nginx.

## Table of Contents
- [Project Structure](#project-structure)
- [Configuration Files](#configuration-files)
- [Setup Instructions](#setup-instructions)
- [Deployment](#deployment)
- [Security](#security)
- [Troubleshooting](#troubleshooting)

```.
├── app/
│ ├── main.py # FastAPI application
│ ├── requirements.txt # Python dependencies
├── nginx/
│ └── nginx.conf # Nginx configuration
├── docker-compose.yml # Orchestration file
├── Dockerfile # Multi-stage build config
├── .env.example # Environment template
├── .gitignore # Ignored files
└── README.md # This documentation
```

# 🔧 Configuration Files

## 🐋 Dockerfile
```dockerfile
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
CMD ["uvicorn", "main.py:app", "--host", "0.0.0.0", "--port", "8000"]```
```

## 🐳 Docker-compose.yml
```
Docker-compose.yml

version: '3.8'

services:
  app:
    build: .
    image: myapp:v1
    ports:
      - "8000:8000"
    depends_on:
      - redis
      - postgres
    environment:
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/mydb

  nginx:
    image: nginx:alpine
    ports:
      - "8001:8001"  # Changed from 8000:8000 to avoid conflict with app service
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app

  postgres:
    image: postgres:13-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD_FILE: /run/secrets/sec1
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_HOST_AUTH_METHOD: scram-sha-256
    secrets:
      - sec1
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:alpine

secrets:
  sec1:
    file: ./secret.txt

volumes:
  postgres_data:
```
  
### 🛠️ .env
```.env
# Database Configuration
DB_HOST=host_name_example
DB_PORT=port_number_example
DB_NAME=mydb_name_example
DB_USER=user_name_example
DB_PASSWORD=password_example

# App Settings
DEBUG=false
API_KEY=****
```

### 🛑 .gitignore
```.gitignore
# Environment files
.env
.env.*
!.env.example  # Keep example file if needed
```

## 🔒 Secret files
```
/secrets/
/docker-secrets/
secret.txt
# Docker-related
**/docker-compose.override.yml

# Database files
/postgres_data/  # Volume data
*.dump  # Database dumps

# Editor/IDE files
.idea/
.vscode/
*.swp
*.swo

# Python-specific (if applicable)
__pycache__/
*.py[cod]
```

## ⚙️🏗️  Setup Instructions

### 1. Clone repository:

```git clone https://github.com/yourusername/Docker_WEB_APP_1.git
cd Docker_WEB_APP_1

# 2. Set up secrets:
```mkdir -p secrets
echo "your_secure_db_password" > secrets/postgres_password.txt
chmod 600 secrets/postgres_password.txt

# 3. Configure environment:

```cp .env.example .env
nano .env  # Edit with your values

# 4. Build and run:
``` docker-compose up -d --build


## 🚀 Deployment

```docker-compose up -d


## Production

``` docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build


## ✅ Regular maintenance:

```docker scan web
docker secret rotate *secretname*

## 🛠 Troubleshooting Guide

## 👀 Common Issues and Solutions

```
| Error/Symptom | Possible Cause | Solution |
|--------------|---------------|----------|
| **`Error: failed to push some refs to [repository]`** | Remote has changes you don't have locally | Run:<br>`git pull origin main && git push origin main` |
| **`docker: Error response from daemon: Conflict`** | Container already exists | Run:<br>`docker-compose down` then restart |
| **`Connection refused to PostgreSQL`** | DB not ready or wrong credentials | 1. Check `.env` matches compose file<br>2. Wait 30s for DB initialization |
| **`ERROR: Couldn't connect to Docker daemon`** | Docker service not running | Start Docker Desktop or run:<br>`sudo systemctl start docker` |
| **`ModuleNotFoundError` in Python** | Missing dependencies | 1. Check `requirements.txt`<br>2. Rebuild containers: `docker-compose build --no-cache` |
| **`502 Bad Gateway` from Nginx** | Backend service down | Check logs:<br>`docker-compose logs web` |


## 🚨 Debugging Commands

1. **Check container status**:
   ```
   docker-compose ps

2. **View logs for a service**:
   ```
   docker-compose logs -f web  # (replace 'web' with service name)

3. **Enter a running container**:
   ```
   docker exec -it container_name /bin/sh

4. **Force rebuild images**:
   ```
   docker-compose build --no-cache

5. **Clean up unused resources**:
   ```
   docker system prune -a --volumes

## 🌐 Network Issues

1. **Clean up unused resources**:
   ```
   sudo lsof -i :8000  # Find PID using port
   kill -9 <PID>       # Replace with found PID 

2. **DNS resolution problems**:
   ```
   docker-compose exec web ping postgres  # Test service discovery 
   
## 🔄 Database Recovery

1. **Reset PostgreSQL data**:
   ```
    docker-compose down -v  # WARNING: Deletes all data
    docker-compose up -d 

2. **Create database backup**:
   ```
   docker-compose exec postgres pg_dump -U app_user app_db > backup.sql

# **THANK YOU FOR YOUR TIME : MOHAMED KHALED SAYED 🧑‍💻**
## Bsc. Mechatronics Engineering
## Msc. Management
## Warsaw, POLAND
