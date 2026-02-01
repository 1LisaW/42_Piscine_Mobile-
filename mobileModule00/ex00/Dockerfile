FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=$PATH:/opt/flutter/bin

# System deps
RUN apt-get update && apt-get install -y \
    curl git unzip zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter

# Pre-cache web artifacts
RUN flutter config --enable-web
RUN flutter doctor

WORKDIR /app
