import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spesa_app/database_helper.dart';
import 'package:spesa_app/main.dart';

class _FakeDatabaseHelper extends DatabaseHelper {
  _FakeDatabaseHelper(this._provaBackend);

  final Future<List<Map<String, dynamic>>?> Function() _provaBackend;

  @override
  Future<List<Map<String, dynamic>>?> provaBackend() => _provaBackend();
}

void main() {
  testWidgets('shows the list while the backend is starting', (tester) async {
    final backend = Completer<List<Map<String, dynamic>>?>();
    await tester.pumpWidget(
      MaterialApp(
        home: SchermataSpesa(
          databaseHelper: _FakeDatabaseHelper(() => backend.future),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Lista Spesa'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);

    backend.complete([]);
    await tester.pump();
    await tester.pump();
    expect(find.text('Lista Spesa'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  });
}
