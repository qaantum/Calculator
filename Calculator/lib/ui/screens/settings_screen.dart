import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/providers/currency_provider.dart';
import '../../core/providers/unit_system_provider.dart';
import '../../core/providers/language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final unitSystem = ref.watch(unitSystemProvider);
    final language = ref.watch(languageProvider);
    
    final currencies = ['\$', '€', '£', '¥', '₹', '₽', '₩', 'CHF', 'A\$', 'C\$'];
    final languages = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'zh': '中文',
      'it': 'Italiano',
      'pt': 'Português',
      'ru': 'Русский',
      'ja': '日本語',
      'ko': '한국어',
      'ar': 'العربية',
      'hi': 'हिन्दी',
      'tr': 'Türkçe',
      'vi': 'Tiếng Việt',
      'th': 'ไทย',
      'nl': 'Nederlands',
      'pl': 'Polski',
      'id': 'Bahasa Indonesia',
      'sv': 'Svenska',
    };

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(AppLocalizations.of(context)!.currencySymbol),
            subtitle: Text('${AppLocalizations.of(context)!.current}: $currency'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(AppLocalizations.of(context)!.selectCurrency),
                  children: currencies.map((c) {
                    return SimpleDialogOption(
                      onPressed: () {
                        ref.read(currencyProvider.notifier).setCurrency(c);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(c, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.straighten),
            title: Text(AppLocalizations.of(context)!.unitSystem),
            subtitle: Text(unitSystem == UnitSystem.metric ? AppLocalizations.of(context)!.metric : AppLocalizations.of(context)!.imperial),
            trailing: Switch(
              value: unitSystem == UnitSystem.metric,
              onChanged: (val) {
                ref.read(unitSystemProvider.notifier).setUnitSystem(val ? UnitSystem.metric : UnitSystem.imperial);
              },
            ),
            onTap: () {
              ref.read(unitSystemProvider.notifier).setUnitSystem(
                unitSystem == UnitSystem.metric ? UnitSystem.imperial : UnitSystem.metric
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(languages[language.languageCode] ?? language.languageCode),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(AppLocalizations.of(context)!.language),
                  children: languages.entries.map((e) {
                    return SimpleDialogOption(
                      onPressed: () {
                        ref.read(languageProvider.notifier).setLanguage(e.key);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(e.value, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
