# Official Dart image: https://hub.docker.com/_/dart
FROM dart:stable AS build

WORKDIR /app

# Copia i file di dipendenza partendo dalla cartella del backend
COPY backend_spesa/pubspec.* ./
COPY backend_spesa/pubspec_overrides.yaml* ./
RUN dart pub get

# Copia tutto il codice sorgente del backend dentro /app
COPY backend_spesa/ .

# Assicurati che le dipendenze siano allineate
RUN dart pub get --offline

# COMPILAZIONE: punta correttamente a bin/server.dart che ora si trova dentro /app/bin/
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Start server.
CMD ["/app/bin/server"]
