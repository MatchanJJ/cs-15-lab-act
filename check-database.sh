#!/bin/bash

echo "🗄️  CS-15 Lab Activity - Database Inspector"
echo "=========================================="
echo ""

DB_PATH="/home/matchan/Documents/CS-15/cs-15-lab-act/backend/database/database.sqlite"

# Check if database file exists
if [ -f "$DB_PATH" ]; then
    echo "✅ Database file found: $DB_PATH"
    echo "📊 File size: $(ls -lh $DB_PATH | awk '{print $5}')"
    echo ""
    
    # Check tables
    echo "📋 Tables in database:"
    sqlite3 "$DB_PATH" ".tables" 2>/dev/null
    
    # If no tables, show message
    if [ $? -ne 0 ] || [ -z "$(sqlite3 "$DB_PATH" ".tables" 2>/dev/null)" ]; then
        echo "   No tables found - database might be empty"
        echo "   💡 Run migrations first: cd backend && php artisan migrate"
    else
        echo ""
        echo "👥 Users table structure:"
        sqlite3 "$DB_PATH" ".schema users" 2>/dev/null
        
        echo ""
        echo "📊 Number of users:"
        sqlite3 "$DB_PATH" "SELECT COUNT(*) as total_users FROM users;" 2>/dev/null || echo "   Table 'users' doesn't exist yet"
        
        echo ""
        echo "👤 Recent users (if any):"
        sqlite3 "$DB_PATH" "SELECT name, username, email, gender, country, created_at FROM users ORDER BY created_at DESC LIMIT 5;" 2>/dev/null || echo "   No users found"
        
        echo ""
        echo "🎯 User hobbies breakdown:"
        sqlite3 "$DB_PATH" "SELECT hobbies FROM users WHERE hobbies IS NOT NULL;" 2>/dev/null || echo "   No hobby data found"
    fi
    
    echo ""
    echo "🔧 Database commands you can use:"
    echo "   sqlite3 $DB_PATH"
    echo "   .tables                    # Show all tables"
    echo "   .schema users             # Show users table structure"
    echo "   SELECT * FROM users;      # Show all users"
    echo "   .exit                     # Exit sqlite3"
    
else
    echo "❌ Database file not found: $DB_PATH"
    echo "💡 Create it with: touch $DB_PATH"
fi