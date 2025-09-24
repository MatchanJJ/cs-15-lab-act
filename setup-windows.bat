@echo off
REM Complete Setup Script for CS-15 Registration & Login System (Windows)
REM This batch file will set up the project on Windows

echo.
echo 🚀 CS-15 Project - Windows Setup
echo ===============================
echo.

REM Check if we're in the right directory
if not exist "backend" (
    echo ❌ Error: Please run this script from the project root directory
    echo    ^(The directory containing 'backend' and 'frontend' folders^)
    pause
    exit /b 1
)

if not exist "frontend" (
    echo ❌ Error: Please run this script from the project root directory
    echo    ^(The directory containing 'backend' and 'frontend' folders^)
    pause
    exit /b 1
)

echo 🔍 Checking prerequisites...

REM Check PHP
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP is not installed or not in PATH
    echo Please install PHP 8.2+ from: https://www.php.net/downloads.php
    echo Make sure to add PHP to your PATH environment variable
    pause
    exit /b 1
) else (
    echo ✅ PHP found
)

REM Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js 18+ from: https://nodejs.org/en/download/
    pause
    exit /b 1
) else (
    echo ✅ Node.js found
)

REM Check Composer
composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Composer is not installed or not in PATH
    echo Please install Composer from: https://getcomposer.org/download/
    pause
    exit /b 1
) else (
    echo ✅ Composer found
)

REM Check SQLite extension
php -m | findstr "sqlite3" >nul
if %errorlevel% neq 0 (
    echo ⚠️  PHP SQLite extension not found!
    echo Please enable sqlite3 extension in php.ini:
    echo 1. Find your php.ini file location: php --ini
    echo 2. Open php.ini and uncomment: extension=sqlite3
    echo 3. Restart command prompt
    echo.
    pause
)

echo.
echo 🔧 Setting up Backend ^(Laravel^)...
echo ==================================
echo.

cd backend

echo 📦 Installing PHP dependencies...
composer install --no-dev
if %errorlevel% neq 0 (
    echo ❌ Failed to install PHP dependencies
    pause
    exit /b 1
)

REM Setup environment
if not exist ".env" (
    echo ⚙️ Setting up environment configuration...
    copy .env.example .env
    
    echo 🔧 Configuring SQLite database...
    REM Use PowerShell to do text replacement (more reliable than batch)
    powershell -Command "(gc .env) -replace 'DB_CONNECTION=pgsql', 'DB_CONNECTION=sqlite' | Out-File -encoding ASCII .env"
    powershell -Command "(gc .env) -replace 'DB_HOST=127.0.0.1', '# DB_HOST=127.0.0.1' | Out-File -encoding ASCII .env"
    powershell -Command "(gc .env) -replace 'DB_PORT=5432', '# DB_PORT=5432' | Out-File -encoding ASCII .env"
    powershell -Command "(gc .env) -replace 'DB_DATABASE=laravel_web_scripting_dionaldo', 'DB_DATABASE=database/database.sqlite' | Out-File -encoding ASCII .env"
    powershell -Command "(gc .env) -replace 'DB_USERNAME=root', '# DB_USERNAME=root' | Out-File -encoding ASCII .env"
    powershell -Command "(gc .env) -replace 'DB_PASSWORD=', '# DB_PASSWORD=' | Out-File -encoding ASCII .env"
    
    REM Update SANCTUM domains to include both 3000 and 3001 ports
    powershell -Command "(gc .env) -replace 'SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,::1', 'SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,127.0.0.1:3001,localhost:3001,::1' | Out-File -encoding ASCII .env"
    
    php artisan key:generate
)

echo 🗄️ Setting up SQLite database...
if not exist "database\database.sqlite" (
    echo. > database\database.sqlite
    echo ✅ Created database\database.sqlite
) else (
    echo ✅ Database file already exists
)

echo 🔄 Running database migrations...
php artisan migrate --force

echo ✅ Backend setup complete!
echo.

REM Frontend setup
echo 🎨 Setting up Frontend ^(Next.js^)...
echo ===================================
echo.

cd ..\frontend

echo 📦 Installing Node.js dependencies...
npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install Node.js dependencies
    pause
    exit /b 1
)

REM Setup environment
if not exist ".env.local" (
    echo ⚙️ Creating frontend environment file...
    echo NEXT_PUBLIC_BACKEND_URL=http://localhost:8000 > .env.local
)

echo ✅ Frontend setup complete!
echo.

echo 🎉 Setup Complete!
echo ==================
echo.
echo 📦 Database: SQLite ^(file: backend\database\database.sqlite^)
echo 🔧 Backend configured and ready
echo 🎨 Frontend configured and ready
echo.
echo To run the application:
echo.
echo 1. Start Backend ^(in one command prompt^):
echo    cd backend
echo    php artisan serve --host=127.0.0.1 --port=8000
echo.
echo 2. Start Frontend ^(in another command prompt^):
echo    cd frontend
echo    npm run dev
echo.
echo 3. Access the application:
echo    📱 Frontend: http://localhost:3000
echo    📝 Register: http://localhost:3000/register
echo    🔧 Backend API: http://localhost:8000
echo.
echo 🚀 Happy coding!
echo.
pause