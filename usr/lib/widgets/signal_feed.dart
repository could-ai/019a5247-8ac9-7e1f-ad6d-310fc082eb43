import 'package:flutter/material.dart';
import '../../models/trade_signal.dart';
import '../../services/mock_trading_service.dart';

class SignalFeed extends StatefulWidget {
  const SignalFeed({super.key});

  @override
  State<SignalFeed> createState() => _SignalFeedState();
}

class _SignalFeedState extends State<SignalFeed> {
  late final MockTradingService _tradingService;
  final List<TradeSignal> _signals = [];

  @override
  void initState() {
    super.initState();
    _tradingService = MockTradingService();
    _tradingService.streamSignals().listen((signal) {
      setState(() {
        _signals.insert(0, signal);
        if (_signals.length > 20) {
          _signals.removeLast();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: _signals.isEmpty
          ? const Center(child: Text('Awaiting signals...'))
          : ListView.builder(
              itemCount: _signals.length,
              itemBuilder: (context, index) {
                final signal = _signals[index];
                return ListTile(
                  leading: Icon(
                    signal.signal == 'BUY' ? Icons.arrow_upward : Icons.arrow_downward,
                    color: signal.signal == 'BUY' ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    '${signal.instrument} (${signal.timeframe}) - ${signal.signal}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(signal.reason),
                  trailing: Text(
                    '${signal.timestamp.hour}:${signal.timestamp.minute.toString().padLeft(2, '0')}',
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _tradingService.dispose();
    super.dispose();
  }
}
