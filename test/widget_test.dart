import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test básico de renderização', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Dashboard')),
        ),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
  });
}
