class ConversionRecord {
  final String category;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double resultValue;
  final DateTime timestamp;

  ConversionRecord({
    required this.category,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.resultValue,
    required this.timestamp,
  });

  String toStorageString() {
    return '$category|$fromUnit|$toUnit|$inputValue|$resultValue|${timestamp.millisecondsSinceEpoch}';
  }

  static ConversionRecord fromStorageString(String s) {
    final parts = s.split('|');
    return ConversionRecord(
      category: parts[0],
      fromUnit: parts[1],
      toUnit: parts[2],
      inputValue: double.parse(parts[3]),
      resultValue: double.parse(parts[4]),
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(parts[5])),
    );
  }
}
