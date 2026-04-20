# ADSSBS Fullstack - Dockerized Backend

## Features
- **AI Analysis**: OpenAI GPT-4o-mini
- **Anti-Spam/Profanity**: Filters + blacklist
- **Flutter Apps**: Mobile/Admin UI

## Structure
- `backend/`: Laravel API + ai/ (Dockerized)
- `frontend/`: Flutter UIs

## Quick Local (XAMPP)
**Backend**: `cd backend && php artisan serve`
**Admin**: `cd frontend/adssbs_admin_web && flutter run -d chrome`
**Mobile**: `cd frontend/adssbs_mobile_app && flutter run`

## Docker Backend (Recommended)
```
cd backend
cp .env.example .env
# Edit .env: APP_URL=http://localhost:8080, DB_*, OPENAI_API_KEY
docker compose up -d --build
# Run migrations: docker compose exec app php artisan migrate
# Seed: docker compose exec app php artisan db:seed
```

API at http://localhost:8080/api/feedback  
MySQL: localhost:3307 (root/root, adssbs/password, db=adssbs)

**Flutter API base**: Update services to http://localhost:8080/api

## Deploy
- Backend: Docker to VPS/Forge (envoy/reverse proxy)
- Frontend: Build APKs/web separately

Done!
# FeedbackPipeline
