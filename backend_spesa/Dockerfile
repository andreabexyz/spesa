FROM dart:stable

WORKDIR /app

# Copia tutto il progetto dentro il container
COPY . .

# Scarica le dipendenze localmente nel progetto
RUN dart pub get

# Compila l'applicazione con Dart Frog
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

EXPOSE 8080
ENV PORT=8080

# Avvia direttamente il server dalla cartella di build generata
CMD ["dart", "build/bin/server.dart"]
