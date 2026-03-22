import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final bool isDarkMode;
  final Locale currentLocale;

  const SettingsScreen({
    Key? key,
    required this.onLocaleChanged,
    required this.onDarkModeChanged,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isEnglish = currentLocale.languageCode == 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.language),
            subtitle: Text(isEnglish ? loc.english : loc.chinese),
            trailing: Switch(
              value: !isEnglish,
              onChanged: (val) {
                final newLocale = val ? const Locale('zh') : const Locale('en');
                StorageService.setLanguage(newLocale.languageCode);
                onLocaleChanged(newLocale);
              },
            ),
          ),
          const Divider(),

          // Dark mode
          ListTile(
            leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: Text(loc.darkMode),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (val) {
                StorageService.setDarkMode(val);
                onDarkModeChanged(val);
              },
            ),
          ),
          const Divider(),

          // App info
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text(loc.appName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('v1.0.0',
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
