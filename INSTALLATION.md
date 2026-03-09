# Installation Commands Reference

## Quick Start (Choose One Method)

### Method 1: Docker Compose (Recommended - Easiest)
```bash
# Navigate to project directory
cd blog-microservices

# Start all services
docker-compose up --build

# Access application
# Frontend: http://localhost:3000
# Auth API: http://localhost:8001/docs
# Blog API: http://localhost:8002/docs
```

### Method 2: Windows Batch Script
```bash
# Navigate to project directory
cd blog-microservices

# Run the startup script
start.bat

# This will open 3 terminal windows for each service
```

### Method 3: Manual Setup (All Platforms)

#### Prerequisites Installation

**Python 3.11+**
```bash
# Download from python.org
# Verify installation
python --version
```

**Node.js 20+**
```bash
# Download from nodejs.org
# Verify installation
node --version
npm --version
```

**MongoDB 7.0+**
```bash
# Download from mongodb.com
# Start MongoDB service
# Windows: net start MongoDB
# Mac/Linux: sudo systemctl start mongod
```

#### Backend Setup

**Terminal 1 - Auth Service**
```bash
cd blog-microservices/backend/auth-service
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

**Terminal 2 - Blog Service**
```bash
cd blog-microservices/backend/blog-service
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8002 --reload
```

#### Frontend Setup

**Terminal 3 - React App**
```bash
cd blog-microservices/frontend
npm install
npm start
```

## Verification Commands

### Check if services are running

**Check Auth Service**
```bash
curl http://localhost:8001/docs
# Should open API documentation
```

**Check Blog Service**
```bash
curl http://localhost:8002/docs
# Should open API documentation
```

**Check Frontend**
```bash
# Open browser: http://localhost:3000
# Should show login page
```

**Check MongoDB**
```bash
# Connect to MongoDB
mongosh

# List databases
show dbs

# Use blog database
use blog_db

# List collections
show collections
```

## Docker Commands

### Basic Operations
```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# View specific service logs
docker-compose logs auth-service
docker-compose logs blog-service
docker-compose logs frontend

# Rebuild containers
docker-compose build

# Rebuild and start
docker-compose up --build

# Remove volumes (delete data)
docker-compose down -v
```

### Docker Troubleshooting
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune -a

# View container logs
docker logs <container_id>

# Execute command in container
docker exec -it <container_id> bash

# Restart specific service
docker-compose restart auth-service
```

## Python Virtual Environment (Optional)

### Create Virtual Environment
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Mac/Linux
python3 -m venv venv
source venv/bin/activate
```

### Install Dependencies
```bash
# Auth Service
cd backend/auth-service
pip install -r requirements.txt

# Blog Service
cd backend/blog-service
pip install -r requirements.txt
```

## NPM Commands

### Frontend Development
```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test

# Clear cache
npm cache clean --force

# Update dependencies
npm update
```

## MongoDB Commands

### Access MongoDB Shell
```bash
# Local MongoDB
mongosh

# Docker MongoDB
docker exec -it blog-mongodb mongosh
```

### Database Operations
```javascript
// Switch to blog database
use blog_db

// View all users
db.users.find().pretty()

// View all blogs
db.blogs.find().pretty()

// Count documents
db.users.countDocuments()
db.blogs.countDocuments()

// Find specific user
db.users.findOne({email: "user@example.com"})

// Find user's blogs
db.blogs.find({author_email: "user@example.com"})

// Delete all data (reset)
db.users.deleteMany({})
db.blogs.deleteMany({})

// Drop database
db.dropDatabase()
```

## Environment Variables

### Create .env file
```bash
# Copy example file
cp .env.example .env

# Edit with your values
# Windows: notepad .env
# Mac/Linux: nano .env
```

### Example .env content
```bash
SECRET_KEY=your-super-secret-key-min-32-characters-long
MONGO_URL=mongodb://localhost:27017
AUTH_SERVICE_URL=http://localhost:8001
```

## Port Management

### Check if port is in use

**Windows**
```bash
# Check specific port
netstat -ano | findstr :3000
netstat -ano | findstr :8001
netstat -ano | findstr :8002

# Kill process by PID
taskkill /PID <PID> /F
```

**Mac/Linux**
```bash
# Check specific port
lsof -i :3000
lsof -i :8001
lsof -i :8002

# Kill process by PID
kill -9 <PID>
```

## Testing the Application

### Manual Testing Flow
```bash
1. Open http://localhost:3000
2. Click "Sign Up"
3. Enter: Name, Email, Password
4. Should redirect to Dashboard
5. Click "New Blog"
6. Enter: Title and Content
7. Click "Save as Draft"
8. Check Dashboard - should show 1 draft
9. Go to "My Blogs"
10. Click "Edit" on your blog
11. Click "Publish"
12. Check Dashboard - should show 1 published
```

### API Testing with curl

**Signup**
```bash
curl -X POST http://localhost:8001/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'
```

**Login**
```bash
curl -X POST http://localhost:8001/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

**Create Blog** (replace TOKEN with actual token)
```bash
curl -X POST http://localhost:8002/blogs \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN" \
  -d '{"title":"My Blog","content":"Blog content","status":"published"}'
```

## Cleanup Commands

### Stop Everything
```bash
# Docker
docker-compose down -v

# Manual (Windows)
# Press Ctrl+C in each terminal window

# Manual (Mac/Linux)
# Press Ctrl+C in each terminal
```

### Remove All Data
```bash
# MongoDB
mongosh
use blog_db
db.dropDatabase()

# Docker volumes
docker-compose down -v
docker volume prune
```

### Fresh Start
```bash
# Complete reset
docker-compose down -v
docker system prune -a
docker-compose up --build
```

## Update Dependencies

### Python
```bash
# Update all packages
pip install --upgrade -r requirements.txt

# Update specific package
pip install --upgrade fastapi
```

### Node.js
```bash
# Update all packages
npm update

# Update specific package
npm install react@latest

# Check for outdated packages
npm outdated
```

## Production Deployment

### Build for Production

**Frontend**
```bash
cd frontend
npm run build
# Creates optimized build in /build folder
```

**Backend**
```bash
# Use production WSGI server
pip install gunicorn
gunicorn main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker
```

### Environment Variables for Production
```bash
SECRET_KEY=<generate-strong-random-key>
MONGO_URL=<production-mongodb-url>
AUTH_SERVICE_URL=<production-auth-url>
```

---

**Quick Reference Card**

| Action | Command |
|--------|---------|
| Start All (Docker) | `docker-compose up` |
| Stop All (Docker) | `docker-compose down` |
| View Logs | `docker-compose logs` |
| Rebuild | `docker-compose up --build` |
| Access Frontend | http://localhost:3000 |
| Access Auth API | http://localhost:8001/docs |
| Access Blog API | http://localhost:8002/docs |
| MongoDB Shell | `mongosh` |
| Reset Data | `docker-compose down -v` |

---

**Need Help?** Check TROUBLESHOOTING.md for common issues and solutions!
