# System Architecture

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER BROWSER                             │
│                     http://localhost:3000                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ HTTP/REST
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                      REACT FRONTEND                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │  Login   │  │  Signup  │  │Dashboard │  │BlogEditor│       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
│  ┌──────────┐  ┌──────────────────────────────────────┐       │
│  │BlogList  │  │      React Router + Axios            │       │
│  └──────────┘  └──────────────────────────────────────┘       │
└────────────────────┬──────────────────┬─────────────────────────┘
                     │                  │
                     │                  │
        ┌────────────▼─────┐   ┌────────▼──────────┐
        │  Auth Service    │   │  Blog Service     │
        │  Port: 8001      │   │  Port: 8002       │
        │                  │   │                   │
        │  - Signup        │   │  - Create Blog    │
        │  - Login         │   │  - Edit Blog      │
        │  - Verify Token  │   │  - Delete Blog    │
        │                  │   │  - List Blogs     │
        │  FastAPI         │   │  - Dashboard      │
        │  + JWT           │◄──┤  Stats            │
        │  + Bcrypt        │   │                   │
        └────────┬─────────┘   │  FastAPI          │
                 │             │  + HTTP Client    │
                 │             └────────┬──────────┘
                 │                      │
                 │                      │
                 └──────────┬───────────┘
                            │
                            │
                   ┌────────▼─────────┐
                   │    MongoDB       │
                   │  Port: 27017     │
                   │                  │
                   │  Collections:    │
                   │  - users         │
                   │  - blogs         │
                   │                  │
                   │  Motor (Async)   │
                   └──────────────────┘
```

## Request Flow

### 1. User Signup/Login Flow
```
User → Frontend → Auth Service → MongoDB
                       ↓
                   JWT Token
                       ↓
                   Frontend (localStorage)
```

### 2. Create/Edit Blog Flow
```
User → Frontend (with JWT) → Blog Service → Verify Token (Auth Service)
                                   ↓
                              Save to MongoDB
                                   ↓
                              Return Success
```

### 3. Dashboard Stats Flow
```
User → Frontend (with JWT) → Blog Service → Verify Token
                                   ↓
                          Count Documents (MongoDB)
                                   ↓
                          Return Statistics
```

## Data Flow

### Authentication
```
1. User enters credentials
2. Frontend sends POST to /signup or /login
3. Auth Service validates and hashes password
4. MongoDB stores/verifies user data
5. Auth Service generates JWT token
6. Frontend stores token in localStorage
7. All subsequent requests include token in headers
```

### Blog Operations
```
1. User creates/edits blog
2. Frontend sends request with JWT token
3. Blog Service extracts token from header
4. Blog Service calls Auth Service to verify token
5. Auth Service validates and returns user info
6. Blog Service performs operation on MongoDB
7. Response sent back to Frontend
8. UI updates with new data
```

## Technology Stack Layers

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER                │
│  React 18 + React Router 6 + Axios         │
│  Modern CSS with Gradients                  │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│           APPLICATION LAYER                 │
│  FastAPI Microservices                      │
│  - Auth Service (JWT, Bcrypt)              │
│  - Blog Service (CRUD, Stats)              │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│           DATA LAYER                        │
│  MongoDB 7.0 (NoSQL)                       │
│  Motor (Async Driver)                       │
│  Collections: users, blogs                  │
└─────────────────────────────────────────────┘
```

## Security Architecture

```
┌──────────────────────────────────────────────┐
│  Security Measures                           │
├──────────────────────────────────────────────┤
│  1. Password Hashing (Bcrypt)               │
│     - Passwords never stored in plain text   │
│     - Salt rounds: 12                        │
├──────────────────────────────────────────────┤
│  2. JWT Authentication                       │
│     - Stateless token-based auth            │
│     - Token expiry: 24 hours                │
│     - Signed with SECRET_KEY                │
├──────────────────────────────────────────────┤
│  3. CORS Configuration                       │
│     - Restricted origins                     │
│     - Credentials allowed                    │
├──────────────────────────────────────────────┤
│  4. Input Validation                         │
│     - Pydantic models                        │
│     - Email validation                       │
│     - Type checking                          │
├──────────────────────────────────────────────┤
│  5. Authorization                            │
│     - Token verification on all routes       │
│     - User ownership validation              │
└──────────────────────────────────────────────┘
```

