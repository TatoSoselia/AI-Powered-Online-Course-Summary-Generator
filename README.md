# 🚀 AI-Powered Online Course Summary Generator

[![Python](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115+-green.svg)](https://fastapi.tiangolo.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-blue.svg)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7+-red.svg)](https://redis.io/)
[![Docker](https://img.shields.io/badge/Docker-20+-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Transform your course content into intelligent summaries with AI-powered analysis**

## 📖 Overview

The **AI-Powered Online Course Summary Generator** is a high-performance REST API that leverages OpenAI's GPT-4 to automatically generate intelligent summaries of online course content. Built with modern Python frameworks, it provides a robust, scalable solution for educators and content creators to enhance their course materials.

### ✨ Key Features

- 🤖 **AI-Powered Summarization**: Uses OpenAI GPT-4 to generate intelligent course summaries
- ⚡ **Asynchronous Processing**: Background task processing with Celery and Redis
- 🔐 **Secure Authentication**: JWT-based user authentication and authorization
- 📊 **Rate Limiting**: Intelligent throttling (3 summaries per user per day)
- 🐳 **Dockerized**: Complete containerized setup for easy deployment
- 📈 **Scalable Architecture**: Built with FastAPI for high performance
- 🔄 **Database Migrations**: Automated schema management with Alembic
- 🛡️ **Code Quality**: Pre-commit hooks for consistent code standards

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   FastAPI App   │    │   Celery Worker │    │   Redis Broker  │
│   (Port 8000)   │◄──►│   (Background)  │◄──►│   (Port 6379)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │   OpenAI API    │    │   User Browser  │
│   (Port 5432)   │    │   (GPT-4)       │    │   (Frontend)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🛠️ Tech Stack

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| **Backend Framework** | FastAPI | 0.115+ | High-performance async API |
| **Database** | PostgreSQL | 16+ | Primary data storage |
| **ORM** | SQLAlchemy + Alembic | 2.0+ | Database operations & migrations |
| **Task Queue** | Celery + Redis | 5.5+ | Background job processing |
| **AI Engine** | OpenAI GPT-4 | Latest | Intelligent summarization |
| **Authentication** | JWT (PyJWT) | 2.10+ | Secure user sessions |
| **Validation** | Pydantic | 2.11+ | Data validation & serialization |
| **Containerization** | Docker + Docker Compose | Latest | Deployment & orchestration |
| **Code Quality** | Black, isort, flake8 | Latest | Code formatting & linting |

## 🚀 Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (20.0+)
- [Docker Compose](https://docs.docker.com/compose/install/) (2.0+)
- [Git](https://git-scm.com/downloads) (2.0+)

### 1. Clone the Repository

```bash
git clone https://github.com/TatoSoselia/AI-Powered-Online-Course-Summary-Generator.git
cd AI-Powered-Online-Course-Summary-Generator
```

### 2. Environment Setup

```bash
# Copy environment template
cp .env.sample .env

# Edit environment variables
nano .env  # or use your preferred editor
```

**Required Environment Variables:**
```env
# Database
DATABASE_URL=postgresql://user:password@postgres:5432/course_summarizer
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_DB=course_summarizer

# Redis
REDIS_URL=redis://redis:6379/0

# OpenAI
OPENAI_API_KEY=your_openai_api_key

# JWT
SECRET_KEY=your_secret_key_here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### 3. Launch the Application

```bash
# Build and start all services
make build
make run
```

### 4. Access the Application

- 🌐 **API Documentation**: [http://localhost:8000/docs](http://localhost:8000/docs)
- 🔍 **Alternative Docs**: [http://localhost:8000/redoc](http://localhost:8000/redoc)
- 💚 **Health Check**: [http://localhost:8000/](http://localhost:8000/)

## 📚 API Endpoints

### 🔐 Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `POST` | `/users` | Register new user | ❌ |
| `POST` | `/users/login` | User login | ❌ |
| `POST` | `/users/refresh` | Refresh JWT tokens | ✅ |
| `POST` | `/users/change-password` | Change password | ✅ |
| `GET` | `/users/me` | Get current user info | ✅ |

### 📖 Course Management

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `POST` | `/courses` | Create new course | ✅ |
| `GET` | `/courses` | List user's courses | ✅ |
| `GET` | `/courses/{course_id}` | Get specific course | ✅ |
| `DELETE` | `/courses/{course_id}` | Delete course | ✅ |
| `PATCH` | `/courses/update-summary` | Update AI summary | ✅ |
| `POST` | `/generate_summary` | Generate AI summary | ✅ |

### 🏥 Health Checks

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Application health |
| `GET` | `/ping-db` | Database connectivity |
| `GET` | `/ping-redis` | Redis connectivity |

## 💡 Usage Examples

### User Registration

```bash
curl -X POST "http://localhost:8000/users" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "securepassword123"
  }'
```

### User Login

```bash
curl -X POST "http://localhost:8000/users/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "securepassword123"
  }'
```

### Create Course

```bash
curl -X POST "http://localhost:8000/courses" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "course_title": "Advanced Machine Learning",
    "course_description": "Comprehensive course covering deep learning, neural networks, and practical applications in real-world scenarios."
  }'
```

### Generate AI Summary

```bash
curl -X POST "http://localhost:8000/generate_summary" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "course_id": "your-course-uuid",
    "new_description": "Updated course description for AI analysis"
  }'
```

## 🛠️ Development

### Available Commands

```bash
# Build Docker images
make build                    # Build with cache
make build-no-cache          # Build without cache

# Run the application
make run                     # Start all services

# Database operations
make migrate                 # Apply migrations
make migrations name="msg"   # Generate new migration

# Code quality
make install_pre_commit      # Install pre-commit hooks
make run_pre_commit          # Run code quality checks
```

### Project Structure

```
├── app/                     # Main application package
│   ├── models/             # SQLAlchemy database models
│   │   ├── user.py         # User model
│   │   └── course.py       # Course model
│   ├── routes/             # API route handlers
│   │   ├── users.py        # User authentication routes
│   │   └── courses.py      # Course management routes
│   ├── schemas/            # Pydantic validation schemas
│   │   ├── user.py         # User request/response schemas
│   │   ├── course.py       # Course schemas
│   │   └── jwt.py          # JWT token schemas
│   ├── db/                 # Database configuration
│   │   ├── base.py         # Base model configuration
│   │   ├── session.py      # Database session management
│   │   └── redis.py        # Redis connection
│   ├── tasks/              # Celery background tasks
│   │   ├── summary.py      # AI summary generation
│   │   └── task.py         # Task utilities
│   ├── utils/              # Utility functions
│   │   ├── security.py     # Password hashing
│   │   ├── token.py        # JWT token handling
│   │   └── throttle.py     # Rate limiting
│   ├── main.py             # FastAPI application entry point
│   └── celery_worker.py    # Celery worker configuration
├── migrations/             # Database migration files
├── docker-compose.yaml     # Docker services orchestration
├── Dockerfile              # Application container definition
├── requirements.txt        # Python dependencies
├── Makefile                # Development commands
└── README.md              # This file
```

### Code Quality Standards

The project uses several tools to maintain code quality:

- **Black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting and style checking
- **pre-commit**: Automated quality checks

Run quality checks:
```bash
make run_pre_commit
```

## 🔧 Configuration

### Rate Limiting

- **AI Summary Generation**: 3 requests per user per day
- **Authentication**: Configurable via environment variables
- **Database Connections**: Pooled connections for optimal performance

### Security Features

- **JWT Authentication**: Secure token-based authentication
- **Password Hashing**: bcrypt-based password security
- **Input Validation**: Pydantic schema validation
- **Rate Limiting**: Protection against abuse
- **CORS**: Configurable cross-origin resource sharing

## 🐳 Docker Deployment

### Production Deployment

```bash
# Build production images
docker compose -f docker-compose.prod.yml build

# Start production services
docker compose -f docker-compose.prod.yml up -d
```

### Environment Variables

Create a `.env` file with the following variables:

```env
# Application
DEBUG=false
ENVIRONMENT=production

# Database
DATABASE_URL=postgresql://user:password@host:5432/dbname
POSTGRES_USER=dbuser
POSTGRES_PASSWORD=dbpassword
POSTGRES_DB=course_summarizer

# Redis
REDIS_URL=redis://redis:6379/0

# OpenAI
OPENAI_API_KEY=sk-your-openai-api-key

# JWT
SECRET_KEY=your-super-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Rate Limiting
DAILY_SUMMARY_LIMIT=3
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request
