@echo off
REM Start both servers for CS-15 Project (Windows)

echo.
echo 🚀 Starting CS-15 Registration ^& Login System...
echo ===============================================
echo.

REM Check if we're in the right directory
if not exist "backend" (
    echo ❌ Error: Please run this script from the project root directory
    exit /b 1
)

if not exist "frontend" (
    echo ❌ Error: Please run this script from the project root directory  
    exit /b 1
)

echo 🔧 Starting Backend Server ^(Laravel^)...
echo Opening new command prompt for backend...
start "Backend Server" cmd /k "cd backend && php artisan serve --host=127.0.0.1 --port=8000"

REM Wait a moment for backend to start
timeout /t 3 /nobreak > nul

echo 🎨 Starting Frontend Server ^(Next.js^)...
echo Opening new command prompt for frontend...
start "Frontend Server" cmd /k "cd frontend && npm run dev"

echo.
echo 🎉 Both servers are starting up!
echo ================================
echo.
echo 📱 Frontend: http://localhost:3000
echo 🔧 Backend:  http://localhost:8000  
echo 📝 Register: http://localhost:3000/register
echo.
echo Two new command prompt windows should have opened.
echo Close those windows to stop the servers.
echo.
echo 🚀 Happy coding!
echo.
pause