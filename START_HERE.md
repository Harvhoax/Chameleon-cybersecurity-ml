# 🚀 Chameleon Quick Start Guide

## ✅ INTEGRATED MODE (Recommended)

Everything runs on **one port (8000)** - Frontend + Backend together!

---

## 🎯 Quick Commands

### Start Integrated Server (Development)
```bash
npm run start:integrated
```
**Access at:** http://localhost:8000

### Start Production Server
```bash
npm run start:production
```
**Access at:** http://localhost:8000

### Build Only
```bash
npm run build
```

---

## 📋 All Available Commands

| Command | What It Does | Port |
|---------|--------------|------|
| `npm run start:integrated` | **Dev mode - integrated** | 8000 |
| `npm run start:production` | **Production - integrated** | 8000 |
| `npm start` | Separate dev servers | 5173 + 8000 |
| `npm run build` | Build frontend | - |
| `build.bat` / `./build.sh` | Build script | - |

---

## 🔧 First Time Setup

```bash
# 1. Install all dependencies
npm run install:all

# 2. Start integrated server
npm run start:integrated

# 3. Open browser
# http://localhost:8000

# 4. Login
# Username: admin
# Password: chameleon2024
```

---

## 🌐 Access Points

| Service | URL |
|---------|-----|
| **Frontend** | http://localhost:8000 |
| **API** | http://localhost:8000/api/* |
| **API Docs** | http://localhost:8000/docs |
| **Health Check** | http://localhost:8000/api/health |

---

## 📊 Integration Status

```
✅ FULLY INTEGRATED

┌─────────────────────────────────┐
│   Backend (Port 8000)           │
│   ├── Frontend (from dist/)     │
│   └── API (/api/*)              │
└─────────────────────────────────┘

Single URL: http://localhost:8000
```

---

## 🎨 Development Modes

### Integrated Mode (Single Port)
```bash
npm run start:integrated
```
- ✅ Everything on port 8000
- ✅ No CORS issues
- ✅ Production-like setup
- ❌ No frontend hot reload

### Separate Mode (Two Ports)
```bash
npm start
```
- ✅ Frontend hot reload
- ✅ Faster frontend development
- ❌ CORS configuration needed
- ❌ Two URLs to manage

---

## 🚢 Deployment

### Quick Deploy
```bash
# 1. Build
npm run build

# 2. Start server
cd Backend
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4

# 3. Done! Access at http://your-server:8000
```

### Docker Deploy
```bash
docker build -t chameleon .
docker run -p 8000:8000 chameleon
```

---

## 📖 Documentation

- **INTEGRATED_DEPLOYMENT.md** - Full integration guide
- **BUILD.md** - Build commands reference
- **QUICK_COMMANDS.md** - Command reference
- **README.md** - Project overview

---

## 🔐 Default Credentials

```
Username: admin
Password: chameleon2024
```

⚠️ **Change these in production!**

---

## ⚡ Quick Test

```bash
# Start server
npm run start:integrated

# In another terminal, test:
curl http://localhost:8000/api/health

# Should return:
# {"status":"healthy","timestamp":"..."}
```

---

## 🎉 You're Ready!

```bash
npm run start:integrated
```

Then open: **http://localhost:8000**

---

**Status:** ✅ Integrated and Ready
**Port:** 8000 (single port for everything)
**Mode:** Backend serves frontend from dist/
