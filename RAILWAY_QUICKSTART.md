# 🚀 Railway Deployment Quick Start

## 3-Minute Setup

### Step 1: Prerequisites (2 min)
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login
```

### Step 2: Push to Git (1 min)
```bash
# Make sure your code is in a Git repo
cd /Users/ayush9085/Documents/Vync
git add .
git commit -m "Ready for Railway"
git push  # to GitHub, GitLab, or Bitbucket
```

### Step 3: Deploy (Interactive)
```bash
./deploy_railway.sh
```

---

## What Gets Deployed?

| Component | Where | Tech |
|-----------|-------|------|
| **Backend** | Railway | FastAPI + Python |
| **Frontend** | Railway | Flutter Web (static) |
| **Database** | MongoDB Atlas or Railway | MongoDB |

---

## URLs After Deployment

```
Backend:  https://vynk-backend.railway.app
Frontend: https://vynk-frontend.railway.app
API:      https://vynk-backend.railway.app/docs
```

---

## Configuration Checklist

- [ ] Git repository ready
- [ ] Railway account created
- [ ] Railway CLI installed & logged in
- [ ] MongoDB Atlas (or Railway MongoDB) ready
- [ ] MONGODB_URL added to Railway Variables
- [ ] CORS updated in backend
- [ ] API base URL updated in frontend
- [ ] Flutter web built
- [ ] Code pushed to Git
- [ ] Backend deployed
- [ ] Frontend deployed
- [ ] Test end-to-end

---

## Cost Breakdown

- Backend: **$5/month** (always on)
- Frontend: **$5/month** (always on)
- MongoDB: **Free** (Atlas) or $5/month (Railway)
- **Total: ~$10-15/month**

---

## Common Issues & Fixes

### Build Fails
```bash
railway logs  # Check logs
```

### Can't Connect to Database
1. Go to MongoDB Atlas
2. Verify IP whitelist includes Railway IPs
3. Test connection string locally

### CORS Errors
1. Update `allow_origins` in `backend/app.py`
2. Add frontend URL: `https://vynk-frontend.railway.app`
3. Redeploy backend

### Frontend Shows 404
1. Ensure Flutter web built: `flutter build web --release`
2. Verify `frontend/build/web/index.html` exists
3. Check static file serving in backend

---

## Deploy from Local

### Option 1: Via Web Dashboard (Recommended)
1. Go to **railway.app**
2. Click **"New Project"**
3. Select **"GitHub"**
4. Choose your **vynk** repo
5. Wait for auto-detection
6. Click **"Deploy"**

### Option 2: Via CLI
```bash
railway link          # Link to project
railway up            # Deploy
railway logs          # View logs
```

### Option 3: Via Script
```bash
./deploy_railway.sh   # Interactive menu
```

---

## After Deployment

### Monitor Logs
```bash
railway logs -t backend
railway logs -t frontend
```

### View Metrics
- Railway Dashboard → Service → Metrics
- CPU, Memory, Network usage

### Set Up Auto-Deploy
- Railway Dashboard → Service → Deployments
- Enable "Deploy on Push" for GitHub branch

### Add Custom Domain
- Railway Dashboard → Service → Custom Domain
- Point DNS to Railway domain

---

## Environment Variables

See `.railway.env.example` for template.

Add in Railway Dashboard:
```
MONGODB_URL=mongodb+srv://...
PYTHONUNBUFFERED=1
ENVIRONMENT=production
```

---

## Useful Commands

```bash
# List all services
railway services

# View service logs
railway logs -t backend

# View environment variables
railway variables

# Open dashboard
railway open

# View status
railway status

# Redeploy service
railway redeploy
```

---

## Testing After Deploy

```bash
# Test backend health
curl https://YOUR_BACKEND_URL/health

# Test API
curl https://YOUR_BACKEND_URL/docs

# Test frontend
open https://YOUR_FRONTEND_URL
```

---

## Rollback

If something breaks:

```bash
# View deployment history
railway deployments

# Rollback to previous
railway rollback <deployment-id>
```

---

## Support

- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.railway.app
- FastAPI Deploy: https://fastapi.tiangolo.com/deployment/

---

**Ready? Run:** `./deploy_railway.sh`
