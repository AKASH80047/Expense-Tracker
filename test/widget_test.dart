import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_expense_budget/main.dart';
import 'package:tracker_expense_budget/screens/profile/profile_screen.dart';
import 'package:tracker_expense_budget/screens/add_transaction/add_transaction_screen.dart';

void main() {
  testWidgets('App smoke test loads Home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FinanceManagerApp(),
      ),
    );

    expect(find.textContaining('Good morning'), findsOneWidget);
    expect(find.text('Total Balance'), findsOneWidget);
  });

  testWidgets('Profile & Settings screen loads and opens avatar picker', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    // Verify Profile header elements
    expect(find.text('Profile & Settings'), findsOneWidget);
    expect(find.text('Akash Patel'), findsOneWidget);
    expect(find.text('Senior Software Engineer'), findsOneWidget);
    expect(find.text('PERSONAL & ACCOUNT'), findsOneWidget);
    expect(find.text('FINANCIAL MANAGEMENT'), findsOneWidget);
    expect(find.text('AI & PRODUCTIVITY SUITE'), findsOneWidget);

    // Tap Change Avatar
    await tester.tap(find.text('Change Avatar / Profile Picture'));
    await tester.pumpAndSettle();

    // Verify bottom sheet shows Gallery, Camera and curated presets
    expect(find.text('Choose Photo'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Or Choose Preset Style'), findsOneWidget);
    expect(find.text('Tech Lead'), findsOneWidget);
    expect(find.text('Investor'), findsOneWidget);
  });

  testWidgets('Back and Cancel buttons work properly in AddTransaction and Dialogs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
                  );
                },
                child: const Text('Open Add'),
              ),
            ),
          ),
        ),
      ),
    );

    // 1. Open Add Transaction
    await tester.tap(find.text('Open Add'));
    await tester.pumpAndSettle();
    expect(find.text('Add Transaction'), findsOneWidget);

    // 2. Test Cancel button
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Add Transaction'), findsNothing);
    expect(find.text('Open Add'), findsOneWidget);

    // 3. Test Back Arrow button
    await tester.tap(find.text('Open Add'));
    await tester.pumpAndSettle();
    expect(find.text('Add Transaction'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Add Transaction'), findsNothing);
    expect(find.text('Open Add'), findsOneWidget);
  });

  testWidgets('Cancel buttons work properly in Profile dialogs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    // 1. Edit Profile Dialog Cancel test
    await tester.tap(find.byTooltip('Edit Profile Info'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profile Info'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profile Info'), findsNothing);

    // 2. Logout Dialog Cancel test
    await tester.scrollUntilVisible(find.text('Log Out'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Out'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Out'), findsNothing);
  });
}
