# Build stage
FROM ghcr.io/cirruslabs/flutter:3.38.6 AS build

WORKDIR /app

# Copy pubspec first to leverage layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get && flutter precache --web

# Copy the rest of the app
COPY . .

# Build Flutter web release
RUN flutter build web --release

# Serve stage
FROM nginx:alpine AS runtime

# Copy a minimal SPA-friendly nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build output
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
