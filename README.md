# Blog Microservices Platform

A modern blog platform built with microservices architecture using Python FastAPI, React, and MongoDB.

## Features

- **User Authentication**: Sign up and login with JWT tokens
- **Blog Management**: Create, edit, delete blogs
- **Draft & Publish**: Save blogs as drafts or publish them
- **Dashboard**: View statistics of published blogs and drafts
- **Attractive UI**: Modern gradient design with responsive layout

## Tech Stack

### Backend
- **Python 3.11** with FastAPI
- **MongoDB 7.0** for database
- **JWT** for authentication
- **Motor** for async MongoDB operations
- **Passlib** with bcrypt for password hashing

### Frontend
- **React 18.2**
- **React Router 6** for navigation
- **Axios** for API calls
- **Modern CSS** with gradients

## Architecture

The application consists of 3 microservices:

1. **Auth Service** (Port 8001): Handles user signup, login, and token verification
2. **Blog Service** (Port 8002): Manages blog CRUD operations and dashboard stats
3. **Frontend** (Port 3000): React application

## Prerequisites

- Docker and Docker Compose
- OR
- Python 3.11+
- Node.js 20+
- MongoDB 7.0+

## Setup & Installation

### Option 1: Using Docker (Recommended)

1. Navigate to the project directory:
```bash
cd blog-microservices
```

2. Start all services:
```bash
docker-compose up --build
```

3. Access the application:
- Frontend: http://localhost:3000
- Auth Service: http://localhost:8001
- Blog Service: http://localhost:8002

### Option 2: Manual Setup

#### Backend Services

1. **Auth Service**:
```bash
cd backend/auth-service
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

2. **Blog Service**:
```bash
cd backend/blog-service
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8002 --reload
```

#### Frontend

```bash
cd frontend
npm install
npm start
```

#### MongoDB

Make sure MongoDB is running on localhost:27017

## Usage

1. **Sign Up**: Create a new account with name, email, and password
2. **Login**: Access your account
3. **Dashboard**: View your blog statistics
4. **Create Blog**: Write a new blog with title and content
5. **Save as Draft**: Save your work without publishing
6. **Publish**: Make your blog public
7. **Edit/Delete**: Manage your existing blogs

## API Endpoints

### Auth Service (8001)
- `POST /signup` - Create new user
- `POST /login` - User login
- `GET /verify` - Verify JWT token

### Blog Service (8002)
- `POST /blogs` - Create new blog
- `GET /blogs` - Get all user blogs
- `GET /blogs/{id}` - Get specific blog
- `PUT /blogs/{id}` - Update blog
- `DELETE /blogs/{id}` - Delete blog
- `GET /dashboard/stats` - Get dashboard statistics

## Environment Variables

### Auth Service
- `MONGO_URL`: MongoDB connection string (default: mongodb://localhost:27017)
- `SECRET_KEY`: JWT secret key (change in production!)

### Blog Service
- `MONGO_URL`: MongoDB connection string
- `AUTH_SERVICE_URL`: Auth service URL (default: http://localhost:8001)

## Security Notes

- Change the SECRET_KEY in production
- Use HTTPS in production
- Implement rate limiting for production
- Add input validation and sanitization
- Use environment variables for sensitive data

## Project Structure

```
blog-microservices/
├── backend/
│   ├── auth-service/
│   │   ├── main.py
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   └── blog-service/
│       ├── main.py
│       ├── requirements.txt
│       └── Dockerfile
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Login.js
│   │   │   ├── Signup.js
│   │   │   ├── Dashboard.js
│   │   │   ├── BlogList.js
│   │   │   └── BlogEditor.js
│   │   ├── App.js
│   │   ├── App.css
│   │   └── index.js
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml
└── README.md
```

## Future Enhancements

- Add rich text editor
- Implement blog categories and tags
- Add search functionality
- Enable blog comments
- Add user profiles
- Implement blog sharing
- Add image upload support
- Implement pagination

## License

MIT License
