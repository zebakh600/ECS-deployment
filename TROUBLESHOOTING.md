# Troubleshooting Guide

## Common Issues and Solutions

### 1. Port Already in Use

**Error**: "Address already in use" or "Port 3000/8001/8002 is already allocated"

**Solution**:
```bash
# Windows - Find and kill process
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Or change ports in docker-compose.yml
ports:
  - "3001:3000"  # Change 3000 to 3001
```

### 2. MongoDB Connection Failed

**Error**: "Connection refused" or "Cannot connect to MongoDB"

**Solution**:
- Ensure MongoDB is running
- Check if port 27017 is available
- Verify MONGO_URL in environment variables
- For Docker: `docker-compose down && docker-compose up`

### 3. Module Not Found (Python)

**Error**: "ModuleNotFoundError: No module named 'fastapi'"

**Solution**:
```bash
cd backend/auth-service
pip install -r requirements.txt

cd ../blog-service
pip install -r requirements.txt
```

### 4. npm Install Fails

**Error**: "npm ERR!" during installation

**Solution**:
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

### 5. CORS Error in Browser

**Error**: "Access to XMLHttpRequest blocked by CORS policy"

**Solution**:
- Verify backend services are running
- Check CORS configuration in main.py files
- Ensure frontend is accessing correct URLs
- Clear browser cache

### 6. JWT Token Invalid

**Error**: "Invalid token" or "Token expired"

**Solution**:
```javascript
// Clear localStorage and login again
localStorage.clear();
// Then refresh page and login
```

### 7. Docker Build Fails

**Error**: "failed to solve with frontend dockerfile.v0"

**Solution**:
```bash
# Clean Docker cache
docker system prune -a

# Rebuild
docker-compose build --no-cache
docker-compose up
```

### 8. Frontend Shows Blank Page

**Error**: White screen or blank page

**Solution**:
- Check browser console for errors (F12)
- Verify all services are running
- Check if React app compiled successfully
- Clear browser cache and reload

### 9. Cannot Create Blog

**Error**: "Failed to save blog" or 401 Unauthorized

**Solution**:
- Verify you're logged in
- Check if token is stored: `localStorage.getItem('token')`
- Ensure blog service is running on port 8002
- Check browser console for detailed error

### 10. Dashboard Shows 0 Blogs

**Issue**: Created blogs but dashboard shows 0

**Solution**:
- Refresh the page
- Check if blogs are visible in "My Blogs" page
- Verify blog status (draft vs published)
- Check MongoDB data: `db.blogs.find()`

## Service-Specific Issues

### Auth Service (Port 8001)

**Check if running**:
```bash
curl http://localhost:8001/docs
```

**Common issues**:
- SECRET_KEY not set
- MongoDB connection failed
- Port 8001 already in use

### Blog Service (Port 8002)

**Check if running**:
```bash
curl http://localhost:8002/docs
```

**Common issues**:
- Cannot connect to auth service
- MongoDB connection failed
- Port 8002 already in use

### Frontend (Port 3000)

**Check if running**:
Open http://localhost:3000 in browser

**Common issues**:
- npm dependencies not installed
- Port 3000 already in use
- Backend services not running

## MongoDB Issues

### Check MongoDB Status

**Windows**:
```bash
# Check if MongoDB service is running
sc query MongoDB

# Start MongoDB service
net start MongoDB
```

**Docker**:
```bash
docker ps | grep mongo
```

### Access MongoDB Shell

```bash
# Local MongoDB
mongosh

# Docker MongoDB
docker exec -it blog-mongodb mongosh
```

### View Data

```javascript
use blog_db
db.users.find()
db.blogs.find()
```

### Clear Data (Reset)

```javascript
use blog_db
db.users.deleteMany({})
db.blogs.deleteMany({})
```

## Docker Issues

### Container Won't Start

```bash
# View logs
docker-compose logs auth-service
docker-compose logs blog-service
docker-compose logs frontend

# Restart specific service
docker-compose restart auth-service
```

### Remove All Containers

```bash
docker-compose down -v
docker-compose up --build
```

## Network Issues

### Services Can't Communicate

**Solution**:
- Ensure all services are on same Docker network
- Check service names in docker-compose.yml
- Verify environment variables (AUTH_SERVICE_URL)

### Frontend Can't Reach Backend

**Solution**:
- Check if using correct URLs (localhost:8001, localhost:8002)
- Verify CORS is enabled in backend
- Check browser network tab for failed requests

## Performance Issues

### Slow Response Times

**Solution**:
- Check MongoDB indexes
- Monitor Docker resource usage
- Increase Docker memory allocation
- Use production build for React

### High Memory Usage

**Solution**:
```bash
# Limit Docker memory
docker-compose down
# Edit docker-compose.yml, add:
# mem_limit: 512m
docker-compose up
```

## Development Tips

### Hot Reload Not Working

**Backend**:
- Ensure `--reload` flag is used
- Check if file changes are saved

**Frontend**:
- Restart npm start
- Clear node_modules and reinstall

### API Documentation

Access interactive API docs:
- Auth Service: http://localhost:8001/docs
- Blog Service: http://localhost:8002/docs

### Debug Mode

**Backend**:
```python
# Add to main.py
import logging
logging.basicConfig(level=logging.DEBUG)
```

**Frontend**:
```javascript
// Add console logs
console.log('Token:', localStorage.getItem('token'));
```

## Getting Help

If issues persist:

1. Check logs:
   - Backend: Terminal output
   - Frontend: Browser console (F12)
   - Docker: `docker-compose logs`

2. Verify versions:
   - Python: `python --version` (should be 3.11+)
   - Node: `node --version` (should be 20+)
   - MongoDB: `mongosh --version` (should be 7.0+)

3. Check GitHub issues or create new one

4. Review README.md and QUICKSTART.md

## Quick Reset

To start fresh:

```bash
# Stop all services
docker-compose down -v

# Remove all data
# MongoDB data will be cleared

# Rebuild and start
docker-compose up --build
```

---

**Still having issues?** Check the logs carefully - they usually contain the exact error message and solution!
