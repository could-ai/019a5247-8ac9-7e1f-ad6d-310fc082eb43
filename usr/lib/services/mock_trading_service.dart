import 'dart:async';
import 'dart:math';
import '../models/candle.dart';
import '../models/trade_signal.dart';

class MockTradingService {
  final _random = Random();
  StreamController<Candle>? _candleStreamController;
  StreamController<TradeSignal>? _signalStreamController;
  Timer? _candleTimer;
  Timer? _signalTimer;

  Stream<Candle> streamCandles(String instrument) {
    _candleStreamController?.close();
    _candleStreamController = StreamController<Candle>();

    double lastPrice = 10000 + _random.nextDouble() * 1000;

    _candleTimer?.cancel();
    _candleTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final open = lastPrice;
      final close = open + (_random.nextDouble() * 100 - 50);
      final high = max(open, close) + _random.nextDouble() * 20;
      final low = min(open, close) - _random.nextDouble() * 20;
      lastPrice = close;

      _candleStreamController?.add(Candle(
        timestamp: DateTime.now(),
        open: open,
        high: high,
        low: low,
        close: close,
      ));
    });

    return _candleStreamController!.stream;
  }

  Stream<TradeSignal> streamSignals() {
    _signalStreamController?.close();
    _signalStreamController = StreamController<TradeSignal>();

    _signalTimer?.cancel();
    _signalTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final signalType = _random.nextBool() ? 'BUY' : 'SELL';
      _signalStreamController?.add(TradeSignal(
        timestamp: DateTime.now(),
        instrument: 'Volatility 100 Index',
        timeframe: '1m',
        signal: signalType,
        confidence: _random.nextDouble(),
        reason: 'EMA Cross and RSI Oversold',
      ));
    });

    return _signalStreamController!.stream;
  }

  void dispose() {
    _candleTimer?.cancel();
    _signalTimer?.cancel();
    _candleStreamController?.close();
    _signalStreamController?.close();
  }
}
