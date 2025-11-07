#!/bin/bash

echo "🔄 Full Reset Starting..."
echo ""

# Check if in virtual environment and warn user
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "⚠️  You are currently in a virtual environment: $VIRTUAL_ENV"
    echo "   This script will deactivate it, clean everything, and create a fresh environment"
    echo ""
    read -p "   Continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cancelled"
        exit 1
    fi
    echo ""
    
    # Deactivate the current venv within this script's context
    echo "🔌 Deactivating current virtual environment..."
    deactivate 2>/dev/null || true
    echo ""
fi

# Step 1: Clean everything
echo "🧹 Step 1/3: Cleaning all files and venv..."
make clean-all
if [ $? -ne 0 ]; then
    echo "❌ Clean failed"
    exit 1
fi
echo ""

# Step 2: Small pause
echo "💤 Waiting for cleanup to complete..."
sleep 1
echo ""

# Step 3: Fresh setup (will run with no venv active in this subprocess)
echo "🆕 Step 2/3: Creating fresh environment..."
make setup
if [ $? -ne 0 ]; then
    echo "❌ Setup failed"
    exit 1
fi
echo ""

# Step 4: Final instructions
echo "🎉 Step 3/3: Ready to run!"
echo ""
echo "✅ Reset complete!"
echo ""

# Note: Even though we deactivated in the script, the parent shell still shows (.venv)
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "⚠️  Your terminal prompt may still show (.venv) - this is normal"
    echo "   The old venv was deactivated during reset"
    echo ""
fi

echo "📋 To start the app, run:"
echo ""
echo "   source .venv/bin/activate && make run"
echo ""