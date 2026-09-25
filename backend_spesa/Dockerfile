# Usa l'immagine ufficiale di Dart
FROM dart:stable AS build

WORKDIR /app

# Copia i file di configurazione delle dipendenze
COPY pubspec.* ./
RUN dart pub get

# Copia tutto il codice sorgente
COPY . .

# Attiva la CLI di Dart Frog e compila il pacchetto per la produzione
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Fase finale pulita e minimale
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/server

EXPOSE 8080
CMD ["/app/bin/server"]
