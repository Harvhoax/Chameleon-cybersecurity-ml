# Integrate Frontend and Backend via dist Directory

## Current Status: ❌ NOT INTEGRATED

The frontend and backend are currently **separate**:
- Frontend: Runs on port 5173 (dev) or deployed separately (prod)
- Backend: Runs on port 8000
- Communication: API calls with CORS

## Option 1: Keep Separated (Current - Recommended)

### Architecture
```
┌─────────────────┐         ┌─────────────────┐
│   Frontend      │  HTTP   │    Backend      │
│   (Vite/React)  │ ──────> │   (FastAPI)     │
│   Port 5173     │  CORS   │   Port 8000     │
└─────────────────┘         └─────────────────┘
```

### Pros
- ✅ Easier development (hot reload)
- ✅ Can scale independently
- ✅ Deploy to different servers
- ✅ Frontend on CDN, backend on server
- ✅ Better performance (CDN caching)

### Cons
- ❌ Need to manage CORS
- ❌ Two deployment processes
- ❌ Two URLs to manage

### Current Commands
```bash
# Development
npm start                    # Runs both separately

# Production Build
npm run build               # Builds frontend to dist/

# Deploy
# 1. Deploy frontend/dist/ to web server/CDN
# 2. Deploy Backend/ to Python server
```

---

## Option 2: Integrate via Backend Serving Frontend ✨

### Architecture
```
┌─────────────────────────────────────┐
│         Backend (FastAPI)           │
│         Port 8000                   │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  Static Files (frontend/dist)│  │
│  │  - index.html                │  │
│  │  - assets/*.js               │  │
│  │  - assets/*.css              │  │
│  └──────────────────────────────┘  │
│                                     │
│  API Routes: /api/*                 │
│  Frontend: /*                       │
└─────────────────────────────────────┘
```

### Implementation Steps

#### 1. Update Backend to Serve Frontend

Add to `Backend/main.py`:

```python
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

# ... existing code ...

# Serve static files from frontend/dist
frontend_dist = os.path.join(os.path.dirname(__file__), "..", "frontend", "dist")

if os.path.exists(frontend_dist):
    # Mount static assets
    app.mount("/assets", StaticFiles(directory=os.path.join(frontend_dist, "assets")), name="assets")
    
    # Serve index.html for all non-API routes (SPA routing)
    @app.get("/{full_path:path}")
    async def serve_frontend(full_path: str):
        # If it's an API route, let FastAPI handle it
        if full_path.startswith("api/"):
            raise HTTPException(status_code=404, detail="Not found")
        
        # Check if file exists
        file_path = os.path.join(frontend_dist, full_path)
        if os.path.exists(file_path) and os.path.isfile(file_path):
            return FileResponse(file_path)
        
        # Otherwise serve index.html (for SPA routing)
        return FileResponse(os.path.join(frontend_dist, "index.html"))
```

#### 2. Update Frontend API Base URL

Update `frontend/.env`:

```env
# For integrated deployment (same origin)
VITE_API_BASE_URL=

# Or use relative URLs
VITE_API_BASE_URL=/
```

Update `frontend/src/services/api.js`:

```javascript
// For integrated deployment, use relative URLs
const API_URL = import.meta.env.VITE_API_BASE_URL || '';
```

#### 3. Update Build Process

Update `package.json`:

```json
{
  "scripts": {
    "build": "npm run build:frontend && npm run integrate",
    "build:frontend": "cd frontend && npm run build",
    "integrate": "echo Frontend integrated with backend - serve from Backend/",
    "start:integrated": "cd Backend && uvicorn main:app --reload"
  }
}
```

#### 4. Build and Run

```bash
# Build frontend
npm run build

# Start integrated server
cd Backend
uvicorn main:app --host 0.0.0.0 --port 8000

# Access everything at http://localhost:8000
```

### Pros
- ✅ Single URL/port
- ✅ No CORS issues
- ✅ Simpler deployment (one server)
- ✅ Easier for small projects

### Cons
- ❌ Backend serves static files (not optimal)
- ❌ No CDN benefits
- ❌ Harder to scale frontend separately
- ❌ Need to rebuild frontend for changes

---

## Option 3: Reverse Proxy (Production Best Practice)

### Architecture
```
┌─────────────────────────────────────┐
│         Nginx Reverse Proxy         │
│         Port 80/443                 │
│                                     │
│  /          → Frontend (Static)     │
│  /api/*     → Backend (FastAPI)     │
└─────────────────────────────────────┘
         │                    │
         ▼                    ▼
┌─────────────┐      ┌─────────────┐
│  Frontend   │      │   Backend   │
│  (Static)   │      │  Port 8000  │
└─────────────┘      └─────────────┘
```

### Nginx Configuration

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # Serve frontend static files
    location / {
        root /path/to/frontend/dist;
        try_files $uri $uri/ /index.html;
    }
    
    # Proxy API requests to backend
    location /api {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### Pros
- ✅ Best performance
- ✅ Single domain (no CORS)
- ✅ Can cache static files
- ✅ SSL termination
- ✅ Load balancing
- ✅ Professional setup

### Cons
- ❌ Requires Nginx/Apache
- ❌ More complex setup
- ❌ Need server configuration access

---

## Recommendation

### For Development: **Option 1 (Current - Separated)**
```bash
npm start  # Runs both with hot reload
```

### For Production: **Option 3 (Reverse Proxy)**
```bash
# Build
npm run build

# Deploy frontend/dist/ to web server
# Deploy Backend/ to application server
# Configure Nginx reverse proxy
```

### For Simple Deployment: **Option 2 (Integrated)**
```bash
# Build and integrate
npm run build

# Run single server
cd Backend && uvicorn main:app --host 0.0.0.0 --port 8000
```

---

## Current Status Summary

| Aspect | Status |
|--------|--------|
| **Integration** | ❌ Not integrated (separate) |
| **Frontend Port** | 5173 (dev) |
| **Backend Port** | 8000 |
| **Communication** | API calls with CORS |
| **Deployment** | Separate (frontend/dist + Backend/) |
| **Recommended** | Keep separated for flexibility |

---

## Quick Integration Script

If you want to integrate, run:

```bash
# Create integration script
npm run integrate-backend
```

This will:
1. Update Backend/main.py to serve frontend
2. Update frontend API configuration
3. Build frontend
4. Test integrated deployment

---

**Last Updated:** 2025-11-23
**Current Architecture:** Separated (Recommended)
**Integration Status:** ❌ Not integrated via dist
