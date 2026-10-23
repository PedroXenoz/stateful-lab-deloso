
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_lab_deloso/main.dart';

void main() {
  testWidgets('QuickCart displays shopping items',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(
      const Size(1000, 1000),
    );

    await tester.pumpWidget(const QuickCartApp());

    expect(find.text('QuickCart'), findsOneWidget);
    expect(find.text('My Shopping List'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Eggs'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Total: PHP 311.00'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
