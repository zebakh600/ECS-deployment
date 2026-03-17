from fastapi import FastAPI, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from motor.motor_asyncio import AsyncIOMotorClient
from datetime import datetime
from bson import ObjectId
import httpx
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
AUTH_SERVICE_URL = os.getenv("AUTH_SERVICE_URL", "https://ecs.zeba.click")

client = AsyncIOMotorClient(MONGO_URL, tlsCAFile=certifi.where())
db = client.blog_db

class BlogCreate(BaseModel):
    title: str
    content: str
    status: str

class BlogUpdate(BaseModel):
    title: str | None = None
    content: str | None = None
    status: str | None = None

async def verify_token(authorization: str):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid authorization header")
    token = authorization.split(" ")[1]
    try:
        async with httpx.AsyncClient(verify=certifi.where(), timeout=10.0) as http:
            response = await http.get(
                f"{AUTH_SERVICE_URL}/api/auth/verify",
                params={"token": token}
            )
            if response.status_code != 200:
                raise HTTPException(status_code=401, detail=f"Token invalid: {response.status_code}")
            data = response.json()
            return data
    except HTTPException:
        raise
    except httpx.TimeoutException:
        raise HTTPException(status_code=401, detail="Auth service timeout")
    except Exception as ex:
        raise HTTPException(status_code=401, detail=f"Auth error: {str(ex)}")

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/api/blog/blogs")
async def create_blog(blog: BlogCreate, authorization: str = Header(None)):
    user_data = await verify_token(authorization)
    blog_doc = {
        "title": blog.title,
        "content": blog.content,
        "status": blog.status,
        "author_id": user_data["user_id"],
        "author_email": user_data["email"],
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    result = await db.blogs.insert_one(blog_doc)
    blog_doc["_id"] = str(result.inserted_id)
    return blog_doc

@app.get("/api/blog/blogs")
async def get_blogs(authorization: str = Header(None), status: str = None):
    user_data = await verify_token(authorization)
    query = {"author_id": user_data["user_id"]}
    if status:
        query["status"] = status
    blogs = []
    async for blog in db.blogs.find(query).sort("updated_at", -1):
        blog["_id"] = str(blog["_id"])
        blogs.append(blog)
    return blogs

@app.get("/api/blog/blogs/{blog_id}")
async def get_blog(blog_id: str, authorization: str = Header(None)):
    user_data = await verify_token(authorization)
    blog = await db.blogs.find_one({"_id": ObjectId(blog_id), "author_id": user_data["user_id"]})
    if not blog:
        raise HTTPException(status_code=404, detail="Blog not found")
    blog["_id"] = str(blog["_id"])
    return blog

@app.put("/api/blog/blogs/{blog_id}")
async def update_blog(blog_id: str, blog: BlogUpdate, authorization: str = Header(None)):
    user_data = await verify_token(authorization)
    update_data = {k: v for k, v in blog.model_dump(exclude_unset=True).items()}
    if not update_data:
        raise HTTPException(status_code=400, detail="No data to update")
    update_data["updated_at"] = datetime.utcnow()
    result = await db.blogs.update_one(
        {"_id": ObjectId(blog_id), "author_id": user_data["user_id"]},
        {"$set": update_data}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Blog not found")
    return {"message": "Blog updated successfully"}

@app.delete("/api/blog/blogs/{blog_id}")
async def delete_blog(blog_id: str, authorization: str = Header(None)):
    user_data = await verify_token(authorization)
    result = await db.blogs.delete_one(
        {"_id": ObjectId(blog_id), "author_id": user_data["user_id"]}
    )
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Blog not found")
    return {"message": "Blog deleted successfully"}

@app.get("/api/blog/dashboard/stats")
async def get_dashboard_stats(authorization: str = Header(None)):
    user_data = await verify_token(authorization)
    published_count = await db.blogs.count_documents(
        {"author_id": user_data["user_id"], "status": "published"}
    )
    draft_count = await db.blogs.count_documents(
        {"author_id": user_data["user_id"], "status": "draft"}
    )
    return {
        "published": published_count,
        "drafts": draft_count,
        "total": published_count + draft_count
    }