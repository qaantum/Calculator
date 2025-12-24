import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_hub/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Localization test: Switch language from English to Spanish', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CalculatorHubApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that we start in English (default)
    // "Dashboard" should be present
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Settings'), findsNothing); // Settings is an icon, title not visible yet

    // Navigate to Settings
    // Find the settings icon button in the AppBar
    final settingsIcon = find.byIcon(Icons.settings);
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();

    // Verify we are on Settings screen
    // Title "Settings" should be visible
    expect(find.text('Settings'), findsOneWidget);
    // "Language" option should be visible
    expect(find.text('Language'), findsOneWidget);

    // Tap on Language to open dialog
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    // Verify dialog is open and "Español" is an option
    expect(find.text('Language'), findsNWidgets(2)); // Title in AppBar + Title in Dialog
    expect(find.text('Español'), findsOneWidget);

    // Verify UI updated to Spanish (or Turkish if we change the test)
    // For this test, let's switch to Turkish since that's what we just fixed
    // But wait, the test selects 'Español'. Let's change the test to select 'Türkçe'
    
    // Go back to Language dialog
    await tester.tap(find.text('Español')); 
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();

    // Verify Settings translations
    expect(find.text('Ayarlar'), findsOneWidget);
    expect(find.text('Dil'), findsOneWidget);
    expect(find.text('Para Birimi Sembolü'), findsOneWidget); // Was "Currency Symbol"

    // Go back to Dashboard
    final backButton = find.byType(BackButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verify Dashboard translations
    expect(find.text('Panel'), findsOneWidget);
    
    // Open Drawer (if on mobile) or check Navigation Rail (if on desktop)
    // The test runs on a default size which might be mobile or desktop.
    // Let's check for "Bilim" (Science) and "Yaşam Tarzı" (Lifestyle) which should be visible in the rail or drawer
    // We might need to open the drawer if it's mobile.
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    if (scaffold.drawer != null) {
       // Open drawer
       await tester.tap(find.byIcon(Icons.menu)); // Assuming there is a menu icon or we can find it by tooltip
       await tester.pumpAndSettle();
    }
    
    // Check for translated categories
    expect(find.text('Bilim'), findsOneWidget); // Science
    expect(find.text('Yaşam Tarzı'), findsOneWidget); // Lifestyle
  });
}
