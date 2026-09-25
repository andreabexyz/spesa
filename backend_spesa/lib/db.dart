import 'dart:io';
import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  static Future<MySQLConnection> getConnection() async {
    final conn = await MySQLConnection.createConnection(
      host: Platform.environment['DB_HOST'] ?? 'spesa-andreabexyz-226d.e.aivencloud.com',
      port: int.tryParse(Platform.environment['DB_PORT'] ?? '25906') ?? 25906,
      userName: Platform.environment['DB_USER'] ?? 'avnadmin',
      password: Platform.environment['DB_PASSWORD'] ?? '',
      databaseName: Platform.environment['DB_NAME'] ?? 'defaultdb',
      secure: true, // Attiva la connessione protetta SSL/TLS richiesta da Aiven
    );

    // Apre la connessione
    await conn.connect();
    return conn;
  }
}
