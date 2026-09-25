# Fase di build
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Fase di esecuzione con l'immagine standard di Dart
FROM dart:stable

WORKDIR /app

# Copia l'applicazione compilata dalla fase precedente
COPY --from=build /app/build/ /app/

EXPOSE 8080
ENV PORT=8080

# Avvia il server eseguendo il file binario compilato
CMD ["/app/bin/server"]
