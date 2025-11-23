#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "Chameleon Integrated Build Script"
echo "========================================"
echo

echo -e "${BLUE}[1/2] Building Frontend...${NC}"
cd frontend
npm run build
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Frontend build failed!${NC}"
    cd ..
    exit 1
fi
cd ..
echo -e "${GREEN}✓ Frontend built successfully${NC}"
echo

echo -e "${BLUE}[2/2] Backend Integration...${NC}"
echo "Backend is Python-based and runs from source"
echo "Backend will serve frontend from dist/ folder"
echo -e "${GREEN}✓ Backend ready to serve integrated app${NC}"
echo

echo "========================================"
echo "Build Complete - INTEGRATED!"
echo "========================================"
echo
echo "Frontend: frontend/dist/ (served by backend)"
echo "Backend: Backend/ (serves frontend + API)"
echo
echo -e "${YELLOW}To start integrated server:${NC}"
echo "  npm run start:integrated     (development)"
echo "  npm run start:production     (production)"
echo
echo "Or manually:"
echo "  cd Backend && uvicorn main:app --host 0.0.0.0 --port 8000"
echo
echo -e "${GREEN}Access everything at: http://localhost:8000${NC}"
echo
