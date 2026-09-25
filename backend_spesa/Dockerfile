# Fase di build
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Fase di esecuzione con un'immagine Debian-slim leggera (evitiamo i problemi di scratch)
FROM debian:bookworm-slim

# Copia i runtime di Dart necessari e i binari compilati
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/ /app/bin/

# Espone la porta e forza Dart Frog adascoltare sulla porta fornita da Render (default 8080)
EXPOSE 8080
ENV PORT=8080

CMD ["/app/bin/server"]
