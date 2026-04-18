#!/bin/bash

docker build -t flutter-web .

docker run \
  -p 8080:8080 \
  -v $(pwd):/app \
  flutter-web \
  bash -c "
    flutter pub get &&
    flutter run -d web-server \
      --web-hostname=0.0.0.0 \
      --web-port=8080
  "
