# Quick Start Guide

## Fastest Way to Run (Using Docker)

1. Make sure Docker Desktop is installed and running
2. Open terminal in the project directory
3. Run: `docker-compose up --build`
4. Wait for all services to start
5. Open browser: http://localhost:3000

## Without Docker (Windows)

### Prerequisites
1. Install Python 3.11+ from python.org
2. Install Node.js 20+ from nodejs.org
3. Install MongoDB 7.0+ from mongodb.com

### Steps
1. Start MongoDB service
2. Double-click `start.bat` in the project root
3. Wait for all services to start
4. Open browser: http://localhost:3000

## Without Docker (Manual - All Platforms)

### Terminal 1 - Auth Service
```bash
cd backend/auth-service
pip install -r requirements.txt
uvicorn main:app --port 8001 --reload
```

### Terminal 2 - Blog Service
```bash
cd backend/blog-service
pip install -r requirements.txt
uvicorn main:app --port 8002 --reload
```

### Terminal 3 - Frontend
```bash
cd frontend
npm install
npm start
```

## First Time Usage

1. Go to http://localhost:3000
2. Click "Sign Up"
3. Create an account
4. Start creating blogs!

## Troubleshooting

**Port already in use:**
- Stop other services using ports 3000, 8001, 8002, 27017
- Or change ports in docker-compose.yml

**MongoDB connection error:**
- Make sure MongoDB is running
- Check connection string in environment variables

**Frontend can't connect to backend:**
- Verify all services are running
- Check browser console for errors
- Ensure CORS is properly configured

## Default Configuration

- Frontend: http://localhost:3000
- Auth Service: http://localhost:8001
- Blog Service: http://localhost:8002
- MongoDB: mongodb://localhost:27017
- Database Name: blog_db

## Testing the Application

1. **Sign Up**: Create account with email and password
2. **Dashboard**: View your blog statistics (0 initially)
3. **New Blog**: Click "New Blog" button
4. **Write**: Add title and content
5. **Save as Draft**: Click "Save as Draft" button
6. **Dashboard**: See draft count increase to 1
7. **My Blogs**: View your blog in the list
8. **Edit**: Click "Edit" button
9. **Publish**: Click "Publish" button
10. **Dashboard**: See published count increase to 1

Enjoy your blog platform! 🚀
