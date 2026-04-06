# 🐳 Docker Setup Guide - VYNK

This guide covers building and running the entire VYNK application using Docker.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed
- Docker Compose installed (included with Docker Desktop)
- 2GB+ available disk space

## Quick Start

### 1. Clone and Navigate to Project

```bash
cd /Users/ayush9085/Documents/Vync
```

### 2. Create Environment File

```bash
cp .env.example .env
```

Edit `.env` if needed (defaults are fine for local development):
```env
MONGO_USER=admin
MONGO_PASSWORD=admin
DEBUG=False
ENVIRONMENT=production
SECRET_KEY=your-secret-key
```

### 3. Build and Run All Services

```bash
docker-compose up -d
```

This will:
- Pull MongoDB 7.0 Alpine image
- Build backend FastAPI container
- Build frontend Flutter+Nginx container
- Start all services with health checks

### 4. Verify Services Are Running

```bash
# Check all containers
docker-compose ps

# View logs (all services)
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb
```

### 5. Access the Application

- **Frontend**: http://localhost
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs
- **MongoDB**: localhost:27017 (admin/admin)

## Docker Architecture

```
┌─────────────────────────────────────────────────┐
│            VYNK Application Stack               │
├─────────────────────────────────────────────────┤
│                                                 │
│  Frontend (Nginx)          Backend (FastAPI)    │
│  Port 80 ─────────────────> Port 8000           │
│  • Flutter web build        • Python API        │
│  • Static files served      • 4 worker threads  │
│  • API proxy to backend     • Gunicorn server   │
│                                                 │
│  └──────────────┬──────────────┘                │
│                 │                               │
│            MongoDB                             │
│            Port 27017                           │
│            • Database                           │
│            • Persistent volume                  │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Common Commands

### Start Services

```bash
# Start in background
docker-compose up -d

# Start with live logs
docker-compose up
```

### Stop Services

```bash
# Stop all services (data persists)
docker-compose stop

# Stop and remove containers (data persists in volumes)
docker-compose down

# Stop, remove containers, and delete volumes (⚠️ data lost)
docker-compose down -v
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb

# Last 20 lines
docker-compose logs --tail=20
```

### Rebuild Services

```bash
# Rebuild all containers after code changes
docker-compose build

# Rebuild and restart all services
docker-compose up -d --build

# Rebuild specific service
docker-compose build backend
docker-compose up -d backend
```

### Access Container Shell

```bash
# Backend shell
docker-compose exec backend /bin/bash

# Frontend shell
docker-compose exec frontend /bin/sh

# MongoDB shell
docker-compose exec mongodb mongosh -u admin -p admin
```

### Database Management

```bash
# Connect to MongoDB
docker-compose exec mongodb mongosh -u admin -p admin

# MongoDB commands inside container:
# use vynk
# db.users.find()
# db.users.count()
```

## Troubleshooting

### Services Not Starting

```bash
# Check container logs
docker-compose logs

# Restart services
docker-compose restart

# Full rebuild
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Port Already in Use

```bash
# If port 80 is in use, modify docker-compose.yml:
# Change "80:80" to "8080:80"
# Then access: http://localhost:8080

# If port 8000 is in use:
# Change "8000:8000" to "8001:8000"
# Access API at: http://localhost:8001
```

### Database Connection Errors

```bash
# Check MongoDB is running
docker-compose ps mongodb

# Force restart MongoDB
docker-compose restart mongodb

# Rebuild with fresh volume
docker-compose down -v
docker-compose up -d
```

### Frontend Not Loading

```bash
# Rebuild frontend container
docker-compose build front-end --no-cache
docker-compose up -d frontend

# Check nginx logs
docker-compose logs frontend
```

### Backend API Errors

```bash
# View detailed backend logs
docker-compose logs -f backend

# Rebuild backend
docker-compose build backend --no-cache
docker-compose up -d backend
```

## Production Deployment

### AWS Elastic Container Service (ECS)

```bash
# Tag images for AWS ECR
docker tag vynk-backend:latest YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/vynk-backend:latest
docker tag vynk-frontend:latest YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/vynk-frontend:latest

# Push to ECR (after AWS CLI setup)
docker push YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/vynk-backend:latest
docker push YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/vynk-frontend:latest
```

