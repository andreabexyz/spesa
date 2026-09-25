# Fase di build
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Fase di esecuzione
FROM dart:stable

WORKDIR /app

# Copia l'intera cartella di build generata da Dart Frog
COPY --from=build /app/build/ /app/

EXPOSE 8080
ENV PORT=8080

# Avvia lo script server generato nella cartella bin della build
CMD ["dart", "bin/server.dart"]
