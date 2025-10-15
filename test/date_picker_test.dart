import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('Date picker functionality test', (WidgetTester tester) async {
    // Build a simple widget with date picker
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  print(
                    'Date picked: ${DateFormat('MMM dd, yyyy').format(picked)}',
                  );
                }
              },
              child: const Text('Select Date'),
            ),
          ),
        ),
      ),
    );

    // Verify the button is present
    expect(find.text('Select Date'), findsOneWidget);

    // Tap the button to open date picker
    await tester.tap(find.text('Select Date'));
    await tester.pumpAndSettle();

    // Verify date picker dialog is shown
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
