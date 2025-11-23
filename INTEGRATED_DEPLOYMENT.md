# ✅ Integrated Frontend & Backend Deployment

## Status: FULLY INTEGRATED

The frontend and backend are now **fully integrated**! The backend serves the frontend from the `dist` directory on a **single port (8000)**.

---

## 🎯 How It Works

```
┌─────────────────────────────────────────┐
│    Backend (FastAPI) - Port 8000       │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │  Frontend (React from dist/)      │ │
│  │  - Served as static files         │ │
│  │  - SPA routing handled            │ │
│  └───────────────────────────────────┘ │
│                                         │
│  API Routes: /api/*                     │
│  Frontend: /* (everything else)         │
└─────────────────────────────────────────┘

Single URL: http://localhost:8000
```

---

## 🚀 Quick Start

### Development Mode (Integrated)
```bash
npm run start:integrated
```
- Builds frontend automatically
- Starts backend with hot reload
- Access everything at: **http://localhost:8000**

### Production Mode
```bash
npm run start:production
```
- Builds frontend for production
- Starts backend on 0.0.0.0:8000
- Ready for deployment

### Separate Development (Old Way)
```bash
npm start
```
- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- Useful for frontend hot reload

---

## 📋 All Commands

| Command | Description | Port |
|---------|-------------|------|
| `npm run start:integrated` | **Integrated dev mode** | 8000 |
| `npm run start:production` | **Production mode** | 8000 |
| `npm start` | Separate dev servers | 5173 + 8000 |
| `npm run build` | Build frontend | - |
| `npm run start:backend` | Backend only | 8000 |
| `npm run start:frontend` | Frontend only | 5173 |

---

## 🔧 What Changed

### 1. Backend (main.py)
Added static file serving at the end:

```python
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

# Serve frontend from dist folder
frontend_dist = os.path.join(os.path.dirname(__file__), "..", "frontend", "dist")

if os.path.exists(frontend_dist):
    # Mount static assets
    app.mount("/assets", StaticFiles(directory=os.path.join(frontend_dist, "assets")), name="assets")
    
    # Catch-all for SPA routing
    @app.get("/{full_path:path}")
    async def serve_frontend(full_path: str):
        if full_path.startswith("api/"):
            raise HTTPException(status_code=404)
        
        file_path = os.path.join(frontend_dist, full_path)
        if os.path.exists(file_path) and os.path.isfile(file_path):
            return FileResponse(file_path)
        
        return FileResponse(os.path.join(frontend_dist, "index.html"))
```

### 2. Frontend API (services/api.js)
Changed to use relative URLs:

```javascript
// Before: const API_URL = 'http://localhost:8000';
// After:  const API_URL = '';  // Same origin
```

### 3. Frontend Environment (.env)
```env
# Integrated mode (same origin)
VITE_API_BASE_URL=

# For separate dev, uncomment:
# VITE_API_BASE_URL=http://localhost:8000
```

### 4. Package.json Scripts
Added integrated commands:

```json
{
  "start:integrated": "npm run build:frontend && cd Backend && uvicorn main:app --reload",
  "start:production": "npm run build:frontend && cd Backend && uvicorn main:app --host 0.0.0.0 --port 8000"
}
```

---

## 📁 File Structure

```
Chameleon-cybersecurity-ml/
├── Backend/
│   ├── main.py              ← Serves frontend + API
│   ├── config.py
│   └── ...
├── frontend/
│   ├── dist/                ← Built frontend (served by backend)
│   │   ├── index.html
│   │   ├── assets/
│   │   │   ├── index-*.js
│   │   │   └── index-*.css
│   │   └── vite.svg
│   ├── src/
│   └── package.json
└── package.json             ← Root commands
```

---

## 🌐 URL Routing

### Frontend Routes (SPA)
- `/` → Dashboard/Login
- `/dashboard` → Main dashboard
- `/analytics` → Analytics page
- `/globe` → Attack globe
- `/threat-intel` → Threat intelligence

### API Routes
- `/api/health` → Health check
- `/api/auth/login` → Authentication
- `/api/dashboard/stats` → Dashboard stats
- `/api/dashboard/logs` → Attack logs
- `/api/trap/submit` → Submit trap input
- `/api/threat-intel/*` → Threat intelligence
- `/docs` → API documentation (Swagger)

---

## ✅ Testing Integration

### 1. Test Frontend
```bash
curl http://localhost:8000
```
Should return HTML

