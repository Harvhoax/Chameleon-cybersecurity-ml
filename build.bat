@echo off
echo ========================================
echo Chameleon Integrated Build Script
echo ========================================
echo.

echo [1/2] Building Frontend...
cd frontend
call npm run build
if errorlevel 1 (
    echo ERROR: Frontend build failed!
    cd ..
    pause
    exit /b 1
)
cd ..
echo ✓ Frontend built successfully
echo.

echo [2/2] Backend Integration...
echo Backend is Python-based and runs from source
echo Backend will serve frontend from dist/ folder
echo ✓ Backend ready to serve integrated app
echo.

echo ========================================
echo Build Complete - INTEGRATED!
echo ========================================
echo.
echo Frontend: frontend/dist/ (served by backend)
echo Backend: Backend/ (serves frontend + API)
echo.
echo To start integrated server:
echo   npm run start:integrated     (development)
echo   npm run start:production     (production)
echo.
echo Or manually:
echo   cd Backend ^&^& uvicorn main:app --host 0.0.0.0 --port 8000
echo.
echo Access everything at: http://localhost:8000
echo.
pause
