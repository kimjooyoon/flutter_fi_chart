import 'package:flutter/material.dart';

/// 차트 축 방향
enum AxisDirection {
  /// 수평 방향 (X축)
  horizontal,
  
  /// 수직 방향 (Y축)
  vertical,
}

/// 차트 축 위젯
///
/// 차트의 X축 또는 Y축을 렌더링하는 기본 위젯입니다.
/// 눈금, 레이블, 그리드 라인 등을 포함합니다.
class AtomChartAxis extends StatelessWidget {
  /// 차트 축 생성자
  const AtomChartAxis({
    super.key,
    required this.direction,
    required this.labels,
    required this.values,
    this.showGrid = true,
    this.gridColor,
    this.gridWidth = 0.5,
    this.gridDashPattern,
    this.labelStyle,
    this.axisColor,
    this.axisWidth = 1.0,
    this.tickLength = 5.0,
    this.tickWidth = 1.0,
    this.tickColor,
    this.showLabels = true,
    this.labelPadding = const EdgeInsets.all(4.0),
    this.labelRotation = 0.0,
  });

  /// 축 방향 (수평 또는 수직)
  final AxisDirection direction;
  
  /// 축에 표시될 레이블 목록
  final List<String> labels;
  
  /// 레이블에 해당하는 값 목록 (위치 계산에 사용)
  final List<double> values;
  
  /// 그리드 라인 표시 여부
  final bool showGrid;
  
  /// 그리드 라인 색상
  final Color? gridColor;
  
  /// 그리드 라인 두께
  final double gridWidth;
  
  /// 그리드 라인 대시 패턴 (null이면 실선)
  final List<double>? gridDashPattern;
  
  /// 레이블 텍스트 스타일
  final TextStyle? labelStyle;
  
  /// 축 라인 색상
  final Color? axisColor;
  
  /// 축 라인 두께
  final double axisWidth;
  
  /// 눈금 길이
  final double tickLength;
  
  /// 눈금 두께
  final double tickWidth;
  
  /// 눈금 색상
  final Color? tickColor;
  
  /// 레이블 표시 여부
  final bool showLabels;
  
  /// 레이블 패딩
  final EdgeInsetsGeometry labelPadding;
  
  /// 레이블 회전 각도 (라디안)
  final double labelRotation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomPaint(
      painter: _AxisPainter(
        direction: direction,
        labels: labels,
        values: values,
        showGrid: showGrid,
        gridColor: gridColor ?? theme.dividerColor.withOpacity(0.5),
        gridWidth: gridWidth,
        gridDashPattern: gridDashPattern,
        labelStyle: labelStyle ?? theme.textTheme.bodySmall,
        axisColor: axisColor ?? theme.dividerColor,
        axisWidth: axisWidth,
        tickLength: tickLength,
        tickWidth: tickWidth,
        tickColor: tickColor ?? theme.dividerColor,
        showLabels: showLabels,
        labelPadding: labelPadding,
        labelRotation: labelRotation,
      ),
      size: Size.infinite,
    );
  }
}

/// 차트 축을 그리는 커스텀 페인터
class _AxisPainter extends CustomPainter {
  _AxisPainter({
    required this.direction,
    required this.labels,
    required this.values,
    required this.showGrid,
    required this.gridColor,
    required this.gridWidth,
    this.gridDashPattern,
    required this.labelStyle,
    required this.axisColor,
    required this.axisWidth,
    required this.tickLength,
    required this.tickWidth,
    required this.tickColor,
    required this.showLabels,
    required this.labelPadding,
    required this.labelRotation,
  });

  final AxisDirection direction;
  final List<String> labels;
  final List<double> values;
  final bool showGrid;
  final Color gridColor;
  final double gridWidth;
  final List<double>? gridDashPattern;
  final TextStyle? labelStyle;
  final Color axisColor;
  final double axisWidth;
  final double tickLength;
  final double tickWidth;
  final Color tickColor;
  final bool showLabels;
  final EdgeInsetsGeometry labelPadding;
  final double labelRotation;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = axisWidth
      ..style = PaintingStyle.stroke;
      
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = tickWidth
      ..style = PaintingStyle.stroke;
      
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = gridWidth
      ..style = PaintingStyle.stroke;
    
