# Multi-Repository Deployment Workflow

This guide explains how to manage the Beach Ultimate Weather Dashboard with multiple location deployments.

## Repository Structure

```
beach-ultimate-weather-dashboard/     # Source repository (local)
├── config.yml                        # Shared configuration for all locations
├── deploy-all.sh                     # 🚀 One-command deploy script
├── scripts/build-html.js             # Builds location-specific HTML
├── style.css, script.js              # Shared assets
└── ...

/tmp/clifton-deploy/                  # Clifton deployment repository
└── Git remote: scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard

/tmp/praia-deploy/                    # Praia deployment repository
└── Git remote: scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard
```

## Configuration File

All location settings are centralized in `config.yml`:

```yaml
locations:
  clifton:
    name: "Clifton Beach Frisbee"
    youtube_url: "https://www.youtube.com/embed/VIDEO_ID?autoplay=1&mute=1"
    coordinates: {...}

  praia:
    name: "Praia da Rocha Beach Ultimate"
    youtube_url: "https://www.youtube.com/embed/VIDEO_ID?autoplay=1&mute=1"
    coordinates: {...}
```

## Workflow: Making Changes

### 🚀 SUPER SIMPLE METHOD (Recommended)

**One command to deploy to all locations:**

```bash
cd /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard
./deploy-all.sh "Your commit message here"
```

That's it! This script will:
1. Copy your updated `config.yml` to both deployment repos
2. Build location-specific HTML for each
3. Commit and push to both GitHub repositories
4. Auto-deploy via GitHub Pages

**Example:**
```bash
./deploy-all.sh "Fix YouTube embed URLs"
```

---

### Manual Method (For Advanced Use)

If you need more control or want to deploy to only one location, use the manual method below.

### 1. Edit Configuration

Edit the main config file:
```bash
# Working directory: /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard
nano config.yml
```

### 2. Test Locally with Docker

Build and test both locations:
```bash
# Build both containers
docker-compose build

# Start both containers
docker-compose up -d

# View in browser:
# - Clifton: http://localhost:8080
# - Praia: http://localhost:8081

# Check logs
docker-compose logs

# Stop containers
docker-compose down
```

### 3. Deploy to Production Repositories

#### Option A: Deploy Both Locations

```bash
# Copy config and build Clifton
cd /tmp/clifton-deploy
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/config.yml .
LOCATION=clifton node scripts/build-html.js
git add config.yml index.html
git commit -m "Your commit message"
git push

# Copy config and build Praia
cd /tmp/praia-deploy
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/config.yml .
LOCATION=praia node scripts/build-html.js
git add config.yml index.html
git commit -m "Your commit message"
git push
```

#### Option B: Deploy Single Location

For Clifton only:
```bash
cd /tmp/clifton-deploy
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/config.yml .
LOCATION=clifton node scripts/build-html.js
git add config.yml index.html
git commit -m "Your commit message"
git push
```

For Praia only:
```bash
cd /tmp/praia-deploy
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/config.yml .
LOCATION=praia node scripts/build-html.js
git add config.yml index.html
git commit -m "Your commit message"
git push
```

## Common Tasks

### Update YouTube Embed URLs

1. Edit `config.yml` in the main directory
2. Find the video ID from YouTube URL (e.g., `https://www.youtube.com/watch?v=VIDEO_ID`)
3. Update the `youtube_url` field for the location:
   ```yaml
   youtube_url: "https://www.youtube.com/embed/VIDEO_ID?autoplay=1&mute=1"
   ```
4. Test with Docker
5. Deploy to production repos

### Add a New Location

1. Add new location to `config.yml`:
   ```yaml
   locations:
     new_location:
       name: "New Location Name"
       youtube_url: "..."
       coordinates: {...}
   ```
2. Create new deployment repository on GitHub
3. Clone to `/tmp/new-location-deploy`
4. Build and deploy using `LOCATION=new_location`

### Update Shared Assets (CSS, JS)

When changing `style.css` or `script.js`:
```bash
# 1. Make changes in main directory
# 2. Copy to deployment repos
cd /tmp/clifton-deploy
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/style.css .
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/script.js .
git add style.css script.js
git commit -m "Update shared assets"
git push

# Repeat for Praia
cd /tmp/praia-deploy
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/style.css .
cp /mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard/script.js .
git add style.css script.js
git commit -m "Update shared assets"
git push
```

## Build Script Details

The `scripts/build-html.js` script:
- Reads `config.yml`
- Uses `LOCATION` environment variable to select which location to build
- Generates location-specific `index.html` with:
  - Location-specific title and name
  - Location-specific YouTube embed
  - Location-specific coordinates for weather/maps
  - Location-specific share URLs and WhatsApp forms

## Environment Variables

- `LOCATION=clifton` - Build for Clifton Beach
- `LOCATION=praia` - Build for Praia da Rocha

## GitHub Pages Deployment

Both repositories auto-deploy via GitHub Pages:
- Clifton: https://scholtzap.github.io/Clifton-Beach-Frisbee-Weather-Dashboard/
- Praia: https://scholtzap.github.io/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard/

Changes pushed to `main` branch are automatically deployed within a few minutes.

## Troubleshooting

### YouTube Embeds Not Working

- Verify video ID is correct
- Check if video is a permanent 24/7 livestream
- Ensure embedding is enabled on the YouTube video
- Use format: `https://www.youtube.com/embed/VIDEO_ID?autoplay=1&mute=1`

### Build Script Fails

```bash
# Check Node.js is installed
node --version

# Install dependencies if needed
cd /tmp/clifton-deploy
npm install
```

### Docker Containers Won't Start

```bash
# View detailed logs
docker-compose logs clifton
docker-compose logs praia

# Rebuild from scratch
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Git Push Authentication Issues

If using HTTPS remotes and push fails:
```bash
# Configure Windows credential manager (WSL)
git config credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Or push manually from Windows terminal
cd /path/to/repo
git push
```

## Quick Reference

| Task | Command |
|------|---------|
| **Deploy to all repos** | `./deploy-all.sh "commit message"` |
| Build Clifton HTML | `LOCATION=clifton node scripts/build-html.js` |
| Build Praia HTML | `LOCATION=praia node scripts/build-html.js` |
| Test locally | `docker-compose up -d` |
| Stop containers | `docker-compose down` |
| View logs | `docker-compose logs` |
| Check container status | `docker-compose ps` |

## Directory Paths

- Main source: `/mnt/c/Users/apsch/OneDrive/Documents/github/beach-ultimate-weather-dashboard`
- Clifton deploy: `/tmp/clifton-deploy`
- Praia deploy: `/tmp/praia-deploy`
