# 🚀 CS-15 REGISTRATION & LOGIN SYSTEM - COMPLETE SETUP GUIDE

## ⚡ Super Quick Setup (2 minutes)

### **Option 1: If you already have PHP, Node.js, Composer**

**Linux/macOS:**
```bash
# 1. Navigate to project directory
cd cs-15-lab-act

# 2. Run setup script (installs dependencies & configures everything)
chmod +x setup.sh && ./setup.sh

# 3. Start both servers
chmod +x start-servers.sh && ./start-servers.sh
```

**Windows:**
```cmd
# Option A: Command Prompt (Batch file)
setup-windows.bat

# Option B: PowerShell
powershell -ExecutionPolicy Bypass -File setup-windows.ps1

# Then start servers
start-servers-windows.bat
```

### **Option 2: If you need to install PHP, Node.js, Composer**

**Linux/macOS:**
```bash
# This will install missing tools AND set up the project
chmod +x complete-setup.sh && ./complete-setup.sh

# Then start servers
./start-servers.sh
```

**Windows:**
```cmd
# Install manually:
# 1. PHP 8.2+: https://www.php.net/downloads.php
# 2. Node.js 18+: https://nodejs.org/en/download/
# 3. Composer: https://getcomposer.org/download/
# Then run: setup-windows.bat
```

**Then visit:** http://localhost:3000

---

## 📋 Prerequisites & Installation

This project uses **SQLite** - a simple file-based database that doesn't require a separate database server. Just need PHP with SQLite extension.

### **What You Need:**
- **PHP 8.2+** with SQLite extension
- **Node.js 18+** 
- **Composer** (PHP package manager)

### **Automatic Installation Available!**
Our `complete-setup.sh` script can automatically install these tools for you on:
- ✅ **Ubuntu/Debian Linux** (uses apt)
- ✅ **CentOS/RHEL Linux** (uses yum)  
- ✅ **macOS** (installs Homebrew if needed, then uses brew)
- ⚠️ **Windows** (provides manual installation instructions)

### **Manual Installation:**

### **Windows:**
1. **PHP 8.2+**: Download from https://www.php.net/downloads.php
2. **Node.js 18+**: Download from https://nodejs.org/en/download/
3. **Composer**: Download from https://getcomposer.org/download/
4. **Enable SQLite**: In `php.ini`, uncomment `extension=sqlite3` (usually already enabled)

### **macOS:**
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required software
brew install php@8.2 node composer
# SQLite extension usually included with PHP
```

### **Ubuntu/Debian Linux:**
```bash
# Update package list
sudo apt update

# Install everything needed
sudo apt install php8.2 php8.2-cli php8.2-sqlite3 php8.2-xml php8.2-mbstring php8.2-curl composer

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### **Verify Installation:**
```bash
php --version    # Should show 8.2+
node --version   # Should show 18+
composer --version
php -m | grep sqlite3   # Should show sqlite3 extension
```

---

## 🗄️ Database Setup (SQLite)

### **Why SQLite?**
- ✅ **No database server needed** (MySQL, PostgreSQL, etc.)
- ✅ **Database is just one file** - portable and easy to backup
- ✅ **Perfect for development** and academic projects
- ✅ **Real database** - uses proper SQL, migrations, relationships

### **Database File Location:**
- File: `backend/database/database.sqlite`
- Contains: User registration data, sessions, application data
- Portable: Can be copied, shared, or submitted with project

### **If SQLite Extension Missing:**
```bash
# Ubuntu/Debian
sudo apt install php-sqlite3

# CentOS/RHEL  
sudo yum install php-sqlite3

# Windows
# Edit php.ini and uncomment: extension=sqlite3

# macOS (Homebrew)
# Usually included - try: brew reinstall php
```

---

## 🚀 Manual Setup (Step-by-Step)

If the automatic script doesn't work, follow these steps:

### **Step 1: Backend Setup (Laravel)**
```bash
# Navigate to backend
cd backend

# Install PHP dependencies
composer install

# Create environment file
cp .env.example .env

# Configure for SQLite
# Edit .env file and set:
# DB_CONNECTION=sqlite
# DB_DATABASE=database/database.sqlite
# (comment out other DB_ lines)

# Generate application key
php artisan key:generate

# Create SQLite database file
touch database/database.sqlite

# Run database migrations
php artisan migrate

# Start backend server
php artisan serve --host=127.0.0.1 --port=8000
```

### **Step 2: Frontend Setup (Next.js)**
```bash
# Navigate to frontend (from project root)
cd frontend

# Install Node.js dependencies
npm install

# Create environment file
echo "NEXT_PUBLIC_BACKEND_URL=http://localhost:8000" > .env.local

# Start frontend server
npm run dev
```

---

## 🌐 Running the Application

You need **TWO terminal windows/tabs** open:

### **Terminal 1 - Backend Server:**
```bash
cd backend
php artisan serve --host=127.0.0.1 --port=8000
```
*Keep running - should show: "Server running on [http://127.0.0.1:8000]"*

### **Terminal 2 - Frontend Server:**
```bash
cd frontend
npm run dev
```
*Keep running - should show: "Local: http://localhost:3000"*

### **Access Points:**
- **Main App**: http://localhost:3000
- **Registration**: http://localhost:3000/register
- **Login**: http://localhost:3000/
- **Dashboard**: http://localhost:3000/dashboard (after login)

---

## 🧪 Testing the Complete System