    if (gridDashPattern != null && gridDashPattern!.isNotEmpty) {
      gridPaint.shader = null; // Clear any previous shader
      gridPaint.strokeCap = StrokeCap.butt;
    }
    
    // 축 방향에 따라 다르게 그리기
    if (direction == AxisDirection.horizontal) {
      _drawHorizontalAxis(canvas, size, axisPaint, tickPaint, gridPaint);
    } else {
      _drawVerticalAxis(canvas, size, axisPaint, tickPaint, gridPaint);
    }
  }
  
  /// 수평축(X축) 그리기
  void _drawHorizontalAxis(Canvas canvas, Size size, Paint axisPaint, 
                           Paint tickPaint, Paint gridPaint) {
    // X축 그리기
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );
    
    // 각 값에 대한 눈금과 그리드 그리기
    for (int i = 0; i < values.length; i++) {
      if (i >= labels.length) continue;
      
      final x = values[i] * size.width;
      
      // 그리드 라인 (세로선)
      if (showGrid) {
        if (gridDashPattern != null && gridDashPattern!.isNotEmpty) {
          _drawDashedLine(
            canvas, 
            Offset(x, 0),
            Offset(x, size.height),
            gridPaint,
            gridDashPattern!,
          );
        } else {
          canvas.drawLine(
            Offset(x, 0),
            Offset(x, size.height),
            gridPaint,
          );
        }
      }
      
      // 눈금 그리기
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - tickLength),
        tickPaint,
      );
      
      // 레이블 그리기
      if (showLabels) {
        final textSpan = TextSpan(
          text: labels[i],
          style: labelStyle,
        );
        
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        
        textPainter.layout();
        
        // 레이블 회전 적용
        canvas.save();
        canvas.translate(x, size.height + labelPadding.vertical / 2);
        canvas.rotate(labelRotation);
        
        textPainter.paint(
          canvas, 
          Offset(
            -textPainter.width / 2,
            tickLength + labelPadding.top,
          ),
        );
        
        canvas.restore();
      }
    }
  }
  
  /// 수직축(Y축) 그리기
  void _drawVerticalAxis(Canvas canvas, Size size, Paint axisPaint, 
                         Paint tickPaint, Paint gridPaint) {
    // Y축 그리기
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, size.height),
      axisPaint,
    );
    
    // 각 값에 대한 눈금과 그리드 그리기
    for (int i = 0; i < values.length; i++) {
      if (i >= labels.length) continue;
      
      final y = size.height - (values[i] * size.height);
      
      // 그리드 라인 (가로선)
      if (showGrid) {
        if (gridDashPattern != null && gridDashPattern!.isNotEmpty) {
          _drawDashedLine(
            canvas, 
            Offset(0, y),
            Offset(size.width, y),
            gridPaint,
            gridDashPattern!,
          );
        } else {
          canvas.drawLine(
            Offset(0, y),
            Offset(size.width, y),
            gridPaint,
          );
        }
      }
      
      // 눈금 그리기
      canvas.drawLine(
        Offset(0, y),
        Offset(tickLength, y),
        tickPaint,
      );
      
      // 레이블 그리기
      if (showLabels) {
        final textSpan = TextSpan(
          text: labels[i],
          style: labelStyle,
        );
        
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
        );
        
        textPainter.layout();
        
        // 레이블 회전 적용
        canvas.save();
        canvas.translate(-labelPadding.horizontal / 2, y);
        canvas.rotate(labelRotation);
        
        textPainter.paint(
          canvas, 
          Offset(
            -textPainter.width - tickLength - labelPadding.right,
            -textPainter.height / 2,
          ),
        );
        
        canvas.restore();
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
      dashPath(path, dashArray: CircularIntervalList(dashPattern)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 대시 패턴을 위한 헬퍼 클래스 및 메서드
class CircularIntervalList<T> {
  CircularIntervalList(this.values);
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

/// 점선 경로를 생성하는 함수
Path dashPath(
  Path source, {
  required CircularIntervalList<double> dashArray,
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