# 🎓 CS-15 Lab Activity - Registration & Login System

A complete registration and login system built with **Laravel (Backend)** and **Next.js (Frontend)**.

## ⚡ Quick Start

**For immediate setup, see: [`QUICK_START.md`](./QUICK_START.md)**

**Linux/macOS - If you have PHP, Node.js, Composer:**
```bash
chmod +x setup.sh && ./setup.sh && ./start-servers.sh
```

**Linux/macOS - If you need to install tools first:**
```bash
chmod +x complete-setup.sh && ./complete-setup.sh && ./start-servers.sh
```

**Windows:**
```cmd
setup-windows.bat && start-servers-windows.bat
```

Then visit: **http://localhost:3000**


---

## 📋 System Requirements

- **PHP 8.2+** with SQLite extension
- **Node.js 18+**  
- **Composer**

**Database**: Uses SQLite (file-based, no server needed)

---

## 🚀 Setup Options

### Option 1: Automated Setup
```bash
./setup.sh              # Install dependencies & configure
./start-servers.sh       # Start both servers
```

### Option 2: Manual Setup
```bash
# Backend
cd backend
composer install
cp .env.example .env
php artisan key:generate  
touch database/database.sqlite
php artisan migrate
php artisan serve

# Frontend (separate terminal)
cd frontend
npm install
echo "NEXT_PUBLIC_BACKEND_URL=http://localhost:8000" > .env.local
npm run dev
```

---

## 🧪 Testing

1. **Register**: http://localhost:3000/register
2. **Login**: http://localhost:3000/
3. **Dashboard**: http://localhost:3000/dashboard

---

## 🔧 Troubleshooting

**Most common issues solved in [`QUICK_START.md`](./QUICK_START.md)**

**Quick fixes:**
```bash
# SQLite extension missing
sudo apt install php-sqlite3

# Port conflicts  
sudo lsof -ti:8000 | xargs kill -9
sudo lsof -ti:3000 | xargs kill -9

# Reset setup
rm backend/.env backend/database/database.sqlite frontend/.env.local
./setup.sh
```

---

## 🎓 For Instructors

- **Complete Setup Guide**: [`QUICK_START.md`](./QUICK_START.md)
- **One-command setup**: `./setup.sh && ./start-servers.sh`
- **Database**: SQLite file at `backend/database/database.sqlite`
- **Testing URLs**: Register at http://localhost:3000/register
- **All CS-15 requirements implemented with modern best practices**

---

**Built with Laravel 12 + Next.js 14 + SQLite + Tailwind CSS**