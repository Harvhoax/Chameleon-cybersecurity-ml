# 🔧 Local Development Fix - Black Screen Issue

## ❌ Problem

Black screen when running locally because:
1. Backend won't start (TensorFlow issue on Windows)
2. Frontend can't connect to backend API
3. No data to display

## ✅ Solution Options

### Option 1: Use Production Backend (Recommended)

Update `frontend/.env` to use your Render backend:

```env
# Point to production backend
VITE_API_BASE_URL=https://your-app.onrender.com
VITE_WS_URL=wss://your-app.onrender.com
```

**Replace `your-app.onrender.com` with your actual Render URL!**

Then start frontend:
```bash
cd frontend
npm run dev
```

Access at: http://localhost:5173

---

### Option 2: Run Frontend Only (Development)

Just develop frontend without backend:

```bash
cd frontend
npm run dev
```

- UI will load
- API calls will fail (expected)
- Good for UI/UX development
- Test component rendering

---

### Option 3: Use Mock Data

Create mock API responses for local development.

---

## 🚀 Quick Fix Steps

### 1. Update Frontend .env

```bash
# Edit frontend/.env
VITE_API_BASE_URL=https://your-render-url.onrender.com
```

### 2. Restart Frontend

```bash
cd frontend
npm run dev
```

### 3. Open Browser

```
http://localhost:5173
```

### 4. Login

- Username: admin
- Password: chameleon2024

---

## 📊 Why This Happens

### Local Backend Issue:
```
TensorFlow 2.16.1 → Not compatible with Windows Python 3.12
Backend fails to start → No API available
Frontend can't fetch data → Black screen
```

### Production (Render):
```
TensorFlow 2.16.1 → Works on Linux Python 3.12 ✅
Backend starts successfully → API available ✅
Frontend fetches data → Dashboard displays ✅
```

---

## 🎯 Recommended Workflow

### For Frontend Development:
```bash
# 1. Point to production backend
# Edit frontend/.env:
VITE_API_BASE_URL=https://your-app.onrender.com

# 2. Start frontend
cd frontend
npm run dev

# 3. Develop and test
# Changes auto-reload
# Uses production data
```

### For Full Stack Development:
```bash
# 1. Make changes locally
# 2. Commit and push
git add .
git commit -m "Your changes"
git push

# 3. Test on Render (auto-deploys)
# https://your-app.onrender.com
```

---

## ✅ What Works Locally

✅ Frontend development
✅ UI/UX changes
✅ Component development
✅ Styling and layout
✅ React Router navigation
✅ State management

❌ Backend API (TensorFlow issue)
❌ ML classification
❌ Database operations
❌ Attack logging

---

## 🔧 Alternative: Fix TensorFlow Locally

If you really want backend to work locally:

### Option A: Downgrade Python
```bash
# Install Python 3.11
# Reinstall dependencies
pip install -r Backend/requirements.txt
```

### Option B: Upgrade TensorFlow
```bash
# Update Backend/requirements.txt
tensorflow==2.17.0  # or later

# Reinstall
pip install -r Backend/requirements.txt
```

### Option C: Use Docker
```bash
# Run backend in Docker container
docker-compose up backend
```

---

## 📝 Summary

**Problem:** Black screen due to backend not starting

**Quick Fix:** Point frontend to production backend

**Steps:**
1. Edit `frontend/.env`
2. Set `VITE_API_BASE_URL=https://your-render-url.onrender.com`
3. Run `cd frontend && npm run dev`
4. Open http://localhost:5173

**Result:** Frontend works with production data! ✅

---

**Status:** ✅ Solution Provided
**Recommended:** Use production backend for local frontend dev
**Production:** Works perfectly on Render
