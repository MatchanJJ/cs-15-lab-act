# CS-15 Project Setup Script for Windows (PowerShell)
# Run with: powershell -ExecutionPolicy Bypass -File setup-windows.ps1

Write-Host ""
Write-Host "🚀 CS-15 Project - Windows Setup (PowerShell)" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Check if we're in the right directory
if (!(Test-Path "backend") -or !(Test-Path "frontend")) {
    Write-Host "❌ Error: Please run this script from the project root directory" -ForegroundColor Red
    Write-Host "   (The directory containing 'backend' and 'frontend' folders)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "🔍 Checking prerequisites..." -ForegroundColor Yellow

# Check PHP
try {
    $phpVersion = php --version 2>$null
    if ($phpVersion) {
        Write-Host "✅ PHP found" -ForegroundColor Green
    } else {
        throw "PHP not found"
    }
} catch {
    Write-Host "❌ PHP is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install PHP 8.2+ from: https://www.php.net/downloads.php" -ForegroundColor Yellow
    Write-Host "Make sure to add PHP to your PATH environment variable" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Node.js
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host "✅ Node.js found" -ForegroundColor Green
    } else {
        throw "Node.js not found"
    }
} catch {
    Write-Host "❌ Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js 18+ from: https://nodejs.org/en/download/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Composer
try {
    $composerVersion = composer --version 2>$null
    if ($composerVersion) {
        Write-Host "✅ Composer found" -ForegroundColor Green
    } else {
        throw "Composer not found"
    }
} catch {
    Write-Host "❌ Composer is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Composer from: https://getcomposer.org/download/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check SQLite extension
$sqliteCheck = php -m | Select-String "sqlite3"
if (!$sqliteCheck) {
    Write-Host "⚠️  PHP SQLite extension not found!" -ForegroundColor Yellow
    Write-Host "Please enable sqlite3 extension in php.ini:" -ForegroundColor Yellow
    Write-Host "1. Find your php.ini file location: php --ini" -ForegroundColor Yellow
    Write-Host "2. Open php.ini and uncomment: extension=sqlite3" -ForegroundColor Yellow
    Write-Host "3. Restart PowerShell" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter after enabling SQLite extension"
}

Write-Host ""
Write-Host "🔧 Setting up Backend (Laravel)..." -ForegroundColor Blue
Write-Host "==================================" -ForegroundColor Blue
Write-Host ""

Set-Location backend

Write-Host "📦 Installing PHP dependencies..." -ForegroundColor Yellow
& composer install --no-dev
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install PHP dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Setup environment
if (!(Test-Path ".env")) {
    Write-Host "⚙️ Setting up environment configuration..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    
    Write-Host "🔧 Configuring SQLite database..." -ForegroundColor Yellow
    # Configure for SQLite
    (Get-Content .env) -replace 'DB_CONNECTION=pgsql', 'DB_CONNECTION=sqlite' | Set-Content .env
    (Get-Content .env) -replace 'DB_HOST=127.0.0.1', '# DB_HOST=127.0.0.1' | Set-Content .env
    (Get-Content .env) -replace 'DB_PORT=5432', '# DB_PORT=5432' | Set-Content .env
    (Get-Content .env) -replace 'DB_DATABASE=laravel_web_scripting_dionaldo', 'DB_DATABASE=database/database.sqlite' | Set-Content .env
    (Get-Content .env) -replace 'DB_USERNAME=root', '# DB_USERNAME=root' | Set-Content .env
    (Get-Content .env) -replace 'DB_PASSWORD=', '# DB_PASSWORD=' | Set-Content .env
    
    # Update SANCTUM domains to include both 3000 and 3001 ports
    (Get-Content .env) -replace 'SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,::1', 'SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,127.0.0.1:3001,localhost:3001,::1' | Set-Content .env
    
    & php artisan key:generate
}

Write-Host "🗄️ Setting up SQLite database..." -ForegroundColor Yellow
if (!(Test-Path "database\database.sqlite")) {
    New-Item -Path "database\database.sqlite" -ItemType File
    Write-Host "✅ Created database\database.sqlite" -ForegroundColor Green
} else {
    Write-Host "✅ Database file already exists" -ForegroundColor Green
}

Write-Host "🔄 Running database migrations..." -ForegroundColor Yellow
& php artisan migrate --force

Write-Host "✅ Backend setup complete!" -ForegroundColor Green
Write-Host ""

# Frontend setup
Write-Host "🎨 Setting up Frontend (Next.js)..." -ForegroundColor Blue
Write-Host "===================================" -ForegroundColor Blue
Write-Host ""

Set-Location ..\frontend

Write-Host "📦 Installing Node.js dependencies..." -ForegroundColor Yellow
& npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install Node.js dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Setup environment
if (!(Test-Path ".env.local")) {
    Write-Host "⚙️ Creating frontend environment file..." -ForegroundColor Yellow
    "NEXT_PUBLIC_BACKEND_URL=http://localhost:8000" | Set-Content .env.local
}

Write-Host "✅ Frontend setup complete!" -ForegroundColor Green
Write-Host ""

Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Database: SQLite (file: backend\database\database.sqlite)" -ForegroundColor Cyan
Write-Host "🔧 Backend configured and ready" -ForegroundColor Cyan
Write-Host "🎨 Frontend configured and ready" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run the application:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Option 1 - Use batch file:" -ForegroundColor Yellow
Write-Host "   .\start-servers-windows.bat" -ForegroundColor White
Write-Host ""
Write-Host "Option 2 - Manual (two command prompts):" -ForegroundColor Yellow
Write-Host "   Command Prompt 1: cd backend && php artisan serve --host=127.0.0.1 --port=8000" -ForegroundColor White
Write-Host "   Command Prompt 2: cd frontend && npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "Then visit: http://localhost:3000" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Happy coding!" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit"