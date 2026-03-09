@echo off
echo Starting Blog Microservices Platform...
echo.

echo Make sure MongoDB is running on localhost:27017
echo.

echo Starting Auth Service on port 8001...
start cmd /k "cd backend\auth-service && pip install -r requirements.txt && uvicorn main:app --host 0.0.0.0 --port 8001 --reload"

timeout /t 3 /nobreak >nul

echo Starting Blog Service on port 8002...
start cmd /k "cd backend\blog-service && pip install -r requirements.txt && uvicorn main:app --host 0.0.0.0 --port 8002 --reload"

timeout /t 3 /nobreak >nul

echo Starting Frontend on port 3000...
start cmd /k "cd frontend && npm install && npm start"

echo.
echo All services are starting...
echo Frontend: http://localhost:3000
echo Auth Service: http://localhost:8001
echo Blog Service: http://localhost:8002
echo.
pause
