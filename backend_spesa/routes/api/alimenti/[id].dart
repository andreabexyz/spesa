import 'dart:io';
import 'package:backend_spesa/db.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final idAlimento = int.tryParse(id);
  if (idAlimento == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'status': 'error', 'message': 'ID non valido'},
    );
  }

  switch (context.request.method) {
    case HttpMethod.put:
      return _updateAlimento(context, idAlimento);
    case HttpMethod.delete:
      return _deleteAlimento(idAlimento);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

// PUT /api/alimenti/:id -> Aggiorna lo stato (spuntato/non spuntato)
Future<Response> _updateAlimento(RequestContext context, int id) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final statoAlimento = body['statoAlimento'] as int?;

    final conn = await DatabaseService.getConnection();
    await conn.execute(
      'UPDATE listaSpesa SET statoAlimento = :stato WHERE idAlimento = :id',
      {
        'stato': statoAlimento,
        'id': id,
      },
    );
    await conn.close();

    return Response.json(body: {'status': 'success', 'message': 'Alimento aggiornato'});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'status': 'error', 'message': e.toString()},
    );
  }
}

// DELETE /api/alimenti/:id -> Elimina l'alimento dal database
Future<Response> _deleteAlimento(int id) async {
  try {
    final conn = await DatabaseService.getConnection();
    await conn.execute(
      'DELETE FROM listaSpesa WHERE idAlimento = :id',
      {'id': id},
    );
    await conn.close();

    return Response.json(body: {'status': 'success', 'message': 'Alimento eliminato'});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'status': 'error', 'message': e.toString()},
    );
  }
}
