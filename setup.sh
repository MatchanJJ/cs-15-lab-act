#!/bin/bash

# Quick Setup Script for CS-15 Registration & Login System
# Run this script from the project root directory

echo "🚀 Starting CS-15 Project Setup..."
echo "=================================="

# Check if we're in the right directory
if [[ ! -d "backend" ]] || [[ ! -d "frontend" ]]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   (The directory containing 'backend' and 'frontend' folders)"
    exit 1
fi

# Check system requirements
echo "🔍 Checking system requirements..."

# Check PHP
if ! command -v php &> /dev/null; then
    echo "❌ PHP is not installed. Please install PHP 8.2+"
    exit 1
fi

PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2 | cut -d'.' -f1-2)
echo "✅ PHP version: $PHP_VERSION"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✅ Node.js version: $NODE_VERSION"

# Check Composer
if ! command -v composer &> /dev/null; then
    echo "❌ Composer is not installed. Please install Composer"
    exit 1
fi

COMPOSER_VERSION=$(composer --version | cut -d' ' -f3)
echo "✅ Composer version: $COMPOSER_VERSION"

echo ""
echo "🔧 Setting up Backend (Laravel)..."
echo "=================================="

cd backend

# Install composer dependencies
echo "📦 Installing PHP dependencies..."
composer install --no-dev

# Setup environment
if [[ ! -f ".env" ]]; then
    echo "⚙️ Setting up environment configuration..."
    cp .env.example .env
    
    # Configure for SQLite
    echo "🔧 Configuring SQLite database..."
    sed -i 's/DB_CONNECTION=pgsql/DB_CONNECTION=sqlite/' .env
    sed -i 's/DB_HOST=127.0.0.1/# DB_HOST=127.0.0.1/' .env
    sed -i 's/DB_PORT=5432/# DB_PORT=5432/' .env
    sed -i 's/DB_DATABASE=laravel_web_scripting_dionaldo/DB_DATABASE=database\/database.sqlite/' .env
    sed -i 's/DB_USERNAME=root/# DB_USERNAME=root/' .env
    sed -i 's/DB_PASSWORD=/# DB_PASSWORD=/' .env
    
    # Update SANCTUM domains to include both 3000 and 3001 ports
    sed -i 's/SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,::1/SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,127.0.0.1:3001,localhost:3001,::1/' .env
    
    php artisan key:generate
fi

# Check for SQLite PHP extension
echo "🔍 Checking PHP SQLite extension..."
if php -m | grep -q "sqlite3"; then
    echo "✅ PHP SQLite extension is available"
else
    echo "⚠️  PHP SQLite extension not found!"
    echo "   Please install it based on your system:"
    echo "   - Ubuntu/Debian: sudo apt install php-sqlite3"
    echo "   - CentOS/RHEL: sudo yum install php-sqlite3"
    echo "   - Windows: Enable sqlite3 extension in php.ini"
    echo "   - macOS: Usually included with PHP"
    echo ""
    read -p "Install SQLite extension and press Enter to continue..."
fi

# Setup database
echo "🗄️ Setting up SQLite database..."
if [[ ! -f "database/database.sqlite" ]]; then
    touch database/database.sqlite
    echo "✅ Created database/database.sqlite"
else
    echo "✅ Database file already exists"
fi

# Run migrations
echo "🔄 Running database migrations..."
php artisan migrate --force

echo "✅ Backend setup complete!"
echo ""

# Frontend setup
echo "🎨 Setting up Frontend (Next.js)..."
echo "==================================="

cd ../frontend

# Install npm dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Setup environment
if [[ ! -f ".env.local" ]]; then
    echo "⚙️ Creating frontend environment file..."
    echo "NEXT_PUBLIC_BACKEND_URL=http://localhost:8000" > .env.local
fi

echo "✅ Frontend setup complete!"
echo ""

echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "📦 Database: SQLite (file: backend/database/database.sqlite)"
echo "🔧 Backend configured and ready"
echo "🎨 Frontend configured and ready"
echo ""
echo "To run the application:"
echo ""
echo "1. Start Backend (in one terminal):"
echo "   cd backend"
echo "   php artisan serve --host=127.0.0.1 --port=8000"
echo ""
echo "2. Start Frontend (in another terminal):"
echo "   cd frontend"
echo "   npm run dev"
echo ""
echo "OR use the start script:"
echo "   ./start-servers.sh"
echo ""
echo "3. Access the application:"
echo "   📱 Frontend: http://localhost:3000"
echo "   � Register: http://localhost:3000/register"
echo "   � Backend API: http://localhost:8000"
echo ""
echo "🚀 Happy coding!"