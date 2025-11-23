# 🚀 Render Deployment - Quick Fix

## ❌ Current Error
```
vite: not found
Build failed
```

## ✅ Solution

### Option 1: Use render.yaml (Easiest)

**Just commit and push these files:**

```bash
git add render.yaml package.json RENDER_DEPLOYMENT.md
git commit -m "Fix Render deployment configuration"
git push
```

Render will automatically use the `render.yaml` configuration and deploy successfully!

---

### Option 2: Manual Configuration in Render Dashboard

If you prefer manual setup:

#### **Build Command:**
```bash
npm run deploy:build
```

Or the full command:
```bash
npm install && cd frontend && npm install --legacy-peer-deps && npm run build && cd ../Backend && pip install -r requirements.txt
```

#### **Start Command:**
```bash
cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

#### **Environment Variables:**
Add in Render dashboard:
- `MONGODB_URL` - Your MongoDB connection string
- `JWT_SECRET_KEY` - Generate with: `openssl rand -hex 32`
- `DATABASE_NAME` - `chameleon_db`

---

## 📋 Step-by-Step (Manual)

1. **Go to Render Dashboard** → Your Service → Settings

2. **Update Build Command:**
   ```bash
   npm run deploy:build
   ```

3. **Update Start Command:**
   ```bash
   cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
   ```

4. **Add Environment Variables:**
   - Click "Environment" tab
   - Add `MONGODB_URL`, `JWT_SECRET_KEY`, `DATABASE_NAME`

5. **Manual Deploy:**
   - Click "Manual Deploy" → "Deploy latest commit"

---

## 🎯 What This Does

### Build Process:
1. ✅ Install root npm dependencies
2. ✅ Install frontend dependencies (with --legacy-peer-deps)
3. ✅ Build frontend (creates dist/)
4. ✅ Install Python dependencies
5. ✅ Ready to start!

### Start Process:
1. ✅ Start backend on Render's assigned port
2. ✅ Backend serves frontend from dist/
3. ✅ Single integrated app!

---

## 🌐 After Deployment

Your app will be available at:
```
https://chameleon-backend.onrender.com
```

**Test it:**
```bash
curl https://your-app.onrender.com/api/health
```

Should return:
```json
{"status":"healthy","timestamp":"..."}
```

---

## 🔧 Files Updated

1. **render.yaml** - Render configuration (auto-detected)
2. **package.json** - Updated build command
3. **RENDER_DEPLOYMENT.md** - Full deployment guide

---

## ⚡ Quick Test Locally

Before pushing, test the build command:

```bash
npm run build
```

Should complete without errors and create `frontend/dist/`

---

## 🐛 Still Having Issues?

### Check Render Logs:
1. Render Dashboard → Your Service → Logs
2. Look for specific error messages

### Common Issues:

**"vite: not found"**
- Solution: Build command must include `cd frontend && npm install`

**"Module not found" (Python)**
- Solution: Build command must include `pip install -r requirements.txt`

**"Port already in use"**
- Solution: Use `$PORT` variable in start command

---

## 📞 Need Help?

1. Check `RENDER_DEPLOYMENT.md` for full guide
2. Review Render build logs
3. Test locally with `npm run start:production`

---

**Status:** ✅ Ready to Deploy
**Method:** Automatic with render.yaml
**Build Time:** ~2-3 minutes
**Deploy:** Just push to GitHub!