### **1. Test Registration:**
1. Go to: http://localhost:3000/register
2. Fill out all fields:
   - **Full Name**: `John Doe`
   - **Username**: `johndoe` (must be unique)
   - **Email**: `john@example.com` (must be unique)
   - **Password**: `password123` (min 8 characters)
   - **Confirm Password**: `password123` (must match)
   - **Gender**: Select one option (required)
   - **Hobbies**: Check at least one (required)
   - **Country**: Select from dropdown (required)
3. Click "Create Account"
4. Should redirect to dashboard showing all your info

### **2. Test Login:**
1. Go to: http://localhost:3000/
2. Login with either:
   - **Username**: `johndoe` OR **Email**: `john@example.com`
   - **Password**: `password123`
3. Click "Sign In"
4. Should redirect to dashboard

### **3. Test Features:**
- **Real-time validation**: Try submitting empty fields
- **Password matching**: Enter different passwords
- **Username uniqueness**: Try registering same username twice
- **Responsive design**: Resize browser window
- **Dashboard**: View your profile data after login

---

## 🔧 Troubleshooting Common Issues

### **CORS Issues (Frontend on different port):**
```bash
# If frontend runs on port 3001 instead of 3000, you'll get CORS errors
# Solution 1: Update backend CORS config (already handled in our setup)
# Solution 2: Force frontend to use port 3000
npm run dev -- --port 3000

# Or check backend .env file includes both ports:
# SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,127.0.0.1:3000,localhost:3000,127.0.0.1:3001,localhost:3001,::1
```

### **"Connection Refused" Error:**
```bash
# Linux/macOS
cd backend && php artisan serve --host=127.0.0.1 --port=8000

# Windows  
cd backend
php artisan serve --host=127.0.0.1 --port=8000
```

### **"SQLite Extension Not Found":**
```bash
# Linux
sudo apt install php-sqlite3

# macOS
brew reinstall php

# Windows
# 1. Find php.ini location: php --ini
# 2. Edit php.ini and uncomment: extension=sqlite3
# 3. Restart command prompt/PowerShell
```

### **"Database Not Found":**
```bash
# Linux/macOS
cd backend && touch database/database.sqlite && php artisan migrate

# Windows
cd backend
echo. > database\database.sqlite
php artisan migrate
```

### **"Port Already in Use":**
```bash
# Linux/macOS
sudo lsof -ti:8000 | xargs kill -9  # Backend
sudo lsof -ti:3000 | xargs kill -9  # Frontend

# Windows  
netstat -ano | findstr :8000        # Find process ID
taskkill /F /PID [process_id]        # Kill process
```

### **Windows-Specific Issues:**

**"chmod is not recognized":**
- Use `.bat` files instead of `.sh` files on Windows
- Run `setup-windows.bat` instead of `chmod +x setup.sh`

**"Execution policy error" (PowerShell):**
```powershell
# Run PowerShell as Administrator and execute:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or run scripts with:
powershell -ExecutionPolicy Bypass -File setup-windows.ps1
```

**"npm/php/composer not recognized":**
- Make sure tools are added to your PATH environment variable
- Restart command prompt after installation
- Use full paths if needed: `C:\php\php.exe` instead of `php`

### **Reset Everything:**
```bash
# Linux/macOS
rm backend/.env backend/database/database.sqlite frontend/.env.local
./setup.sh

# Windows
del backend\.env backend\database\database.sqlite frontend\.env.local
setup-windows.bat
```

### **Database Inspection:**
```bash
# View database contents
cd backend
php artisan tinker

# In tinker:
>>> App\Models\User::all();  # Show all registered users
>>> User::count();           # Count users
```

---

## 🎉 Success Indicators

When everything works correctly, you should see:

1. **Backend Terminal**: `INFO Server running on [http://127.0.0.1:8000]`
2. **Frontend Terminal**: `✓ Ready in XXXms`  
3. **Registration Page**: All form fields visible and responsive
4. **Form Validation**: Real-time error messages
5. **Successful Registration**: Redirect to dashboard with user data
6. **Login Works**: Can login with username or email
7. **Dashboard**: Shows all registered user information
8. **Database File**: `backend/database/database.sqlite` contains user data

---

**🎯 This project demonstrates modern web development using Laravel + Next.js while fulfilling all CS-15 traditional web scripting requirements (HTML, CSS, JavaScript, PHP, Database).**

---

## 🚀 Manual Setup (if scripts don't work)

### Backend (Laravel):
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
touch database/database.sqlite
php artisan migrate
php artisan serve --host=127.0.0.1 --port=8000
```

### Frontend (Next.js) - In separate terminal:
```bash
cd frontend
npm install
echo "NEXT_PUBLIC_BACKEND_URL=http://localhost:8000" > .env.local
npm run dev
```

---

## 🧪 Test the Application

1. **Register**: http://localhost:3000/register
   - Fill all fields (name, username, email, password, gender, hobbies, country)
   - Submit form
   
2. **Login**: http://localhost:3000/
   - Use username OR email + password
   - Access dashboard

3. **Dashboard**: http://localhost:3000/dashboard
   - View user profile with all registration data

---

## 🔧 Troubleshooting

**Connection Refused Error?**
```bash
# Make sure backend is running on port 8000
cd backend && php artisan serve --host=127.0.0.1 --port=8000
```

**PHP SQLite Error?**
```bash
sudo apt install php8.2-sqlite3  # Linux
# or enable sqlite3 in php.ini for Windows
```

**Port Already in Use?**
```bash
# Kill existing processes
sudo lsof -ti:8000 | xargs kill -9  # Backend port
sudo lsof -ti:3000 | xargs kill -9  # Frontend port
```