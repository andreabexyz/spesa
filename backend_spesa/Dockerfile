# 1. Fase di Build
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# 2. Fase di Runtime
FROM dart:stable

WORKDIR /app

# Copia l'output della build di Dart Frog
COPY --from=build /app/build/ /app/

EXPOSE 8080
ENV PORT=8080

# Esegue direttamente il server compilato da Dart Frog
CMD ["dart", "bin/server.dart"]
