# 🚀 Dockerized Marketing PHP Laravel Service

A fully containerized **PHP Laravel** marketing application using **Docker** and **Docker Compose**, deployed live on **AWS EC2 (Mumbai Region)**. This project follows industry best practices for containerization including multi-stage Dockerfiles, non-root users, Alpine base images, and Redis-powered sessions and caching.

---

## 🌐 Live Demo

**URL:** [http://13.126.33.236](http://13.126.33.236)

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Docker Services](#docker-services)
- [Deployment on AWS EC2](#deployment-on-aws-ec2)
- [Useful Commands](#useful-commands)

---

## 📌 About the Project

**Problem Statement:** Containerize a Marketing service built with PHP Laravel using industry best practices for Docker.

This project includes:
- ✅ Multi-stage Dockerfile to optimize image size and security
- ✅ Docker Compose to orchestrate the app and its dependencies
- ✅ Nginx as the web server (reverse proxy)
- ✅ MySQL 8.0 as the relational database
- ✅ Redis for sessions, caching, and queues
- ✅ Non-root user inside the container for security
- ✅ Deployed live on AWS EC2 Free Tier (t3.micro)

---

## 🛠️ Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | PHP Laravel | 11.x |
| Language | PHP | 8.2 |
| Web Server | Nginx | Alpine |
| Database | MySQL | 8.0 |
| Cache / Session | Redis | Alpine |
| Containerization | Docker | 24.x |
| Orchestration | Docker Compose | 1.x |
| Cloud | AWS EC2 | t3.micro |
| OS | Ubuntu | 24.04 LTS |

---

## 🏗️ Architecture

```
User / Browser
      ↕  Port 80
AWS Security Group (Firewall)
      ↕
AWS EC2 Instance — Ubuntu 24.04 LTS — Elastic IP: 13.126.33.236
      ↕
┌─────────────────────────────────────────────────┐
│         Docker Network: marketing_network        │
│                                                  │
│  ┌──────────┐   ┌──────────┐   ┌─────────────┐  │
│  │  Nginx   │──▶│ PHP-FPM  │──▶│   MySQL 8.0 │  │
│  │  :80     │   │ Laravel  │   │   :3306      │  │
│  │          │   │  :9000   │──▶│   Redis      │  │
│  └──────────┘   └──────────┘   │   :6379      │  │
│                                └─────────────┘  │
└─────────────────────────────────────────────────┘
```

**Request Flow:**
1. Browser hits `http://13.126.33.236`
2. AWS Security Group allows port 80
3. Nginx receives the request
4. Nginx passes PHP files to PHP-FPM on port 9000
5. Laravel processes the request
6. Laravel queries MySQL / Redis as needed
7. Response travels back through Nginx to the browser

---

## 📁 Project Structure

```
marketing-app/
│
├── app/                          # Laravel application core
│   ├── Http/Controllers/         # Request controllers
│   ├── Http/Middleware/          # HTTP middleware
│   └── Models/                   # Eloquent models
│
├── config/                       # Laravel config files
├── database/
│   └── migrations/               # Database migration files
├── docker/
│   └── nginx/
│       └── nginx.conf            # ⭐ Nginx virtual host config
├── public/
│   └── index.php                 # Application entry point
├── resources/views/              # Blade templates
├── routes/
│   ├── web.php                   # Web routes
│   └── api.php                   # API routes
├── storage/logs/                 # Application logs
│
├── .env.example                  # ⭐ Environment variable template
├── .gitignore
├── Dockerfile                    # ⭐ Multi-stage Docker build
├── docker-compose.yml            # ⭐ Container orchestration
├── composer.json                 # PHP dependencies
└── artisan                       # Laravel CLI
```

---

## ⚡ Getting Started

### Prerequisites

Make sure you have installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### 1. Clone the repository

```bash
git clone https://github.com/Ayush-js/marketing-laravel-docker.git
cd marketing-laravel-docker
```

### 2. Set up environment file

```bash
cp .env.example .env
```

Update `.env` with your values (see [Environment Variables](#environment-variables) section).

### 3. Build and start all containers

```bash
docker-compose up -d --build
```

### 4. Generate application key

```bash
docker-compose exec app php artisan key:generate
```

### 5. Run database migrations

```bash
docker-compose exec app php artisan migrate --force
```

### 6. Cache for production

```bash
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache
```

### 7. Visit the app

Open your browser and go to: `http://localhost`

---

## 🔐 Environment Variables

Copy `.env.example` to `.env` and update these key variables:

```env
APP_NAME=MarketingApp
APP_ENV=production
APP_KEY=                        # Auto-generated by artisan key:generate
APP_DEBUG=false
APP_URL=http://your-server-ip

DB_CONNECTION=mysql
DB_HOST=db                      # Docker service name
DB_PORT=3306
DB_DATABASE=marketing_db
DB_USERNAME=marketing_user
DB_PASSWORD=marketing_password

SESSION_DRIVER=redis
CACHE_STORE=redis
QUEUE_CONNECTION=redis

REDIS_CLIENT=predis
REDIS_HOST=redis                # Docker service name
REDIS_PORT=6379
```

> ⚠️ **Never commit your `.env` file to GitHub. It contains secrets!**

---

## 🐳 Docker Services

| Service | Container Name | Image | Port | Role |
|---------|---------------|-------|------|------|
| app | marketing_app | Custom Dockerfile | 9000 (internal) | PHP-FPM Laravel App |
| nginx | marketing_nginx | nginx:alpine | 80:80 | Web Server / Reverse Proxy |
| db | marketing_db | mysql:8.0 | 3306:3306 | MySQL Database |
| redis | marketing_redis | redis:alpine | 6379:6379 | Cache / Session / Queue |

### Multi-Stage Dockerfile

The Dockerfile uses **2 stages**:

| Stage | Purpose |
|-------|---------|
| `builder` | Installs Composer, Node, all PHP extensions, builds the app |
| `production` | Clean minimal image, copies only built files, runs as non-root user `www` |

This results in a **smaller, more secure** production image.

---

## ☁️ Deployment on AWS EC2

This project is deployed on **AWS EC2 Free Tier**:

| Property | Value |
|----------|-------|
| Instance | t3.micro |
| Region | ap-south-1 (Mumbai) |
| OS | Ubuntu 24.04 LTS |
| Storage | 20 GB gp3 SSD |
| Elastic IP | 13.126.33.236 |

### Connect to EC2 (Windows PowerShell)

```powershell
ssh -i "C:\Users\yourname\.ssh\your-key.pem" ubuntu@13.126.33.236
```

### Security Group Rules

| Type | Port | Source |
|------|------|--------|
| SSH | 22 | Your IP |
| HTTP | 80 | 0.0.0.0/0 |
| Custom TCP | 8000 | 0.0.0.0/0 |
| MySQL | 3306 | 0.0.0.0/0 |
| Redis | 6379 | 0.0.0.0/0 |

---

## 🧰 Useful Commands

```bash
# Start all containers
docker-compose up -d

# Stop all containers
docker-compose down

# Rebuild and start
docker-compose up -d --build

# View running containers
docker-compose ps

# View logs
docker-compose logs -f

# View logs of specific container
docker-compose logs -f nginx

# Run artisan commands
docker-compose exec app php artisan <command>

# Access MySQL inside container
docker-compose exec db mysql -u marketing_user -p marketing_db

# Access Redis CLI
docker-compose exec redis redis-cli

# Restart a specific container
docker-compose restart nginx
```

---

## 👨‍💻 Author

**Ayush**
- GitHub: [@Ayush-js](https://github.com/Ayush-js)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
