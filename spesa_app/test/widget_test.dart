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
  testWidgets('shows image 3 for at least three seconds', (tester) async {
    final backend = Completer<List<Map<String, dynamic>>?>();
    await tester.pumpWidget(
      MaterialApp(
        home: SchermataSpesa(
          databaseHelper: _FakeDatabaseHelper(() => backend.future),
        ),
      ),
    );
    backend.complete([]);
    await tester.pump();

    expect(
      (tester.widget<Image>(find.byType(Image)).image as AssetImage).assetName,
      'assets/icons/3.jpg',
    );

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Lista Spesa'), findsOneWidget);
  });

  testWidgets('cycles through images while the backend is unavailable', (
    tester,
  ) async {
    final backend = Completer<List<Map<String, dynamic>>?>();
    await tester.pumpWidget(
      MaterialApp(
        home: SchermataSpesa(
          databaseHelper: _FakeDatabaseHelper(() => backend.future),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 3));
    for (final image in ['0.jpg', '1.jpg', '2.jpg', '3.jpg']) {
      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        'assets/icons/$image',
      );
      await tester.pump(const Duration(milliseconds: 500));
    }

    backend.complete([]);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Lista Spesa'), findsOneWidget);
  });
}
