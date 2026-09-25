FROM dart:stable

WORKDIR /app

# Copia i file di configurazione delle dipendenze e scaricale
COPY pubspec.* ./
RUN dart pub get

# Copia tutto il resto del codice sorgente del backend
COPY . .

# Attiva la CLI e compila/avvia direttamente
RUN dart pub global activate dart_frog_cli

EXPOSE 8080
ENV PORT=8080

# Avvia il server di produzione di Dart Frog
CMD ["sh", "-c", "dart pub global run dart_frog_cli:dart_frog start --port 8080"]
