# Railway Deployment Guide for Vynk

## Prerequisites
- Railway account (sign up at railway.app)
- Git repository (GitHub, GitLab, or Bitbucket)
- MongoDB Atlas account (for database) or use Railway's MongoDB

## Step 1: Push Code to Git

```bash
cd /Users/ayush9085/Documents/Vync
git init
git add .
git commit -m "Initial commit: Vynk dating app"
git remote add origin https://github.com/YOUR_USERNAME/vynk.git
git push -u origin main
```

## Step 2: Deploy to Railway

### Option A: Via Railway CLI (Fastest)

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Create new project
railway init

# Link to your Git repo (Railway will offer this option)
# Or manually in railway.app

# Deploy
railway up
```

### Option B: Via Railway Dashboard (Web)

1. Go to railway.app
2. Click "New Project"
3. Select "GitHub" and authorize
4. Select your `vynk` repository
5. Railway auto-detects Python project
6. Click "Deploy"

## Step 3: Configure Environment Variables

In Railway Dashboard:
1. Go to your project
2. Click "Variables" tab
3. Add these variables:

```
MONGODB_URL=mongodb+srv://USERNAME:PASSWORD@cluster.mongodb.net/vynk
PYTHONUNBUFFERED=1
```

Or if using Railway's MongoDB:
- Add "MongoDB" service from Railway Marketplace
- It auto-generates `MONGODB_URL`

## Step 4: Configure Database

### Option A: MongoDB Atlas (Recommended)

```bash
# Go to mongodb.com/cloud/atlas
# 1. Create free cluster
# 2. Create user with credentials
# 3. Whitelist all IPs (0.0.0.0/0)
# 4. Copy connection string
# 5. Add to Railway variables as MONGODB_URL
```

### Option B: Railway MongoDB

In Railway Dashboard:
1. Click "Add Service" → "Marketplace"
2. Select "MongoDB"
3. Add to project
4. Auto-generated `MONGODB_URL` available

## Step 5: Deploy Frontend

### Option A: Serve from Backend (Simplest)

The backend's `http.server` on port 8080 can serve static files.

1. Build Flutter web:
```bash
cd frontend
flutter pub get
flutter build web --release
```

2. Copy `frontend/build/web/*` to backend static folder:
```bash
mkdir -p backend/static
cp -r frontend/build/web/* backend/static/
```

3. Update `backend/app.py` to serve static files:
```python
from fastapi.staticfiles import StaticFiles

app.mount("/", StaticFiles(directory="backend/static", html=True), name="static")
```

4. Push to Git and Railway auto-redeploys

### Option B: Separate Frontend Deployment (Recommended)

1. Create `frontend/railway.json`:
```json
{
  "build": {
    "builder": "nixpacks"
  },
  "deploy": {
    "startCommand": "python -m http.server $PORT"
  }
}
```

2. Create `frontend/Procfile`:
```
web: python -m http.server $PORT
```

3. Build and deploy:
```bash
cd frontend
flutter build web --release
```

4. Deploy as separate service:
   - Railway Dashboard → Add Service → GitHub
   - Select `frontend` folder as root directory

## Step 6: Configure CORS for Frontend-Backend Communication

In `backend/app.py`, update CORS:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8080",
        "http://localhost:3000",
        "https://YOUR_RAILWAY_FRONTEND_URL.railway.app",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Step 7: Update Frontend API Base URL

In `frontend/lib/services/api_service.dart`:

```dart
class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://YOUR_BACKEND_URL.railway.app',
  );
```

Or create a config file:
```dart
const String apiBaseUrl = 'https://vynk-backend.railway.app';
```

## Step 8: Verify Deployment

### Backend Health Check
```bash
curl https://YOUR_BACKEND_URL.railway.app/health
```

### Frontend Status
```bash
open https://YOUR_FRONTEND_URL.railway.app
```

## Step 9: Custom Domain (Optional)

In Railway Dashboard:
1. Go to Service Settings
2. Add "Custom Domain"
3. Update DNS records at your domain registrar
4. Point to Railway domain

## Troubleshooting

### Build Fails
```bash
# Check logs in Railway Dashboard
railway logs
```

### Database Connection Error
```bash
# Verify MONGODB_URL in Variables
# Check MongoDB IP whitelist
# Test connection locally: 
# python -c "from motor.motor_asyncio import AsyncIOMotorClient; print(AsyncIOMotorClient(MONGODB_URL))"
```

### CORS Errors
- Add frontend URL to `allow_origins` in backend
- Redeploy backend

### Static Files Not Loading
- Ensure `frontend/build/web/` exists
- Check file permissions
- Use Railway logs

## Environment Variables for Production

```
# Backend
MONGODB_URL=mongodb+srv://user:pass@cluster.mongodb.net/vynk
PYTHONUNBUFFERED=1
ENVIRONMENT=production

# Frontend (if separate deployment)
API_BASE_URL=https://vynk-backend.railway.app
```

## Monitoring & Logs

```bash
# View logs
railway logs -t backend

# View deployment status
railway status

# View variables
railway variables
```

## Cost Breakdown

| Service | Cost |
|---------|------|
| Backend (Python) | $5-10/month |
| Frontend (Static) | $5-10/month |
| MongoDB | Free (Atlas) or $5/month (Railway) |
| **Total** | **~$10-20/month** |

## Next Steps

1. ✅ Set up Git repository
2. ✅ Create Railway project
3. ✅ Configure database
4. ✅ Deploy backend
5. ✅ Deploy frontend
6. ✅ Update CORS & API URLs
7. ✅ Test end-to-end
8. ✅ Monitor logs
9. ✅ Add custom domain (optional)
10. ✅ Set up CI/CD (auto-deploy on push)

## Useful Links

- Railway Docs: https://docs.railway.app
- Railway CLI: https://docs.railway.app/cli/commands
- MongoDB Atlas: https://www.mongodb.com/cloud/atlas
- FastAPI Deployment: https://fastapi.tiangolo.com/deployment/
- Flutter Web Build: https://flutter.dev/docs/deployment/web

---

**Questions?** Check Railway's docs or test locally first with `./run_all.sh`
