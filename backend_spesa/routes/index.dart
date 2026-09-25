import 'dart:convert';
import 'dart:io';
import 'package:backend_spesa/db.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getAlimenti();
    case HttpMethod.post:
      return _addAlimento(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

// GET /api/alimenti - Recupera tutti gli alimenti
Future<Response> _getAlimenti() async {
  try {
    final conn = await DatabaseService.getConnection();
    final results = await conn.execute('SELECT * FROM listaSpesa ORDER BY idAlimento DESC');
    await conn.close();

    final lista = results.rows.map((row) {
      final map = row.assoc();
      return {
        'idAlimento': int.tryParse(map['idAlimento'] ?? '0') ?? 0,
        'nomeAlimento': map['nomeAlimento'],
        'statoAlimento': int.tryParse(map['statoAlimento'] ?? '0') ?? 0,
      };
    }).toList();

    return Response.json(body: lista);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'status': 'error', 'message': e.toString()},
    );
  }
}

// POST /api/alimenti - Inserisce un nuovo alimento
Future<Response> _addAlimento(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final nomeAlimento = body['nomeAlimento'] as String?;
    final statoAlimento = body['statoAlimento'] as int? ?? 0;

    if (nomeAlimento == null || nomeAlimento.trim().isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'status': 'error', 'message': 'nomeAlimento è obbligatorio'},
      );
    }

    final conn = await DatabaseService.getConnection();
    await conn.execute(
      'INSERT INTO listaSpesa (nomeAlimento, statoAlimento) VALUES (:nome, :stato)',
      {
        'nome': nomeAlimento,
        'stato': statoAlimento,
      },
    );
    await conn.close();

    return Response.json(
      statusCode: HttpStatus.created,
      body: {'status': 'success', 'message': 'Alimento salvato!'},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'status': 'error', 'message': e.toString()},
    );
  }
}
