# Start with a base Ubuntu image
FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Flutter
RUN git clone --single-branch -b stable https://github.com/flutter/flutter.git /opt/flutter
RUN /opt/flutter/bin/flutter precache
RUN /opt/flutter/bin/flutter config --no-analytics

ENV PATH="$PATH:/opt/flutter/bin"
ENV PATH="$PATH:/opt/flutter/bin/cache/dart-sdk/bin"
ENV PATH="$PATH:/app/.pub-cache/bin"

RUN flutter doctor

# Install JDK 17
RUN mkdir -p /opt/java
RUN wget -q https://cdn.azul.com/zulu/bin/zulu17.54.21-ca-jdk17.0.13-linux_x64.zip -O /tmp/jdk17.zip \
    && unzip /tmp/jdk17.zip -d /tmp/java \
    && mv /tmp/java/zulu17.54.21-ca-jdk17.0.13-linux_x64/* /opt/java/ \
    && rm -rf /tmp/java \
    && rm /tmp/jdk17.zip

# Set environment variables
ENV JAVA_HOME="/opt/java"
ENV PATH="$PATH:$JAVA_HOME\bin"

# Install Android SDK
RUN mkdir -p /opt/android-sdk/cmdline-tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-12266719_latest.zip -O /tmp/android_cmdline_tools.zip \
    && unzip /tmp/android_cmdline_tools.zip -d /opt/android-sdk/cmdline-tools \
    && rm /tmp/android_cmdline_tools.zip \
    && mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

# Set environment variables
ENV ANDROID_HOME="/opt/android-sdk"
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Accept licenses and install platforms
# Adjust as needed
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses || true
RUN yes | sdkmanager --licenses && sdkmanager "platform-tools" "platforms;android-35"

