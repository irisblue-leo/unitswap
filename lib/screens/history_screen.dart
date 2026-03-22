import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/conversion_record.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ConversionRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final records = await StorageService.getHistory();
    if (mounted) {
      setState(() => _records = records);
    }
  }

  Future<void> _clearHistory() async {
    await StorageService.clearHistory();
    setState(() => _records = []);
    if (mounted) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.cleared)),
      );
    }
  }

  String _formatValue(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.conversionHistory),
        centerTitle: true,
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(loc.clearHistory),
                    content: Text('?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _clearHistory();
                        },
                        child: Text(loc.clearHistory),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _records.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history,
                      size: 64,
                      color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text(loc.noHistory,
                      style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 16)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadHistory,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _records.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final r = _records[index];
                  return ListTile(
                    leading: _categoryIcon(r.category),
                    title: Text(
                      '${_formatValue(r.inputValue)} ${loc.unitName(r.fromUnit)}'
                      '  ->  '
                      '${_formatValue(r.resultValue)} ${loc.unitName(r.toUnit)}',
                    ),
                    subtitle: Text(
                      '${loc.unitName(r.category)} - ${dateFormat.format(r.timestamp)}',
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _categoryIcon(String category) {
    IconData icon;
    switch (category) {
      case 'length':
        icon = Icons.straighten;
        break;
      case 'weight':
        icon = Icons.fitness_center;
        break;
      case 'temperature':
        icon = Icons.thermostat;
        break;
      case 'area':
        icon = Icons.square_foot;
        break;
      default:
        icon = Icons.swap_horiz;
    }
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
      child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
    );
  }
}
