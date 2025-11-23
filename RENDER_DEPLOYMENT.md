# 🚀 Render Deployment Guide

## Quick Fix for Current Error

The error `vite: not found` means frontend dependencies aren't installed. Here's the fix:

### Option 1: Use render.yaml (Recommended)

I've created a `render.yaml` file. Render will automatically detect and use it.

**Just commit and push:**
```bash
git add render.yaml package.json
git commit -m "Add Render deployment configuration"
git push
```

Render will automatically redeploy with the correct build steps.

---

### Option 2: Manual Configuration in Render Dashboard

If you prefer manual setup, use these settings:

#### **Build Command:**
```bash
npm install && cd frontend && npm install && npm run build && cd ../Backend && pip install -r requirements.txt
```

#### **Start Command:**
```bash
cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

#### **Environment:**
- **Environment:** `Python 3.12`
- **Build Command:** (see above)
- **Start Command:** (see above)

---

## 📋 Complete Render Setup

### Step 1: Create Web Service

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository: `Harvhoax/Chameleon-cybersecurity-ml`
4. Configure settings below

### Step 2: Basic Settings

| Setting | Value |
|---------|-------|
| **Name** | `chameleon-deception` |
| **Region** | Choose closest to you |
| **Branch** | `main` |
| **Root Directory** | (leave empty) |
| **Environment** | `Python 3` |
| **Python Version** | `3.12.0` |

### Step 3: Build & Start Commands

**Build Command:**
```bash
npm install && cd frontend && npm install && npm run build && cd ../Backend && pip install -r requirements.txt
```

**Start Command:**
```bash
cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

### Step 4: Environment Variables

Add these in Render dashboard:

| Key | Value | Notes |
|-----|-------|-------|
| `PYTHON_VERSION` | `3.12.0` | Python version |
| `NODE_VERSION` | `22.16.0` | Node.js version |
| `MONGODB_URL` | `your-mongodb-url` | MongoDB connection string |
| `DATABASE_NAME` | `chameleon_db` | Database name |
| `JWT_SECRET_KEY` | `your-secret-key` | Generate a secure key |
| `PORT` | `8000` | Render sets this automatically |

**Generate JWT Secret:**
```bash
openssl rand -hex 32
```

### Step 5: Deploy

Click **"Create Web Service"** and Render will:
1. Clone your repository
2. Install Node.js dependencies
3. Build frontend
4. Install Python dependencies
5. Start the integrated server

---

## 🔧 Build Process Explained

### What Happens During Build:

```bash
# 1. Install root npm dependencies (concurrently, etc.)
npm install

# 2. Install frontend dependencies
cd frontend && npm install

# 3. Build frontend (creates dist/)
npm run build

# 4. Install Python dependencies
cd ../Backend && pip install -r requirements.txt
```

### What Happens During Start:

```bash
# Start backend (serves frontend from dist/)
cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

---

## 🌐 Access Your Deployment

After deployment, Render provides a URL like:
```
https://chameleon-deception.onrender.com
```

**Access Points:**
- Frontend: `https://your-app.onrender.com/`
- API: `https://your-app.onrender.com/api/`
- API Docs: `https://your-app.onrender.com/docs`
- Health: `https://your-app.onrender.com/api/health`

---

## 📁 File Structure for Render

```
Chameleon-cybersecurity-ml/
├── render.yaml              ← Render configuration (auto-detected)
├── package.json             ← Root npm config
├── Backend/
│   ├── main.py             ← Serves frontend + API
│   ├── requirements.txt    ← Python dependencies
│   └── ...
├── frontend/
│   ├── package.json        ← Frontend dependencies
│   ├── dist/               ← Built frontend (created during build)
│   └── src/
└── ...
```

---

## 🐛 Troubleshooting

### Issue: "vite: not found"
**Cause:** Frontend dependencies not installed
**Fix:** Update build command to include `cd frontend && npm install`

### Issue: "Module not found" (Python)
**Cause:** Python dependencies not installed
**Fix:** Ensure build command includes `pip install -r requirements.txt`

