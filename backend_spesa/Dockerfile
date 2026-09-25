# 1. Fase di Build
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

# Compilazione di produzione con Dart Frog
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# 2. Fase di Runtime con Debian slim pulito
FROM debian:bookworm-slim

WORKDIR /app

# Copia l'eseguibile e i file necessari generati dal build di Dart Frog
COPY --from=build /app/build/ /app/

EXPOSE 8080
ENV PORT=8080

# Avvia il server usando il runtime di sistema o l'eseguibile nativo
CMD ["/app/bin/server"]
