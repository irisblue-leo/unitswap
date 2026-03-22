import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'converter': 'Converter',
      'history': 'History',
      'settings': 'Settings',
      'length': 'Length',
      'weight': 'Weight',
      'temperature': 'Temperature',
      'area': 'Area',
      'from': 'From',
      'to': 'To',
      'inputValue': 'Enter value',
      'convert': 'Convert',
      'result': 'Result',
      'conversionHistory': 'Conversion History',
      'noHistory': 'No conversion history yet.',
      'clearHistory': 'Clear History',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'english': 'English',
      'chinese': 'Chinese',
      'appName': 'UnitSwap',
      'meter': 'Meter',
      'kilometer': 'Kilometer',
      'centimeter': 'Centimeter',
      'mile': 'Mile',
      'foot': 'Foot',
      'inch': 'Inch',
      'kilogram': 'Kilogram',
      'gram': 'Gram',
      'pound': 'Pound',
      'ounce': 'Ounce',
      'celsius': 'Celsius',
      'fahrenheit': 'Fahrenheit',
      'kelvin': 'Kelvin',
      'squareMeter': 'Square Meter',
      'squareKilometer': 'Square Kilometer',
      'squareFoot': 'Square Foot',
      'acre': 'Acre',
      'hectare': 'Hectare',
      'cleared': 'History cleared',
      'invalidInput': 'Please enter a valid number',
    },
    'zh': {
      'converter': '转换器',
      'history': '历史',
      'settings': '设置',
      'length': '长度',
      'weight': '重量',
      'temperature': '温度',
      'area': '面积',
      'from': '从',
      'to': '到',
      'inputValue': '请输入数值',
      'convert': '转换',
      'result': '结果',
      'conversionHistory': '转换历史',
      'noHistory': '暂无转换历史',
      'clearHistory': '清除历史',
      'language': '语言',
      'darkMode': '深色模式',
      'english': '英语',
      'chinese': '中文',
      'appName': 'UnitSwap',
      'meter': '米',
      'kilometer': '千米',
      'centimeter': '厘米',
      'mile': '英里',
      'foot': '英尺',
      'inch': '英寸',
      'kilogram': '千克',
      'gram': '克',
      'pound': '磅',
      'ounce': '盎司',
      'celsius': '摄氏度',
      'fahrenheit': '华氏度',
      'kelvin': '开尔文',
      'squareMeter': '平方米',
      'squareKilometer': '平方千米',
      'squareFoot': '平方英尺',
      'acre': '英亩',
      'hectare': '公顷',
      'cleared': '历史已清除',
      'invalidInput': '请输入有效数字',
    },
  };

  String _t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get converter => _t('converter');
  String get history => _t('history');
  String get settings => _t('settings');
  String get length => _t('length');
  String get weight => _t('weight');
  String get temperature => _t('temperature');
  String get area => _t('area');
  String get from => _t('from');
  String get to => _t('to');
  String get inputValue => _t('inputValue');
  String get convert => _t('convert');
  String get result => _t('result');
  String get conversionHistory => _t('conversionHistory');
  String get noHistory => _t('noHistory');
  String get clearHistory => _t('clearHistory');
  String get language => _t('language');
  String get darkMode => _t('darkMode');
  String get english => _t('english');
  String get chinese => _t('chinese');
  String get appName => _t('appName');
  String get cleared => _t('cleared');
  String get invalidInput => _t('invalidInput');

  String unitName(String key) => _t(key);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
