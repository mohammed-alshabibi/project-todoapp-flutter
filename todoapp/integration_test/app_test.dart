import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete a user flow in To-Do App', (WidgetTester tester) async {
    // Launch the app
    await tester.pumpWidget(MyApp());

    // Verify HomePage is loaded
    expect(find.text('To-Do App'), findsOneWidget);

    // Tap on the floating action button to add a task
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify AddTaskPage is loaded
    expect(find.text('Add Task'), findsOneWidget);

    // Enter task details
    await tester.enterText(find.byType(TextField), 'Study for math exam');
    await tester.tap(find.text('Select').first);
    await tester.pumpAndSettle();

    // Confirm task is added and navigate back
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify task is displayed on HomePage
    expect(find.text('Study for math exam'), findsOneWidget);
  });
}