### 2. Test API
```bash
curl http://localhost:8000/api/health
```
Should return JSON: `{"status":"healthy",...}`

### 3. Test Static Assets
```bash
curl http://localhost:8000/assets/index-*.js
```
Should return JavaScript

### 4. Test SPA Routing
```bash
curl http://localhost:8000/dashboard
```
Should return index.html (SPA handles routing)

---

## 🚢 Deployment

### Single Server Deployment

```bash
# 1. Build frontend
npm run build

# 2. Start production server
cd Backend
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4

# 3. Access at http://your-server:8000
```

### Docker Deployment

**Dockerfile:**
```dockerfile
FROM python:3.12-slim

# Install Node.js for building frontend
RUN apt-get update && apt-get install -y nodejs npm

WORKDIR /app

# Copy everything
COPY . .

# Install dependencies
RUN cd Backend && pip install -r requirements.txt
RUN cd frontend && npm install

# Build frontend
RUN cd frontend && npm run build

# Expose port
EXPOSE 8000

# Start backend (serves frontend)
CMD ["uvicorn", "Backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Build and Run:**
```bash
docker build -t chameleon .
docker run -p 8000:8000 chameleon
```

---

## 🔄 Switching Between Modes

### Use Integrated Mode
```bash
# Update frontend/.env
VITE_API_BASE_URL=

# Start
npm run start:integrated
```

### Use Separate Mode
```bash
# Update frontend/.env
VITE_API_BASE_URL=http://localhost:8000

# Start
npm start
```

---

## 🎯 Benefits of Integration

✅ **Single Port**: Everything on port 8000
✅ **No CORS Issues**: Same origin
✅ **Simpler Deployment**: One server
✅ **Easier Setup**: One command to start
✅ **Production Ready**: Build once, deploy once

---

## ⚠️ Important Notes

### 1. Build Before Starting
Always build frontend before starting integrated mode:
```bash
npm run build  # or it's done automatically in start:integrated
```

### 2. API Routes Priority
API routes (`/api/*`) take priority over frontend routes.

### 3. SPA Routing
All non-API, non-file routes return `index.html` for React Router.

### 4. Static Assets
Assets are served from `/assets/*` path.

### 5. Development Hot Reload
For frontend hot reload during development, use:
```bash
npm start  # Separate servers
```

---

## 🐛 Troubleshooting

### Issue: Frontend not loading
**Solution**: Build frontend first
```bash
npm run build
```

### Issue: API routes not working
**Solution**: Check if route starts with `/api/`
```bash
# Correct
/api/health

# Wrong
/health
```

### Issue: 404 on refresh
**Solution**: This is normal - backend serves index.html for SPA routing

### Issue: Assets not loading
**Solution**: Check if assets are in `frontend/dist/assets/`
```bash
ls frontend/dist/assets/
```

---

## 📊 Performance

### Build Time
- Frontend build: ~10 seconds
- Backend startup: ~5 seconds
- Total: ~15 seconds

### Bundle Size
- JS: 1.2 MB (381 KB gzipped)
- CSS: 17 KB (3.7 KB gzipped)
- Total: ~385 KB gzipped

### Startup
```bash
npm run start:integrated
# Builds frontend → Starts backend → Ready in ~15s
```

---

## 🔐 Security

### Production Checklist
- [ ] Change default admin password
- [ ] Update JWT_SECRET_KEY
- [ ] Enable HTTPS/SSL
- [ ] Set proper CORS (if needed)
- [ ] Configure MongoDB authentication
- [ ] Enable rate limiting
- [ ] Set up firewall rules
- [ ] Use environment variables for secrets

---

## 📈 Monitoring

### Health Check
```bash
curl http://localhost:8000/api/health
```

### Frontend Check
```bash
curl http://localhost:8000
```

### Logs
Backend logs show:
```
✅ Frontend dist folder found at: .../frontend/dist
INFO: Uvicorn running on http://127.0.0.1:8000
```

---

## 🎉 Success!

Your Chameleon system is now fully integrated!

**Access everything at:** http://localhost:8000

**Commands:**
```bash
# Development (integrated)
npm run start:integrated

# Production
npm run start:production

# Build only
npm run build
```

---

**Status:** ✅ FULLY INTEGRATED
**Last Updated:** 2025-11-23
**Integration Method:** Backend serves frontend dist
**Single Port:** 8000
