import 'package:flutter/material.dart';

class InstrumentSelector extends StatelessWidget {
  const InstrumentSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, this would be a dynamic list from a service
    final List<String> instruments = [
      'Volatility 100 Index',
      'Volatility 75 Index',
      'Volatility 50 Index',
      'EUR/USD',
      'BTC/USD'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButton<String>(
        value: instruments.first,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: Theme.of(context).cardColor,
        items: instruments.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          // Handle instrument change
        },
      ),
    );
  }
}
