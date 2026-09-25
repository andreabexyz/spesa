# Official Dart image
FROM dart:stable AS build

# Set directory dentro il container
WORKDIR /app

# Copia le dipendenze (relativamente a backend_spesa/)
COPY pubspec.* ./
COPY pubspec_overrides.yaml* ./
RUN dart pub get

# Copia l'intero codice sorgente della cartella backend_spesa/
COPY . .

# Allinea le dipendenze e compila l'eseguibile server.dart
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Immagine finale minimale per la produzione
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Avvio del server
CMD ["/app/bin/server"]