### Docker Hub

```bash
# Tag images
docker tag vynk-backend:latest yourusername/vynk-backend:latest
docker tag vynk-frontend:latest yourusername/vynk-frontend:latest

# Login to Docker Hub
docker login

# Push images
docker push yourusername/vynk-backend:latest
docker push yourusername/vynk-frontend:latest
```

### Heroku

```bash
# Create app
heroku create your-app-name

# Set environment variables
heroku config:set SECRET_KEY=your-secret-key
heroku config:set MONGO_USER=admin
heroku config:set MONGO_PASSWORD=admin

# Deploy via Git
git push heroku main
```

### Railway, Render, or DigitalOcean

Use the Docker Compose file directly on these platforms:
1. Push repository to GitHub
2. Connect repository to platform
3. Platform auto-detects `docker-compose.yml`
4. Services start automatically

## File Structure

```
Vync/
├── docker-compose.yml          # Service orchestration
├── .dockerignore               # Docker build excludes
├── .env.example                # Environment template
├── backend/
│   ├── Dockerfile              # Backend build config
│   ├── .dockerignore           # Backend build excludes
│   ├── requirements.txt        # Python dependencies
│   ├── app.py                  # FastAPI entry point
│   ├── routes/                 # API endpoints
│   ├── database/               # MongoDB setup
│   └── services/               # Business logic
├── frontend/
│   ├── Dockerfile              # Frontend build config
│   ├── nginx.conf              # Nginx configuration
│   ├── .dockerignore           # Frontend build excludes
│   ├── pubspec.yaml            # Flutter dependencies
│   ├── lib/                    # Flutter source code
│   └── build/web/              # Built web assets
└── DOCKER_README.md            # This file
```

## Environment Variables

### MongoDB
- `MONGO_USER` - Database username (default: admin)
- `MONGO_PASSWORD` - Database password (default: admin)

### Backend
- `DEBUG` - Debug mode (True/False)
- `ENVIRONMENT` - Environment name (development/production)
- `SECRET_KEY` - JWT signing key (⚠️ change in production)
- `ALGORITHM` - JWT algorithm (default: HS256)
- `ACCESS_TOKEN_EXPIRE_MINUTES` - Token expiry (default: 30)
- `CORS_ORIGINS` - Allowed origins (default: *)

## Performance Tuning

### Increase Backend Workers

Edit `docker-compose.yml` backend service and modify Dockerfile CMD:
```dockerfile
CMD ["gunicorn", "-w", "8", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000", "app:app"]
```

### Enable Caching

Modify `frontend/nginx.conf` - already configured with 1-year cache for static assets.

### Database Optimization

Create indexes in MongoDB (already done in backend initialization).

## Security Checklist

- [ ] Change `SECRET_KEY` in `.env`
- [ ] Change MongoDB credentials (`MONGO_USER`, `MONGO_PASSWORD`)
- [ ] Use HTTPS in production (configure reverse proxy)
- [ ] Set `DEBUG=False` in production
- [ ] Configure proper `CORS_ORIGINS` (not `*` in production)
- [ ] Use environment secrets manager (AWS Secrets Manager, etc.)
- [ ] Regular security updates (`docker pull`, rebuild images)

## Monitoring

### Health Checks

All services include health checks:
```bash
docker-compose ps
# Shows STATE column with healthy/unhealthy status
```

### Resource Usage

```bash
# Monitor container resource usage
docker stats

# Monitor specific service
docker stats vynk-backend
```

### Log Aggregation

```bash
# Save logs to file for analysis
docker-compose logs > logs.txt

# Follow logs in real-time with timestamps
docker-compose logs -f --timestamps
```

## Support

For issues:
1. Check Docker documentation: https://docs.docker.com
2. View logs: `docker-compose logs -f`
3. Restart services: `docker-compose restart`
4. Rebuild: `docker-compose build --no-cache`

---

**Last Updated**: April 6, 2026
**Docker Version**: 3.8 Compose Format
