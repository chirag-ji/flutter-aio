# A docker image for building the flutter releases in runners

[flutter-aio](https://github.com/chirag-ji/flutter-aio) repository contains the container which can be used in runners
for building the releases in fewer efforts.

#### This repository includes:

- Flutter
- Android SDK
- JDK 17

##### This supports currently building the following:

- Android releases
- Web Builds

#### Usages:

- GitLab Runners
- GitHub Actions
- Gitea Actions

## Tags

------------------------------

Only **stable** branch is being built from [flutter](https://github.com/flutter/flutter) repository.

------------------------------

### Sample CI configuration scripts:

> .gitlab-ci.yml

    image: chiragji/flutter-aio:latest
    
    variables:
        GRADLE_USER_HOME: "$CI_PROJECT_DIR/.gradle"
    
    stages:
      - build-android

    build_android:
        stage: build-android
        script:
          - flutter --version
          - flutter pub get
          - echo "Generating the part dart classes"
          - dart run build_runner build --delete-conflicting-outputs # Build all the dependends
    
          # Build Android APK
          # - flutter build apk --release
          - flutter build appbundle
