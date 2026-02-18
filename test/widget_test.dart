import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example_state/main.dart';

void main() {
  testWidgets('Cart count increases when adding a product', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const SurgicalStoreApp());

    // Initial state: cart is empty.
    expect(find.text('Cart: 0'), findsOneWidget);

    // Tap the first "Add" button from the catalog.
    await tester.tap(find.text('Add').first);
    await tester.pump();

    // Now cart should have 1 item.
    expect(find.text('Cart: 1'), findsOneWidget);
  });

  testWidgets('FloatingActionButton opens add product dialog', (WidgetTester tester) async {
    await tester.pumpWidget(const SurgicalStoreApp());

    // Tap the FAB "+".
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Dialog should appear.
    expect(find.text('Add new product'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
