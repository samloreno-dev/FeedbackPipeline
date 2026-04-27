# TODO: Feedback Validation & AI Multilingual Support

- [x] Step 1: Update `backend/app/Http/Controllers/FeedbackController.php` — 50-word limit, profanity filter, gibberish detection, multilingual AI prompt
- [x] Step 2: Update `frontend_new/lib/features/feedback/widgets/feedback_form.dart` — client-side 50-word limit, expanded profanity, gibberish check
- [x] Step 3: Update `frontend/adssbs_mobile_app/lib/screens/feedback_screen.dart` — change max words 20→50, add profanity + gibberish client-side

# TODO: Split frontend_new into Admin & User

- [x] Create `frontend_admin/` from `frontend_new/` — keep only admin features
- [x] Create `frontend_user/` from `frontend_new/` — keep only user/feedback features
- [x] Rename `main_admin.dart` → `main.dart` in `frontend_admin/`
- [x] Rename `main_user.dart` → `main.dart` in `frontend_user/`
- [x] Fix routing: admin routes only in `frontend_admin/`, user routes only in `frontend_user/`
- [x] Update `pubspec.yaml` names/descriptions for both projects
- [x] Update `backend/nginx/conf.d/default.conf` to serve `/frontend_admin/` and `/frontend_user/`
- [x] Copy `backend/public/frontend_new/` assets to both new paths and delete old
- [x] Clean generated build artifacts (`.dart_tool/`, `build/`, ephemeral files) from both projects



