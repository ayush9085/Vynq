# Railway Deployment Troubleshooting

## App Crashing in 2 Seconds - Root Causes & Solutions

### Common Causes

#### 1. ❌ Missing MONGODB_URL Environment Variable (Most Common)
**Symptom**: App crashes immediately on startup

**Solution**:
1. Go to Railway Dashboard: https://railway.app
2. Select your project → Backend service
3. Click "Variables" tab
4. Add: `MONGODB_URL=mongodb+srv://username:password@cluster.mongodb.net/vynk`
5. Save and wait for auto-redeploy (30-60 seconds)

**How to get MONGODB_URL**:

**Option A - MongoDB Atlas (Recommended)**:
```
1. Visit: https://www.mongodb.com/cloud/atlas
2. Sign up (free account)
3. Create Organization → Create Project → Create Cluster
4. Choose FREE tier
5. Choose your region (closest to Railway datacenter: us-east-1)
6. Click "Create Cluster"
7. Wait 5-10 minutes for cluster to provision
8. Click "Connect" → "Drivers" → "Python" → Copy connection string
9. Replace <username> and <password> with DB user credentials
10. Replace <myFirstDatabase> with "vynk"
```

**Option B - Railway's Built-in MongoDB**:
```
1. Open Railway Dashboard
2. Go to your project
3. Click "+ Add" → Search "MongoDB"
4. Click "MongoDB" and confirm
5. MongoDB service gets added automatically
6. MONGODB_URL is generated in Variables
```

#### 2. ❌ PORT Environment Variable Not Passed Correctly

**Symptom**: App starts but won't listen on Railway's assigned port

**Solution**: Verify `Procfile` contains:
```
web: uvicorn backend.app:app --host 0.0.0.0 --port $PORT
```

Check file:
```bash
cat Procfile
```

#### 3. ❌ Missing Python Dependencies

**Symptom**: ImportError on startup

**Solution**:
1. Ensure `backend/requirements.txt` exists and is complete
2. Check that `motor` (async MongoDB driver) is listed:
   ```
   motor>=3.4.0
   ```
3. Commit and push changes

#### 4. ❌ Incorrect Environment Configuration

**Solution**: Add these Railway Variables:
```
MONGODB_URL=mongodb+srv://user:pass@cluster.mongodb.net/vynk
PYTHONUNBUFFERED=1
JWT_SECRET=your-secret-key-here-minimum-32-chars
CORS_ORIGINS=*
```

#### 5. ❌ Frontend/Backend Path Issues

**Symptom**: 404 errors when accessing frontend

**Solution**: 
- If serving frontend from backend, ensure static files are built:
  ```bash
  flutter build web --release
  ```
- Update `backend/app.py` to mount static files (optional, backend-only approach)

---

## How to View Railway Logs

### Method 1: Railway Dashboard
```
1. Go to https://railway.app
2. Click on your project
3. Select Backend service
4. Click "View Logs" tab
5. See real-time startup errors
```

### Method 2: Railway CLI
```bash
# Install
npm i -g @railway/cli

# Login
railway login

# View logs
railway logs

# Follow logs live
railway logs --follow
```

---

## Step-by-Step Deployment Checklist

- [ ] Code committed to GitHub (`git push origin main`)
- [ ] Railway project created at https://railway.app
- [ ] GitHub repository connected to Railway
- [ ] MongoDB set up (Atlas or Railway)
- [ ] `MONGODB_URL` variable added to Railway
- [ ] `PYTHONUNBUFFERED=1` added to Railway
- [ ] `JWT_SECRET` added to Railway (32+ random characters)
- [ ] Procfile exists with correct command
- [ ] requirements.txt has `motor>=3.4.0`
- [ ] No uncommitted changes locally
- [ ] Deployment triggered (push to main or manual trigger in Railway)

---

## Testing Your Deployment

Once the app is running:

```bash
# Test health endpoint
curl https://your-railway-domain.up.railway.app/health

# Response should be:
# {"status":"healthy","service":"vynk-api"}

# Test API docs
# Open: https://your-railway-domain.up.railway.app/docs
# You should see Swagger UI
```

---

## Common Error Messages & Fixes

### "Connection refused"
→ MongoDB service not running or `MONGODB_URL` not set
**Fix**: Set `MONGODB_URL` environment variable in Railway

### "ModuleNotFoundError: No module named 'motor'"
→ Dependencies not installed
**Fix**: Ensure `motor>=3.4.0` in `requirements.txt`

### "Address already in use"
→ Port conflict (shouldn't happen on Railway)
**Fix**: Restart service in Railway dashboard

### "Cannot connect to MongoDB cluster"
→ IP whitelist or connection string wrong
**Fix**: 
- MongoDB Atlas: Add 0.0.0.0/0 to Network Access
- Check connection string format

### "503 Service Unavailable"
→ App not responding
**Fix**: 
- Check logs in Railway dashboard
- Verify `MONGODB_URL` is set
- Verify `PYTHONUNBUFFERED=1` for proper logging

---

## Performance Optimization

### Reduce Deployment Time
- Set `SKIP_BUILD=1` for backend-only deployments
- Use Railway's PostgreSQL instead of MongoDB for faster queries
- Enable caching in railway.json

### Monitor Resource Usage
- Check Railway dashboard for CPU/memory usage
- Upgrade plan if consistently above 80% usage
- Railway free tier: 512MB RAM, suitable for small apps

---

## Debugging Commands

### Local Testing Before Railway
```bash
# Set environment variable locally
export MONGODB_URL="mongodb+srv://user:pass@cluster.mongodb.net/vynk"
export PYTHONUNBUFFERED=1

# Run backend locally
cd backend
python app.py

# Test endpoint
curl http://localhost:8000/health
```

### Check Deployment Status
```bash
# View latest deployment
railway logs --limit 50

# Check environment variables are set
railway variables

# View service status
railway status
```

---

## Next Steps

1. **Set up MongoDB** (5 minutes)
2. **Add environment variables** to Railway (2 minutes)
3. **Wait for auto-redeploy** (1-2 minutes)
4. **Test health endpoint** (1 minute)
5. **Monitor logs** for any errors

**Total time**: ~10 minutes

---

## Still Having Issues?

Check these in order:
1. View Railway logs: https://railway.app → Your Project → Backend → View Logs
2. Verify `MONGODB_URL` is set (Variables tab)
3. Confirm MongoDB cluster is running
4. Check GitHub shows latest commit (`2fa59b3`)
5. Look for Python syntax errors: `python -m py_compile backend/app.py`

If error persists, share the exact error message from Railway logs.

---

**Last Updated**: 27 April 2026  
**Version**: 1.0
