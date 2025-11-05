import 'package:flutter/material.dart';
import '../widgets/instrument_selector.dart';
import '../widgets/signal_feed.dart';
import '../widgets/trading_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deriv Trading Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InstrumentSelector(),
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: TradingChart(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Live Signals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: SignalFeed(),
            ),
          ],
        ),
      ),
    );
  }
}
