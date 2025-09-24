#!/bin/bash

# Complete Setup Script for CS-15 Registration & Login System
# This script will install prerequisites AND set up the project

echo "🚀 CS-15 Project - Complete Installation & Setup"
echo "==============================================="

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    if command -v apt &> /dev/null; then
        DISTRO="debian"
    elif command -v yum &> /dev/null; then
        DISTRO="rhel"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
else
    OS="unknown"
fi

echo "🔍 Detected OS: $OS"

# Function to install prerequisites
install_prerequisites() {
    echo "🔧 Installing prerequisites..."
    
    case $OS in
        "linux")
            case $DISTRO in
                "debian")
                    echo "📦 Installing for Ubuntu/Debian..."
                    sudo apt update
                    
                    # Install PHP 8.2
                    if ! command -v php &> /dev/null; then
                        echo "Installing PHP 8.2..."
                        sudo apt install -y software-properties-common
                        sudo add-apt-repository ppa:ondrej/php -y
                        sudo apt update
                        sudo apt install -y php8.2 php8.2-cli php8.2-sqlite3 php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip
                    fi
                    
                    # Install Node.js
                    if ! command -v node &> /dev/null; then
                        echo "Installing Node.js 18..."
                        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                        sudo apt-get install -y nodejs
                    fi
                    
                    # Install Composer
                    if ! command -v composer &> /dev/null; then
                        echo "Installing Composer..."
                        curl -sS https://getcomposer.org/installer | php
                        sudo mv composer.phar /usr/local/bin/composer
                        sudo chmod +x /usr/local/bin/composer
                    fi
                    ;;
                "rhel")
                    echo "📦 Installing for CentOS/RHEL..."
                    sudo yum update -y
                    
                    # Install PHP
                    if ! command -v php &> /dev/null; then
                        sudo yum install -y php php-cli php-sqlite3 php-xml php-mbstring php-curl
                    fi
                    
                    # Install Node.js
                    if ! command -v node &> /dev/null; then
                        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
                        sudo yum install -y nodejs
                    fi
                    
                    # Install Composer
                    if ! command -v composer &> /dev/null; then
                        curl -sS https://getcomposer.org/installer | php
                        sudo mv composer.phar /usr/local/bin/composer
                    fi
                    ;;
            esac
            ;;
        "macos")
            echo "📦 Installing for macOS..."
            # Install Homebrew if not present
            if ! command -v brew &> /dev/null; then
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            # Install PHP
            if ! command -v php &> /dev/null; then
                echo "Installing PHP..."
                brew install php@8.2
            fi
            
            # Install Node.js
            if ! command -v node &> /dev/null; then
                echo "Installing Node.js..."
                brew install node
            fi
            
            # Install Composer
            if ! command -v composer &> /dev/null; then
                echo "Installing Composer..."
                brew install composer
            fi
            ;;
        "windows")
            echo "❌ Windows auto-installation not supported in this script."
            echo "Please install manually:"
            echo "1. PHP 8.2+: https://www.php.net/downloads.php"
            echo "2. Node.js 18+: https://nodejs.org/en/download/"
            echo "3. Composer: https://getcomposer.org/download/"
            echo ""
            read -p "Press Enter after installing all prerequisites..."
            ;;
        *)
            echo "❌ Unknown OS. Please install manually:"
            echo "1. PHP 8.2+ with SQLite extension"
            echo "2. Node.js 18+"
            echo "3. Composer"
            echo ""
            read -p "Press Enter after installing all prerequisites..."
            ;;
    esac
}

# Check if we're in the right directory
if [[ ! -d "backend" ]] || [[ ! -d "frontend" ]]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   (The directory containing 'backend' and 'frontend' folders)"
    exit 1
fi

# Check if prerequisites are installed
echo "🔍 Checking prerequisites..."

MISSING_TOOLS=()

if ! command -v php &> /dev/null; then
    MISSING_TOOLS+=("PHP")
fi

if ! command -v node &> /dev/null; then
    MISSING_TOOLS+=("Node.js")
fi

if ! command -v composer &> /dev/null; then
    MISSING_TOOLS+=("Composer")
fi

# If tools are missing, offer to install
if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "⚠️  Missing tools: ${MISSING_TOOLS[*]}"
    echo ""
    echo "Options:"
    echo "1) Auto-install missing tools (recommended)"
    echo "2) Skip installation (I'll install manually)"
    echo "3) Exit and install manually"
    echo ""
    read -p "Choose option (1-3): " INSTALL_CHOICE
    
    case $INSTALL_CHOICE in
        1)
            install_prerequisites
            ;;
        2)
            echo "⏭️  Skipping auto-installation..."
            echo "Please make sure you have PHP 8.2+, Node.js 18+, and Composer installed"
            ;;
        3)
            echo "👋 Exiting. Install the tools manually and run this script again."
            exit 0
            ;;
        *)
            echo "Invalid choice. Exiting..."
            exit 1
            ;;
    esac
else
    echo "✅ All prerequisites found!"
fi

# Verify tools are now available
echo ""
echo "🔍 Verifying installation..."

if ! command -v php &> /dev/null; then
    echo "❌ PHP still not found. Please install PHP 8.2+ manually."
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "❌ Node.js still not found. Please install Node.js 18+ manually."
    exit 1
fi

if ! command -v composer &> /dev/null; then
    echo "❌ Composer still not found. Please install Composer manually."
    exit 1
fi

# Show versions
PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2 | cut -d'.' -f1-2)
NODE_VERSION=$(node -v)
COMPOSER_VERSION=$(composer --version | cut -d' ' -f3)

echo "✅ PHP version: $PHP_VERSION"
echo "✅ Node.js version: $NODE_VERSION"
echo "✅ Composer version: $COMPOSER_VERSION"

# Now run the project setup
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
    if [[ $OS == "linux" && $DISTRO == "debian" ]]; then
        echo "Attempting to install SQLite extension..."
        sudo apt install -y php-sqlite3
    else
        echo "   Please install it based on your system:"
        echo "   - Ubuntu/Debian: sudo apt install php-sqlite3"
        echo "   - CentOS/RHEL: sudo yum install php-sqlite3" 
        echo "   - Windows: Enable sqlite3 extension in php.ini"
        echo "   - macOS: Usually included with PHP"
        echo ""
        read -p "Install SQLite extension and press Enter to continue..."
    fi
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

echo "🎉 COMPLETE INSTALLATION FINISHED!"
echo "================================="
echo ""
echo "📦 Database: SQLite (file: backend/database/database.sqlite)"
echo "🔧 Backend configured and ready"
echo "🎨 Frontend configured and ready"
echo ""
echo "🚀 To run the application:"
echo ""
echo "Option 1 - Use start script:"
echo "   ./start-servers.sh"
echo ""
echo "Option 2 - Manual (two terminals):"
echo "   Terminal 1: cd backend && php artisan serve --host=127.0.0.1 --port=8000"
echo "   Terminal 2: cd frontend && npm run dev"
echo ""
echo "Then visit: http://localhost:3000"
echo ""
echo "🎓 Happy coding!"