class ConverterEngine {
  static const Map<String, List<String>> unitsByCategory = {
    'length': ['meter', 'kilometer', 'centimeter', 'mile', 'foot', 'inch'],
    'weight': ['kilogram', 'gram', 'pound', 'ounce'],
    'temperature': ['celsius', 'fahrenheit', 'kelvin'],
    'area': ['squareMeter', 'squareKilometer', 'squareFoot', 'acre', 'hectare'],
  };

  // All length units to meters
  static const Map<String, double> _lengthToBase = {
    'meter': 1.0,
    'kilometer': 1000.0,
    'centimeter': 0.01,
    'mile': 1609.344,
    'foot': 0.3048,
    'inch': 0.0254,
  };

  // All weight units to kilograms
  static const Map<String, double> _weightToBase = {
    'kilogram': 1.0,
    'gram': 0.001,
    'pound': 0.453592,
    'ounce': 0.0283495,
  };

  // All area units to square meters
  static const Map<String, double> _areaToBase = {
    'squareMeter': 1.0,
    'squareKilometer': 1000000.0,
    'squareFoot': 0.092903,
    'acre': 4046.86,
    'hectare': 10000.0,
  };

  static double convert(String category, String from, String to, double value) {
    if (from == to) return value;

    switch (category) {
      case 'length':
        return value * _lengthToBase[from]! / _lengthToBase[to]!;
      case 'weight':
        return value * _weightToBase[from]! / _weightToBase[to]!;
      case 'temperature':
        return _convertTemperature(from, to, value);
      case 'area':
        return value * _areaToBase[from]! / _areaToBase[to]!;
      default:
        return 0.0;
    }
  }

  static double _convertTemperature(String from, String to, double value) {
    // Convert to Celsius first
    double celsius;
    switch (from) {
      case 'celsius':
        celsius = value;
        break;
      case 'fahrenheit':
        celsius = (value - 32) * 5.0 / 9.0;
        break;
      case 'kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target
    switch (to) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        return celsius * 9.0 / 5.0 + 32;
      case 'kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }
}
