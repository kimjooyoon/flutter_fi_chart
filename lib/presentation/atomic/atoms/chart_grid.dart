import 'package:flutter/material.dart';
import 'dart:ui' show PathMetric;

/// 차트 그리드 위젯
///
/// 차트의 배경 그리드를 렌더링하는 위젯입니다.
/// 가로선과 세로선을 그려 차트의 데이터 영역을 시각적으로 구분합니다.
class AtomChartGrid extends StatelessWidget {
  /// 차트 그리드 생성자
  const AtomChartGrid({
    super.key,
    this.horizontalLinesCount = 4,
    this.verticalLinesCount = 6,
    this.horizontalLineColor,
    this.verticalLineColor,
    this.horizontalLineWidth = 0.5,
    this.verticalLineWidth = 0.5,
    this.horizontalDashPattern,
    this.verticalDashPattern,
    this.showHorizontalLines = true,
    this.showVerticalLines = true,
    this.child,
  });

  /// 가로선 개수
  final int horizontalLinesCount;
  
  /// 세로선 개수
  final int verticalLinesCount;
  
  /// 가로선 색상
  final Color? horizontalLineColor;
  
  /// 세로선 색상
  final Color? verticalLineColor;
  
  /// 가로선 두께
  final double horizontalLineWidth;
  
  /// 세로선 두께
  final double verticalLineWidth;
  
  /// 가로선 대시 패턴 (null이면 실선)
  final List<double>? horizontalDashPattern;
  
  /// 세로선 대시 패턴 (null이면 실선)
  final List<double>? verticalDashPattern;
  
  /// 가로선 표시 여부
  final bool showHorizontalLines;
  
  /// 세로선 표시 여부
  final bool showVerticalLines;
  
  /// 그리드 위에 표시할 자식 위젯
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        CustomPaint(
          painter: _GridPainter(
            horizontalLinesCount: horizontalLinesCount,
            verticalLinesCount: verticalLinesCount,
            horizontalLineColor: horizontalLineColor ?? theme.dividerColor.withOpacity(0.3),
            verticalLineColor: verticalLineColor ?? theme.dividerColor.withOpacity(0.3),
            horizontalLineWidth: horizontalLineWidth,
            verticalLineWidth: verticalLineWidth,
            horizontalDashPattern: horizontalDashPattern,
            verticalDashPattern: verticalDashPattern,
            showHorizontalLines: showHorizontalLines,
            showVerticalLines: showVerticalLines,
          ),
          size: Size.infinite,
        ),
        if (child != null) child!,
      ],
    );
  }
}

/// 차트 그리드를 그리는 커스텀 페인터
class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.horizontalLinesCount,
    required this.verticalLinesCount,
    required this.horizontalLineColor,
    required this.verticalLineColor,
    required this.horizontalLineWidth,
    required this.verticalLineWidth,
    this.horizontalDashPattern,
    this.verticalDashPattern,
    required this.showHorizontalLines,
    required this.showVerticalLines,
  });

  final int horizontalLinesCount;
  final int verticalLinesCount;
  final Color horizontalLineColor;
  final Color verticalLineColor;
  final double horizontalLineWidth;
  final double verticalLineWidth;
  final List<double>? horizontalDashPattern;
  final List<double>? verticalDashPattern;
  final bool showHorizontalLines;
  final bool showVerticalLines;

  @override
  void paint(Canvas canvas, Size size) {
    // 가로선 그리기
    if (showHorizontalLines) {
      final horizontalPaint = Paint()
        ..color = horizontalLineColor
        ..strokeWidth = horizontalLineWidth
        ..style = PaintingStyle.stroke;
      
      final horizontalStep = size.height / (horizontalLinesCount + 1);
      
      for (int i = 1; i <= horizontalLinesCount; i++) {
        final y = horizontalStep * i;
        
        if (horizontalDashPattern != null && horizontalDashPattern!.isNotEmpty) {
          _drawDashedLine(
            canvas,
            Offset(0, y),
            Offset(size.width, y),
            horizontalPaint,
            horizontalDashPattern!,
          );
        } else {
          canvas.drawLine(
            Offset(0, y),
            Offset(size.width, y),
            horizontalPaint,
          );
        }
      }
    }
    
    // 세로선 그리기
    if (showVerticalLines) {
      final verticalPaint = Paint()
        ..color = verticalLineColor
        ..strokeWidth = verticalLineWidth
        ..style = PaintingStyle.stroke;
      
      final verticalStep = size.width / (verticalLinesCount + 1);
      
      for (int i = 1; i <= verticalLinesCount; i++) {
        final x = verticalStep * i;
        
        if (verticalDashPattern != null && verticalDashPattern!.isNotEmpty) {
          _drawDashedLine(
            canvas,
            Offset(x, 0),
            Offset(x, size.height),
            verticalPaint,
            verticalDashPattern!,
          );
        } else {
          canvas.drawLine(
            Offset(x, 0),
            Offset(x, size.height),
            verticalPaint,
          );
        }
      }
    }
  }
  
  /// 점선 그리기 헬퍼 메서드
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, 
                     Paint paint, List<double> dashPattern) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);
      
    canvas.drawPath(
      _dashPath(path, dashArray: _CircularIntervalList(dashPattern)),
      paint,
    );
  }
  
  /// 점선 경로를 생성하는 함수
  Path _dashPath(
    Path source, {
    required _CircularIntervalList<double> dashArray,
    double? dashOffset,
  }) {
    dashOffset ??= 0.0;
    
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = dashOffset;
      bool draw = true;
      while (distance < metric.length) {
        final double len = dashArray.next;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 대시 패턴을 위한 헬퍼 클래스
class _CircularIntervalList<T> {
  _CircularIntervalList(this.values);
  final List<T> values;
  int _index = 0;
  
  T get next {
    if (values.isEmpty) {
      throw Exception('Cannot get next from empty list');
    }
    
    final T current = values[_index % values.length];
    _index++;
    return current;
  }
} 