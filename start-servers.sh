#!/bin/bash

# Start both Frontend and Backend servers for CS-15 Project
# This script starts both servers in the background

echo "🚀 Starting CS-15 Registration & Login System..."
echo "==============================================="

# Check if we're in the right directory
if [[ ! -d "backend" ]] || [[ ! -d "frontend" ]]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Function to cleanup background processes on exit
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
    fi
    echo "✅ Servers stopped."
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

echo "🔧 Starting Backend Server (Laravel)..."
cd backend
php artisan serve --host=127.0.0.1 --port=8000 &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 2

echo "🎨 Starting Frontend Server (Next.js)..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "🎉 Both servers are starting up!"
echo "================================"
echo ""
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend:  http://localhost:8000"
echo "📝 Register: http://localhost:3000/register"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Wait for both processes
wait