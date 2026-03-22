import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../l10n/app_localizations.dart';
import '../models/conversion_record.dart';
import '../services/converter_engine.dart';
import '../services/storage_service.dart';

class ConverterScreen extends StatefulWidget {
  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedCategory = 'length';
  late String _fromUnit;
  late String _toUnit;
  String _resultText = '';
  BannerAd? _bannerAd;
  bool _isBannerReady = false;

  @override
  void initState() {
    super.initState();
    final units = ConverterEngine.unitsByCategory[_selectedCategory]!;
    _fromUnit = units[0];
    _toUnit = units[1];
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // Test ad unit IDs from Google
    final String adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() => _isBannerReady = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    final units = ConverterEngine.unitsByCategory[category]!;
    setState(() {
      _selectedCategory = category;
      _fromUnit = units[0];
      _toUnit = units[1];
      _resultText = '';
      _inputController.clear();
    });
  }

  void _doConvert() {
    final loc = AppLocalizations.of(context);
    final input = double.tryParse(_inputController.text);
    if (input == null) {
      setState(() => _resultText = loc.invalidInput);
      return;
    }

    final result = ConverterEngine.convert(
      _selectedCategory,
      _fromUnit,
      _toUnit,
      input,
    );

    final formatted = result == result.roundToDouble()
        ? result.toStringAsFixed(0)
        : result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '');

    setState(() {
      _resultText =
          '${loc.result}: $formatted ${loc.unitName(_toUnit)}';
    });

    StorageService.addRecord(ConversionRecord(
      category: _selectedCategory,
      fromUnit: _fromUnit,
      toUnit: _toUnit,
      inputValue: input,
      resultValue: result,
      timestamp: DateTime.now(),
    ));
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _resultText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final units = ConverterEngine.unitsByCategory[_selectedCategory]!;
    final categories = ['length', 'weight', 'temperature', 'area'];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category chips
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(loc.unitName(cat)),
                        selected: isSelected,
                        onSelected: (_) => _onCategoryChanged(cat),
                        selectedColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Input field
                  TextField(
                    controller: _inputController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: InputDecoration(
                      labelText: loc.inputValue,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // From / Swap / To row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.from,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _fromUnit,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              items: units.map((u) {
                                return DropdownMenuItem(
                                  value: u,
                                  child: Text(loc.unitName(u)),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    _fromUnit = v;
                                    _resultText = '';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          icon: const Icon(Icons.swap_horiz, size: 32),
                          onPressed: _swapUnits,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.to,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _toUnit,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              items: units.map((u) {
                                return DropdownMenuItem(
                                  value: u,
                                  child: Text(loc.unitName(u)),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    _toUnit = v;
                                    _resultText = '';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Convert button
                  ElevatedButton(
                    onPressed: _doConvert,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(loc.convert,
                        style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 24),

                  // Result display
                  if (_resultText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _resultText,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Banner ad at bottom
          if (_isBannerReady && _bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
