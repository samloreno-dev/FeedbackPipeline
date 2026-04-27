# Fixes Applied

## Backend
- [x] AdminUserSeeder.php: Removed `Hash::make()` — User model has `password => hashed` cast, so plain password is correct
- [x] composer.json: Added `openai-php/laravel` package dependency
- [x] config/app.php: Registered `OpenAIServiceProvider`
- [x] nginx/conf.d/default.conf: Removed trailing slashes from `alias` directives to prevent path traversal issues
- [x] FeedbackController.php: Added `index()` method for GET /feedback endpoint
- [x] api.php: Added `GET /feedback` route under `auth:sanctum` middleware
- [x] feedback.html: Rebuilt truncated/broken HTML file into a complete valid page

## Frontend (Admin)
- [x] manage_offices_page.dart: Made add/edit/delete operations async with API integration and success/error SnackBar feedback
- [x] admin_settings_page.dart: Made `_saveSettings` async with actual `ApiService.post('/settings')` call
- [x] admin_settings_page.dart: Fixed leading space before `import` (syntax error)
- [x] admin_login_page.dart: Already properly wired to `AuthService.login()` with error handling
- [x] admin_layout.dart: Already properly wired to `AuthService.logout()` with navigation

## Frontend (User)
- [x] feedback_form.dart: Made `submit()` async with actual `ApiService.post('/feedback')` call and error handling

## Mobile App
- [x] feedback_service.dart: Fixed `submitFeedback()` to send `message` field matching API contract
- [x] feedback_service.dart: Fixed `getOffices()` to correctly parse `{'data': [...]}` response structure
- [x] feedback_service.dart: Fixed `login()` endpoint from `/login` to `/admin/login`
- [x] feedback_service.dart: Replaced broken `getTypes()` HTTP call with local static data (no `/feedback-types` backend endpoint exists)
- [x] thankyou_screen.dart: Created missing screen referenced by mobile app routes
- [x] app_routes.dart: Already properly routes to `ThankYouScreen`

## Notes
- `frontend_new/` folder references in VSCode tabs are stale (files were split into `frontend_admin/` and `frontend_user/`). The Dart analyzer errors shown on those phantom references are false positives.
- `backend/cleanup_admin.php` does not exist — it's a stale VSCode tab.
- The Dart analyzer errors appearing across `frontend_admin/` and `frontend_user/` files ("Target of URI doesn't exist: package:flutter/material.dart") are false positives caused by the workspace not resolving Flutter SDK paths for these split subprojects. To resolve them in VS Code, open each subproject folder individually or configure a multi-root workspace.
- Admin dashboard and office pages currently use mock statistical data — this is a feature gap, not a code error. Real data integration would require additional backend analytics endpoints.

