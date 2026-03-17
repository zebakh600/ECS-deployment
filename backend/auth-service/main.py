from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from passlib.context import CryptContext
from jose import JWTError, jwt
from datetime import datetime, timedelta
from motor.motor_asyncio import AsyncIOMotorClient
import certifi
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://ecs.zeba.click", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MONGO_URL = os.getenv("MONGO_URL", "mongodb://localhost:27017")
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1440

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
client = AsyncIOMotorClient(MONGO_URL, tlsCAFile=certifi.where())
db = client.blog_db

class UserSignup(BaseModel):
    email: str
    password: str
    name: str

class UserLogin(BaseModel):
    email: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str
    user_id: str
    name: str

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/api/auth/signup", response_model=Token)
async def signup(user: UserSignup):
    existing = await db.users.find_one({"email": user.email})
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = pwd_context.hash(user.password)
    user_doc = {
        "email": user.email,
        "password": hashed_password,
        "name": user.name,
        "created_at": datetime.utcnow()
    }
    result = await db.users.insert_one(user_doc)
    user_id = str(result.inserted_id)
    access_token = create_access_token({"sub": user_id, "email": user.email})
    return Token(access_token=access_token, token_type="bearer", user_id=user_id, name=user.name)

@app.post("/api/auth/login", response_model=Token)
async def login(user: UserLogin):
    db_user = await db.users.find_one({"email": user.email})
    if not db_user or not pwd_context.verify(user.password, db_user["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    user_id = str(db_user["_id"])
    access_token = create_access_token({"sub": user_id, "email": user.email})
    return Token(access_token=access_token, token_type="bearer", user_id=user_id, name=db_user["name"])

@app.get("/api/auth/verify")
async def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return {"valid": True, "user_id": payload.get("sub"), "email": payload.get("email")}
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
