#!/bin/bash
# Deploy to all location repositories
# Usage: ./deploy-all.sh "Your commit message"

set -e  # Exit on any error

COMMIT_MSG="${1:-Update configuration and rebuild sites}"
MAIN_DIR="/c/Users/apsch/OneDrive/Documents/beach-ultimate-weather-dashboard"

echo "🚀 Deploying to all locations..."
echo "📝 Commit message: $COMMIT_MSG"
echo ""

# Deploy to Clifton
echo "📍 Deploying to Clifton..."
cd /tmp/clifton-deploy
cp "$MAIN_DIR/config.yml" .
cp "$MAIN_DIR/script.js" .
cp -r "$MAIN_DIR/scripts" .
LOCATION=clifton node scripts/build-html.js
git add config.yml script.js scripts/ index.html
git commit -m "$COMMIT_MSG" || echo "No changes to commit for Clifton"
git push
echo "✅ Clifton deployed!"
echo ""

# Deploy to Praia
echo "📍 Deploying to Praia..."
cd /tmp/praia-deploy
cp "$MAIN_DIR/config.yml" .
cp "$MAIN_DIR/script.js" .
cp -r "$MAIN_DIR/scripts" .
LOCATION=praia node scripts/build-html.js
git add config.yml script.js scripts/ index.html
git commit -m "$COMMIT_MSG" || echo "No changes to commit for Praia"
git push
echo "✅ Praia deployed!"
echo ""

echo "🎉 All deployments complete!"
