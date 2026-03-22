import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_record.dart';

class StorageService {
  static const String _historyKey = 'conversion_history';

  static Future<List<ConversionRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_historyKey) ?? [];
    return raw.map((s) => ConversionRecord.fromStorageString(s)).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Future<void> addRecord(ConversionRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_historyKey) ?? [];
    raw.add(record.toStorageString());
    if (raw.length > 100) {
      raw.removeAt(0);
    }
    await prefs.setStringList(_historyKey, raw);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }
}
