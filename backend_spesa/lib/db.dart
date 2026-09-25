import 'dart:io';
import 'package:mysql1/mysql1.dart';

class DatabaseService {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: Platform.environment['DB_HOST'] ?? 'spesa-andreabexyz-226d.e.aivencloud.com',
      port: int.tryParse(Platform.environment['DB_PORT'] ?? '25906') ?? 25906,
      user: Platform.environment['DB_USER'] ?? 'avnadmin',
      password: Platform.environment['DB_PASSWORD'] ?? '',
      db: Platform.environment['DB_NAME'] ?? 'defaultdb',
      useSSL: true, // Necessario per la connessione SSL REQUIRED di Aiven
    );

    return await MySqlConnection.connect(settings);
  }
}
