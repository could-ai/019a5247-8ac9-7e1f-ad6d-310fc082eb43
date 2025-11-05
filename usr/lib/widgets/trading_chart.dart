import 'package:flutter/material.dart';
import '../../models/candle.dart';
import '../../services/mock_trading_service.dart';

class TradingChart extends StatefulWidget {
  const TradingChart({super.key});

  @override
  State<TradingChart> createState() => _TradingChartState();
}

class _TradingChartState extends State<TradingChart> {
  late final MockTradingService _tradingService;
  List<Candle> _candles = [];

  @override
  void initState() {
    super.initState();
    _tradingService = MockTradingService();
    _startStreaming();
  }

  void _startStreaming() {
    _tradingService.streamCandles('Volatility 100 Index').listen((candle) {
      setState(() {
        if (_candles.isNotEmpty && _candles.last.timestamp == candle.timestamp) {
          _candles[_candles.length - 1] = candle;
        } else {
          _candles.add(candle);
        }
        if (_candles.length > 50) {
          _candles.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: _candles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomPaint(
              painter: _CandleChartPainter(candles: _candles),
              size: Size.infinite,
            ),
    );
  }

  @override
  void dispose() {
    _tradingService.dispose();
    super.dispose();
  }
}

class _CandleChartPainter extends CustomPainter {
  final List<Candle> candles;

  _CandleChartPainter({required this.candles});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final double maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final double minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final double priceRange = maxPrice - minPrice;

    final double candleWidth = size.width / (candles.length * 1.5);
    final double spacing = candleWidth * 0.5;

    final Paint greenPaint = Paint()..color = Colors.green;
    final Paint redPaint = Paint()..color = Colors.red;

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final double x = size.width - (i * (candleWidth + spacing));
      
      final double highY = size.height - ((candle.high - minPrice) / priceRange) * size.height;
      final double lowY = size.height - ((candle.low - minPrice) / priceRange) * size.height;
      final double openY = size.height - ((candle.open - minPrice) / priceRange) * size.height;
      final double closeY = size.height - ((candle.close - minPrice) / priceRange) * size.height;

      // Draw wick
      canvas.drawLine(Offset(x + candleWidth / 2, highY), Offset(x + candleWidth / 2, lowY), candle.open > candle.close ? redPaint : greenPaint);

      // Draw body
      final Rect body = Rect.fromLTRB(x, candle.open > candle.close ? closeY : openY, x + candleWidth, candle.open > candle.close ? openY : closeY);
      canvas.drawRect(body, candle.open > candle.close ? redPaint : greenPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