### Issue: "Port already in use"
**Cause:** Not using Render's `$PORT` variable
**Fix:** Use `--port $PORT` in start command

### Issue: Frontend not loading
**Cause:** Frontend not built or wrong path
**Fix:** 
1. Check build logs for frontend build success
2. Ensure `frontend/dist/` exists after build
3. Verify `main.py` serves from correct path

### Issue: MongoDB connection failed
**Cause:** Missing or incorrect `MONGODB_URL`
**Fix:** Add `MONGODB_URL` environment variable in Render dashboard

### Issue: Build timeout
**Cause:** Free tier has limited build time
**Fix:** 
1. Optimize dependencies
2. Consider upgrading plan
3. Use build cache

---

## ⚡ Optimization Tips

### 1. Use Build Cache
Render caches `node_modules` and Python packages between builds.

### 2. Minimize Dependencies
Remove unused packages from `package.json` and `requirements.txt`.

### 3. Use Environment Variables
Store secrets in Render environment variables, not in code.

### 4. Enable Auto-Deploy
Render can auto-deploy on git push:
- Settings → Auto-Deploy → Enable

### 5. Health Checks
Render automatically uses `/api/health` for health checks.

---

## 🔐 Security Checklist

Before deploying to production:

- [ ] Change default admin password
- [ ] Generate secure `JWT_SECRET_KEY`
- [ ] Use MongoDB Atlas with authentication
- [ ] Enable HTTPS (Render does this automatically)
- [ ] Set up proper CORS if needed
- [ ] Review environment variables
- [ ] Enable rate limiting
- [ ] Set up monitoring

---

## 📊 Monitoring

### View Logs
```
Render Dashboard → Your Service → Logs
```

### Health Check
```bash
curl https://your-app.onrender.com/api/health
```

### Metrics
Render provides:
- CPU usage
- Memory usage
- Request count
- Response times

---

## 🔄 Updating Deployment

### Automatic (Recommended)
1. Push to GitHub
2. Render auto-deploys (if enabled)

### Manual
1. Render Dashboard → Your Service
2. Click "Manual Deploy" → "Deploy latest commit"

---

## 💰 Render Plans

### Free Tier
- ✅ Good for testing
- ✅ HTTPS included
- ❌ Spins down after inactivity
- ❌ Limited resources

### Starter ($7/month)
- ✅ Always on
- ✅ More resources
- ✅ Better performance

---

## 📝 render.yaml Configuration

The `render.yaml` file I created includes:

```yaml
services:
  - type: web
    name: chameleon-backend
    env: python
    buildCommand: |
      npm install
      cd frontend && npm install && npm run build && cd ..
      cd Backend && pip install -r requirements.txt
    startCommand: cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
    envVars:
      - key: MONGODB_URL
        sync: false  # Set manually in dashboard
      - key: JWT_SECRET_KEY
        generateValue: true  # Auto-generated
```

---

## 🎯 Quick Deploy Checklist

- [ ] Commit `render.yaml` and updated `package.json`
- [ ] Push to GitHub
- [ ] Create Web Service on Render
- [ ] Set `MONGODB_URL` environment variable
- [ ] Wait for build to complete
- [ ] Test deployment at provided URL
- [ ] Update admin password
- [ ] Enable auto-deploy

---

## 🚀 Alternative: Deploy Button

Add this to your README.md for one-click deploy:

```markdown
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/Harvhoax/Chameleon-cybersecurity-ml)
```

---

## 📞 Support

If issues persist:
1. Check Render logs
2. Review build output
3. Test locally with `npm run start:production`
4. Contact Render support

---

## ✅ Success Indicators

Your deployment is successful when:
- ✅ Build completes without errors
- ✅ Service shows "Live" status
- ✅ Health check returns 200 OK
- ✅ Frontend loads at root URL
- ✅ API responds at /api/health

---

**Status:** Ready for Render Deployment
**Last Updated:** 2025-11-23
**Build Command:** `npm install && cd frontend && npm install && npm run build && cd ../Backend && pip install -r requirements.txt`
**Start Command:** `cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT`