## Deployment Architecture (Docker)

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Host                          │
│                                                         │
│  ┌──────────────────────────────────────────────────┐ │
│  │            Docker Network (blog-network)         │ │
│  │                                                  │ │
│  │  ┌──────────────┐  ┌──────────────┐            │ │
│  │  │   Frontend   │  │ Auth Service │            │ │
│  │  │  Container   │  │  Container   │            │ │
│  │  │  Port: 3000  │  │  Port: 8001  │            │ │
│  │  └──────────────┘  └──────────────┘            │ │
│  │                                                  │ │
│  │  ┌──────────────┐  ┌──────────────┐            │ │
│  │  │ Blog Service │  │   MongoDB    │            │ │
│  │  │  Container   │  │  Container   │            │ │
│  │  │  Port: 8002  │  │  Port: 27017 │            │ │
│  │  └──────────────┘  └──────────────┘            │ │
│  │                                                  │ │
│  └──────────────────────────────────────────────────┘ │
│                                                         │
│  Volume: mongodb_data (Persistent Storage)             │
└─────────────────────────────────────────────────────────┘
```

## API Endpoints Map

```
Auth Service (8001)
├── POST   /signup          → Create new user
├── POST   /login           → Authenticate user
└── GET    /verify          → Verify JWT token

Blog Service (8002)
├── POST   /blogs           → Create new blog
├── GET    /blogs           → List all user blogs
├── GET    /blogs/{id}      → Get specific blog
├── PUT    /blogs/{id}      → Update blog
├── DELETE /blogs/{id}      → Delete blog
└── GET    /dashboard/stats → Get statistics
```

## Database Schema

```
MongoDB (blog_db)
│
├── users
│   ├── _id: ObjectId
│   ├── email: String (unique)
│   ├── password: String (hashed)
│   ├── name: String
│   └── created_at: DateTime
│
└── blogs
    ├── _id: ObjectId
    ├── title: String
    ├── content: String
    ├── status: String (draft|published)
    ├── author_id: String
    ├── author_email: String
    ├── created_at: DateTime
    └── updated_at: DateTime
```

## Component Hierarchy (Frontend)

```
App
├── Router
│   ├── Login
│   │   └── Form (email, password)
│   ├── Signup
│   │   └── Form (name, email, password)
│   ├── Dashboard
│   │   ├── Navbar
│   │   └── Stats Cards (published, drafts, total)
│   ├── BlogList
│   │   ├── Navbar
│   │   └── Blog Items (title, status, actions)
│   └── BlogEditor
│       ├── Navbar
│       ├── Title Input
│       ├── Content Textarea
│       └── Action Buttons (draft, publish)
```

## Scalability Considerations

```
Horizontal Scaling
├── Frontend: Multiple instances behind load balancer
├── Auth Service: Stateless, can scale independently
├── Blog Service: Stateless, can scale independently
└── MongoDB: Replica sets for high availability

Vertical Scaling
├── Increase container resources
├── Optimize database queries
└── Add caching layer (Redis)

Future Enhancements
├── API Gateway (Kong, AWS API Gateway)
├── Message Queue (RabbitMQ, Kafka)
├── Caching (Redis)
├── CDN for static assets
└── Load Balancer (Nginx, HAProxy)
```

---

This architecture provides:
- ✅ Separation of concerns
- ✅ Independent scalability
- ✅ Easy maintenance
- ✅ Security best practices
- ✅ Modern tech stack
- ✅ Production-ready design
