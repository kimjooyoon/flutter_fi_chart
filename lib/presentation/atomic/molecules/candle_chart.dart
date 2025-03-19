import 'package:flutter/material.dart';
import '../../../core/models/financial_data.dart';
import '../../../core/utils/chart_utils.dart';
import '../atoms/chart_canvas.dart';
import '../atoms/chart_grid.dart';

/// 캔들스틱 차트 위젯
///
/// 금융 데이터를 캔들스틱 형태로 표시하는 차트입니다.
class MoleculeCandleChart extends StatelessWidget {
  /// 캔들스틱 차트 생성자
  const MoleculeCandleChart({
    super.key,
    required this.data,
    this.width,
    this.height = 400,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(16),
    this.candleWidth = 8,
    this.candleSpacing = 4,
    this.increasingColor,
    this.decreasingColor,
    this.volumeOpacity = 0.3,
    this.showVolume = true,
    this.showGrid = true,
    this.showDateAxis = true,
    this.showPriceAxis = true,
    this.dateAxisHeight = 30,
    this.priceAxisWidth = 60,
    this.visibleCandleCount,
    this.horizontalLinesCount = 5,
    this.verticalLinesCount = 6,
    this.onTap,
  });

  /// 차트 데이터
  final List<CandleData> data;
  
  /// 차트 너비
  final double? width;
  
  /// 차트 높이
  final double height;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 테두리 색상
  final Color? borderColor;
  
  /// 내부 패딩
  final EdgeInsets padding;
  
  /// 캔들 너비
  final double candleWidth;
  
  /// 캔들 간격
  final double candleSpacing;
  
  /// 상승 캔들 색상
  final Color? increasingColor;
  
  /// 하락 캔들 색상
  final Color? decreasingColor;
  
  /// 거래량 불투명도
  final double volumeOpacity;
  
  /// 거래량 표시 여부
  final bool showVolume;
  
  /// 그리드 표시 여부
  final bool showGrid;
  
  /// 날짜 축 표시 여부
  final bool showDateAxis;
  
  /// 가격 축 표시 여부
  final bool showPriceAxis;
  
  /// 날짜 축 높이
  final double dateAxisHeight;
  
  /// 가격 축 너비
  final double priceAxisWidth;
  
  /// 화면에 표시할 캔들 개수
  final int? visibleCandleCount;
  
  /// 수평선 개수
  final int horizontalLinesCount;
  
  /// 수직선 개수
  final int verticalLinesCount;
  
