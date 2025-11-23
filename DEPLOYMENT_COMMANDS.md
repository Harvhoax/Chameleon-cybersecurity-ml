# 🚀 Deployment Commands Reference

## 📦 New Deployment Commands

I've added specialized commands for deployment that install ALL dependencies:

### **`npm run deploy:install`**
Installs all dependencies (root, frontend, backend)

```bash
npm run deploy:install
```

**What it does:**
1. Installs root npm dependencies (`npm install`)
2. Installs frontend dependencies (`cd frontend && npm install --legacy-peer-deps`)
3. Installs backend dependencies (`cd Backend && pip install -r requirements.txt`)

---

### **`npm run deploy:build`**
Complete deployment build (install + build)

```bash
npm run deploy:build
```

**What it does:**
1. Runs `deploy:install` (installs all dependencies)
2. Builds frontend (`npm run build:frontend`)

**Perfect for:** CI/CD pipelines, Render, Docker, etc.

---

## 📋 Complete Command List

### **Deployment Commands (New)**

| Command | Description | Use Case |
|---------|-------------|----------|
| `npm run deploy:install` | Install all dependencies | CI/CD, Render |
| `npm run deploy:build` | Install + build everything | Full deployment |

### **Development Commands**

| Command | Description | Port |
|---------|-------------|------|
| `npm start` | Separate dev servers | 5173 + 8000 |
| `npm run start:integrated` | Integrated dev server | 8000 |
| `npm run start:production` | Production server | 8000 |

### **Build Commands**

| Command | Description |
|---------|-------------|
| `npm run build` | Build frontend only |
| `npm run build:frontend` | Build frontend |
| `npm run build:backend` | Backend check (no build) |

### **Installation Commands**

| Command | Description |
|---------|-------------|
| `npm run install:all` | Install all dependencies |
| `npm run install:frontend` | Install frontend deps |
| `npm run install:backend` | Install backend deps |

### **Individual Service Commands**

| Command | Description |
|---------|-------------|
| `npm run start:frontend` | Frontend only |
| `npm run start:backend` | Backend only |

---

## 🌐 Render Deployment

### **Updated render.yaml**

Now uses the simplified command:

```yaml
buildCommand: npm run deploy:build
```

Instead of the long multi-line command!

### **Manual Render Configuration**

If not using `render.yaml`, use this in Render dashboard:

**Build Command:**
```bash
npm run deploy:build
```

**Start Command:**
```bash
cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

---

## 🐳 Docker Deployment

### **Dockerfile Example**

```dockerfile
FROM python:3.12-slim

# Install Node.js
RUN apt-get update && apt-get install -y nodejs npm

WORKDIR /app

# Copy everything
COPY . .

# Install and build using deploy command
RUN npm run deploy:build

# Expose port
EXPOSE 8000

# Start server
CMD ["sh", "-c", "cd Backend && uvicorn main:app --host 0.0.0.0 --port 8000"]
```

**Build and run:**
```bash
docker build -t chameleon .
docker run -p 8000:8000 chameleon
```

---

## 🔄 CI/CD Pipeline

### **GitHub Actions Example**

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-node@v3
        with:
          node-version: '22'
      
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      
      - name: Install and Build
        run: npm run deploy:build
      
      - name: Deploy
        run: |
          cd Backend
          uvicorn main:app --host 0.0.0.0 --port 8000
```

---

## 📊 Command Comparison

### **Old Way (Manual)**
```bash
# Install root
npm install

# Install frontend
cd frontend
npm install --legacy-peer-deps

# Build frontend
npm run build
cd ..

# Install backend
cd Backend
pip install -r requirements.txt
cd ..
```

### **New Way (One Command)**
```bash
npm run deploy:build
```

Much simpler! 🎉

---

## 🎯 When to Use Each Command

### **Local Development**
```bash
npm run start:integrated
```
- Quick start for development
- Auto-reload enabled
- Single port (8000)

### **Testing Production Build**
```bash
npm run deploy:build
npm run start:production
```
- Test production build locally
- Verify everything works

### **Render/Cloud Deployment**
```bash
# In render.yaml or build command:
npm run deploy:build
```
- Installs everything
- Builds frontend
- Ready to start

### **Docker Build**
```dockerfile
RUN npm run deploy:build
```
- One command in Dockerfile
- Clean and simple

---

## 🔧 Troubleshooting

### **Issue: Dependencies not found**
**Solution:** Use `deploy:install` first
```bash
npm run deploy:install
```

### **Issue: Frontend not building**
**Solution:** Use full `deploy:build`
```bash
npm run deploy:build
```

### **Issue: Python packages missing**
**Solution:** Check if `deploy:install` ran successfully
```bash
npm run deploy:install
cd Backend
pip list
```

---

## 📝 What Each Deploy Command Does

### `npm run deploy:install`
```
1. npm install
   └─> Installs: concurrently, etc.

2. cd frontend && npm install --legacy-peer-deps
   └─> Installs: react, vite, mui, etc.

3. cd Backend && pip install -r requirements.txt
   └─> Installs: fastapi, tensorflow, etc.
```

### `npm run deploy:build`
```
1. npm run deploy:install
   └─> (see above)

2. npm run build:frontend
   └─> cd frontend && npm run build
   └─> Creates: frontend/dist/
```

---

## ✅ Benefits

### **Simplified Deployment**
- ✅ One command instead of many
- ✅ Consistent across platforms
- ✅ Less error-prone
- ✅ Easier to maintain

### **Better CI/CD**
- ✅ Clean pipeline scripts
- ✅ Reusable commands
- ✅ Version controlled
- ✅ Easy to debug

### **Cleaner Configuration**
- ✅ Short render.yaml
- ✅ Simple Dockerfile
- ✅ Clear documentation
- ✅ Easy to understand

---

## 🚀 Quick Reference

**For Render:**
```bash
Build: npm run deploy:build
Start: cd Backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**For Docker:**
```dockerfile
RUN npm run deploy:build
CMD ["sh", "-c", "cd Backend && uvicorn main:app --host 0.0.0.0 --port 8000"]
```

**For Local:**
```bash
npm run deploy:build
npm run start:production
```

---

**Status:** ✅ Deployment Commands Added
**New Commands:** `deploy:install`, `deploy:build`
**Render Config:** ✅ Updated
**Documentation:** ✅ Complete
