class TradeSignal {
  final DateTime timestamp;
  final String instrument;
  final String timeframe;
  final String signal; // BUY, SELL, HOLD
  final double confidence;
  final String reason;

  TradeSignal({
    required this.timestamp,
    required this.instrument,
    required this.timeframe,
    required this.signal,
    required this.confidence,
    required this.reason,
  });
}