  /// 탭 이벤트 콜백
  final void Function(CandleData candle)? onTap;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart(context);
    }
    
    final theme = Theme.of(context);
    final increasingCol = increasingColor ?? Colors.green;
    final decreasingCol = decreasingColor ?? Colors.red;
    
    return AtomChartCanvas(
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      padding: padding,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ClipRect(
                    child: _CandlestickChartPainter(
                      data: data,
                      candleWidth: candleWidth,
                      candleSpacing: candleSpacing,
                      increasingColor: increasingCol,
                      decreasingColor: decreasingCol,
                      volumeOpacity: volumeOpacity,
                      showVolume: showVolume,
                      visibleCandleCount: visibleCandleCount,
                      showGrid: showGrid,
                      horizontalLinesCount: horizontalLinesCount,
                      verticalLinesCount: verticalLinesCount,
                      onTap: onTap,
                    ),
                  ),
                ),
                if (showPriceAxis)
                  SizedBox(
                    width: priceAxisWidth,
                    child: _PriceAxisPainter(
                      data: data,
                      increasingColor: increasingCol,
                      decreasingColor: decreasingCol,
                    ),
                  ),
              ],
            ),
          ),
          if (showDateAxis)
            SizedBox(
              height: dateAxisHeight,
              child: Row(
                children: [
                  Expanded(
                    child: _DateAxisPainter(
                      data: data,
                      visibleCandleCount: visibleCandleCount,
                      candleWidth: candleWidth,
                      candleSpacing: candleSpacing,
                    ),
                  ),
                  if (showPriceAxis) SizedBox(width: priceAxisWidth),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  /// 빈 차트 위젯 생성
  Widget _buildEmptyChart(BuildContext context) {
    return AtomChartCanvas(
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      padding: padding,
      child: const Center(
        child: Text('데이터가 없습니다.'),
      ),
    );
  }
}

/// 캔들스틱 차트 페인터
class _CandlestickChartPainter extends StatelessWidget {
  const _CandlestickChartPainter({
    required this.data,
    required this.candleWidth,
    required this.candleSpacing,
    required this.increasingColor,
    required this.decreasingColor,
    required this.volumeOpacity,
    required this.showVolume,
    this.visibleCandleCount,
    required this.showGrid,
    required this.horizontalLinesCount,
    required this.verticalLinesCount,
    this.onTap,
  });

  final List<CandleData> data;
  final double candleWidth;
  final double candleSpacing;
  final Color increasingColor;
  final Color decreasingColor;
  final double volumeOpacity;
  final bool showVolume;
  final int? visibleCandleCount;
  final bool showGrid;
  final int horizontalLinesCount;
  final int verticalLinesCount;
  final void Function(CandleData candle)? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showGrid)
          Positioned.fill(
            child: AtomChartGrid(
              horizontalLinesCount: horizontalLinesCount,
              verticalLinesCount: verticalLinesCount,
            ),
          ),
        Positioned.fill(
          child: GestureDetector(
            onTapUp: (details) {
              if (onTap != null) {
                final candleIndex = _getCandleIndexFromPosition(details.localPosition);
                if (candleIndex >= 0 && candleIndex < data.length) {
                  onTap!(data[candleIndex]);
                }
              }
            },
            child: CustomPaint(
              painter: _CandlestickPainter(
                data: data,
                candleWidth: candleWidth,
                candleSpacing: candleSpacing,
                increasingColor: increasingColor,
                decreasingColor: decreasingColor,
                volumeOpacity: volumeOpacity,
                showVolume: showVolume,
                visibleCandleCount: visibleCandleCount,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ],
    );
  }
  
  /// 터치 위치로부터 캔들 인덱스 계산
  int _getCandleIndexFromPosition(Offset position) {
    final candleFullWidth = candleWidth + candleSpacing;
    final startXOffset = candleSpacing / 2;
    
    final index = ((position.dx - startXOffset) / candleFullWidth).floor();
    return index;
  }
}

/// 캔들스틱 커스텀 페인터
class _CandlestickPainter extends CustomPainter {
  _CandlestickPainter({
    required this.data,
    required this.candleWidth,
    required this.candleSpacing,
    required this.increasingColor,
    required this.decreasingColor,
    required this.volumeOpacity,
    required this.showVolume,
    this.visibleCandleCount,
  });

  final List<CandleData> data;
  final double candleWidth;
  final double candleSpacing;
  final Color increasingColor;
  final Color decreasingColor;
  final double volumeOpacity;
  final bool showVolume;
  final int? visibleCandleCount;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    // 표시할 캔들 개수 계산
    final visibleCount = visibleCandleCount ?? 
        (size.width / (candleWidth + candleSpacing)).floor();
    
    // 데이터가 충분하지 않으면 있는 데이터만 표시
    final displayData = data.length > visibleCount
        ? data.sublist(data.length - visibleCount)
        : data;
    
    // 가격 범위 계산
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    double maxVolume = 0;
    
    for (final candle in displayData) {
      minPrice = minPrice > candle.low ? candle.low : minPrice;
      maxPrice = maxPrice < candle.high ? candle.high : maxPrice;
      maxVolume = maxVolume < candle.volume ? candle.volume : maxVolume;
    }
    
    // 마진 추가
    final priceRange = maxPrice - minPrice;
    final marginRatio = 0.05; // 5% 마진
    minPrice -= priceRange * marginRatio;
    maxPrice += priceRange * marginRatio;
    
    // 거래량 영역 높이
    final volumeHeight = showVolume ? size.height * 0.2 : 0;
    // 가격 차트 영역 높이
    final priceChartHeight = size.height - volumeHeight;
    
    final candleFullWidth = candleWidth + candleSpacing;
    final startXOffset = (size.width - displayData.length * candleFullWidth) / 2 + candleSpacing / 2;
    
    // 각 캔들 그리기
    for (int i = 0; i < displayData.length; i++) {
      final candle = displayData[i];
      final x = startXOffset + i * candleFullWidth;
      
      // 가격 범위에 매핑
      final high = _mapToYPosition(candle.high, minPrice, maxPrice, priceChartHeight);
      final low = _mapToYPosition(candle.low, minPrice, maxPrice, priceChartHeight);
      final open = _mapToYPosition(candle.open, minPrice, maxPrice, priceChartHeight);
      final close = _mapToYPosition(candle.close, minPrice, maxPrice, priceChartHeight);
      
      // 캔들 색상 결정
      final isIncreasing = candle.close >= candle.open;
      final candleColor = isIncreasing ? increasingColor : decreasingColor;
      
      // 캔들스틱 그리기
      _drawCandle(
        canvas, 
        x, 
        high, 
        low, 
        open, 
        close, 
        candleColor, 
        candleWidth,
      );
      
      // 거래량 그리기
      if (showVolume) {
        final volumeY = priceChartHeight + (volumeHeight * (1 - candle.volume / maxVolume));
        _drawVolume(
          canvas, 
          x, 
          volumeY, 
          priceChartHeight + volumeHeight, 
          candleWidth, 
          candleColor.withOpacity(volumeOpacity),
        );
      }
    }
  }
  
  /// 가격 값을 Y 좌표로 변환
  double _mapToYPosition(double price, double minPrice, double maxPrice, double height) {
    return height - (price - minPrice) / (maxPrice - minPrice) * height;
  }
  
  /// 캔들스틱 그리기
  void _drawCandle(
    Canvas canvas, 
    double x, 
    double high, 
    double low, 
    double open, 
    double close, 
    Color color, 
    double width,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // 세로선 (고가 - 저가)
    canvas.drawLine(
      Offset(x + width / 2, high),
      Offset(x + width / 2, low),
      linePaint,
    );
    
    // 몸통 (시가 - 종가)
    final top = open < close ? close : open;
    final bottom = open < close ? open : close;
    final bodyHeight = (top - bottom).abs();
    
    canvas.drawRect(
      Rect.fromLTWH(x, bottom, width, bodyHeight),
      paint,
    );
  }
  
  /// 거래량 그리기
  void _drawVolume(
    Canvas canvas, 
    double x, 
    double top, 
    double bottom, 
    double width, 
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(x, top, width, bottom - top),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 가격 축 페인터
class _PriceAxisPainter extends StatelessWidget {
  const _PriceAxisPainter({
    required this.data,
    required this.increasingColor,
    required this.decreasingColor,
  });

  final List<CandleData> data;
  final Color increasingColor;
  final Color decreasingColor;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();
    
    // 가격 범위 계산
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    
    for (final candle in data) {
      minPrice = minPrice > candle.low ? candle.low : minPrice;
      maxPrice = maxPrice < candle.high ? candle.high : maxPrice;
    }
    
    // 마진 추가
    final priceRange = maxPrice - minPrice;
    final marginRatio = 0.05; // 5% 마진
    minPrice -= priceRange * marginRatio;
    maxPrice += priceRange * marginRatio;
    
    // 가격 레이블 생성
    final interval = ChartUtils.calculatePriceInterval(minPrice, maxPrice);
    int labelCount = ((maxPrice - minPrice) / interval).ceil() + 1;
    
    if (labelCount > 10) {
      labelCount = 10;
    }
    
    final stepPrice = (maxPrice - minPrice) / (labelCount - 1);
    final labels = List.generate(
      labelCount,
      (i) => minPrice + i * stepPrice,
    );
    
    // 색상 결정
    final lastPrice = data.last.close;
    final prevPrice = data.length > 1 ? data[data.length - 2].close : data.last.open;
    final color = lastPrice > prevPrice 
        ? increasingColor 
        : (lastPrice < prevPrice ? decreasingColor : Colors.grey);
    
    // 가격 축 위젯 생성
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...List.generate(labelCount, (i) {
              final price = labels[labelCount - 1 - i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  ChartUtils.formatPrice(price),
                  style: TextStyle(
                    fontSize: 10,
                    color: price == lastPrice ? color : null,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

/// 날짜 축 페인터
class _DateAxisPainter extends StatelessWidget {
  const _DateAxisPainter({
    required this.data,
    required this.candleWidth,
    required this.candleSpacing,
    this.visibleCandleCount,
  });

  final List<CandleData> data;
  final double candleWidth;
  final double candleSpacing;
  final int? visibleCandleCount;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 표시할 캔들 개수 계산
        final visibleCount = visibleCandleCount ?? 
            (constraints.maxWidth / (candleWidth + candleSpacing)).floor();
        
        // 데이터가 충분하지 않으면 있는 데이터만 표시
        final displayData = data.length > visibleCount
            ? data.sublist(data.length - visibleCount)
            : data;
            
        // 레이블 개수 계산 (화면 너비에 따라)
        final maxLabels = (constraints.maxWidth / 60).floor(); // 최소 60px 간격
        final step = (displayData.length / maxLabels).ceil();
        
        // 레이블 위치 계산
        final candleFullWidth = candleWidth + candleSpacing;
        final startXOffset = (constraints.maxWidth - displayData.length * candleFullWidth) / 2 + candleFullWidth / 2;
        
        // 날짜 형식 결정
        final dateFormat = ChartUtils.getDateFormat(displayData);
        
        return Stack(
          children: [
            for (int i = 0; i < displayData.length; i += step)
              if (i < displayData.length)
                Positioned(
                  left: startXOffset + i * candleFullWidth - 25,
                  top: 0,
                  child: SizedBox(
                    width: 50,
                    child: Text(
                      _formatDate(displayData[i].date, dateFormat),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
  
  /// 날짜 포맷팅
  String _formatDate(DateTime date, String format) {
    if (format == 'HH:mm') {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (format == 'MM-dd') {
      return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } else if (format == 'MM-dd HH:mm') {
      return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
} 