import 'package:backend_spesa/db.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final conn = await DatabaseService.getConnection();
    final results = await conn.query('SELECT 1 + 1 AS result');
    await conn.close();

    final val = results.first['result'];
    return Response.json(
      body: {
        'status': 'success',
        'message': 'Connessione ad Aiven MySQL riuscita con successo!',
        'test_query_result': val,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'status': 'error',
        'message': 'Errore di connessione al DB: $e',
      },
    );
  }
}
