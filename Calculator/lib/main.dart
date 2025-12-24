import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'core/providers/language_provider.dart';

void main() {
  runApp(const ProviderScope(child: CalculatorHubApp()));
}

class CalculatorHubApp extends ConsumerWidget {
  const CalculatorHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Calculator Hub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
        Locale('zh'), // Chinese
        Locale('it'), // Italian
        Locale('pt'), // Portuguese
        Locale('ru'), // Russian
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('ar'), // Arabic
        Locale('hi'), // Hindi
        Locale('tr'), // Turkish
        Locale('vi'), // Vietnamese
        Locale('th'), // Thai
        Locale('nl'), // Dutch
        Locale('pl'), // Polish
        Locale('id'), // Indonesian
        Locale('sv'), // Swedish
      ],
    );
  }
}
