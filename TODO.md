# Frontend Migration TODO

## Completed
- [ ]

## Pending Steps (from approved plan)

1. [x] **Migrate assets to frontend_user/**: Copy loginbackground.jpg, loginlogo.png → assets/images/, update pubspec.yaml
2. [x] **Create frontend_user/lib/features/feedback/services/feedback_service.dart**: Adapt mobile FeedbackService for web
3. [x] **Create frontend_user/lib/features/feedback/pages/thankyou_page.dart**: Copy/adapt mobile ThankYouScreen (fixed Dart errors)
4. [x] **Update frontend_user/lib/features/feedback/pages/feedback_page.dart**: Use glassmorphism design from mobile
5. [x] **Update frontend_user/lib/features/feedback/widgets/feedback_form.dart**: Integrate service, dynamic dropdowns, navigation
6. [x] **Update frontend_user/lib/routes/app_routes.dart**: Add /thankyou route
7. **Update frontend_user/pubspec.yaml**: Add dependencies if needed
8. **Add feedback to frontend_admin/**: Create feedback pages/services/routes (simplified)
9. **Run `flutter pub get` in frontend_user/ & frontend_admin/**
10. **Test both apps**: flutter run -d chrome
11. [x] **Delete frontend/ folder**
12. **Update TODO.md**: Mark complete, remove old refs

**Next: Step 5 - Update feedback_form.dart**

