Karion Chat (Flutter) - Ready for GitHub Codespaces

This project is preconfigured with your google-services.json for Android.

Build steps in Codespaces:
1. Create a new Git repository and push this project.
2. Open the repo in GitHub Codespaces (or Gitpod) with Flutter SDK.
3. Run:
   flutter pub get
   flutter build apk --release
4. After build completes, download the APK from:
   build/app/outputs/flutter-apk/app-release.apk

Notes:
- google-services.json is already included at android/app/google-services.json.
- No code edits required. The project uses package id com.karionchat.app.
