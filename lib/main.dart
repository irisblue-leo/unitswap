import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'screens/converter_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MobileAds.instance.initialize();
  } catch (_) {}
  runApp(UnitSwapApp());
}

class UnitSwapApp extends StatefulWidget {
  @override
  State<UnitSwapApp> createState() => _UnitSwapAppState();
}

class _UnitSwapAppState extends State<UnitSwapApp> {
  Locale _locale = const Locale('en');
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locale = Locale(prefs.getString('language') ?? 'en');
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  void updateLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void updateDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnitSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.indigo,
        brightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MainPage(
        onLocaleChanged: updateLocale,
        onDarkModeChanged: updateDarkMode,
        isDarkMode: _darkMode,
        currentLocale: _locale,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final bool isDarkMode;
  final Locale currentLocale;

  const MainPage({
    Key? key,
    required this.onLocaleChanged,
    required this.onDarkModeChanged,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final List<Widget> pages = [
      ConverterScreen(),
      HistoryScreen(),
      SettingsScreen(
        onLocaleChanged: widget.onLocaleChanged,
        onDarkModeChanged: widget.onDarkModeChanged,
        isDarkMode: widget.isDarkMode,
        currentLocale: widget.currentLocale,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.swap_horiz),
            label: loc.converter,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: loc.history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: loc.settings,
          ),
        ],
      ),
    );
  }
}
