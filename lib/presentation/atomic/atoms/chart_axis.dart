/// 차트 축 구성요소 파일
///
/// 이 파일은 금융 차트에서 X축과 Y축을 렌더링하는 구성요소를 정의합니다.
/// 주요 클래스인 [AtomChartAxis]는 레이블, 눈금, 그리드 라인을 포함한 차트 축을 표시합니다.
/// 점선 표시를 위한 유틸리티 함수와 클래스도 포함되어 있습니다.
///
/// 예시:
/// ```dart
/// AtomChartAxis(
///   direction: AxisDirection.horizontal,
///   labels: ['1월', '2월', '3월', '4월'],
///   values: [0.0, 0.33, 0.66, 1.0],
///   showGrid: true,
///   gridColor: Colors.grey.withOpacity(0.3),
/// )
/// ```
import 'package:flutter/material.dart';
import 'dart:ui' show PathMetric;

/// 차트 축 방향
///
/// 차트 축의 방향을 정의하는 열거형입니다.
/// 축의 레이아웃과 렌더링 방법을 결정합니다.
enum AxisDirection {
  /// 수평 방향 (X축)
  /// 
  /// 일반적으로 시간 또는 카테고리 데이터에 사용됩니다.
  /// 예: 날짜, 월, 분기 등의 표시
  horizontal,
  
  /// 수직 방향 (Y축)
  /// 
  /// 일반적으로 수치 데이터의 값을 표시하는 데 사용됩니다.
  /// 예: 주가, 거래량, 백분율 등의 표시
  vertical,
}

/// 차트 축 위젯
///
/// 차트의 X축 또는 Y축을 렌더링하는 기본 위젯입니다.
/// 눈금, 레이블, 그리드 라인 등을 포함하며 다양한 스타일 옵션을 제공합니다.
///
/// [labels]와 [values]의 관계:
/// - [labels]: 축에 표시할 텍스트 라벨 목록
/// - [values]: 각 라벨의 상대적 위치 (0.0 ~ 1.0 사이의 값)
///   예: values[0]=0.0은 축의 시작 지점, values[1]=1.0은 축의 끝 지점
class AtomChartAxis extends StatelessWidget {
  /// 차트 축 생성자
  ///
  /// [direction]은 축의 방향을 지정합니다 (수평 또는 수직).
  /// [labels]과 [values]는 같은 길이의 리스트여야 합니다.
  /// [showGrid]가 true이면 각 라벨 위치에 그리드 라인이 표시됩니다.
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
  ///
  /// X축인 경우 [AxisDirection.horizontal], 
  /// Y축인 경우 [AxisDirection.vertical]을 사용합니다.
  final AxisDirection direction;
  
  /// 축에 표시될 레이블 목록
  ///
  /// 각 레이블은 [values] 리스트의 해당 위치에 표시됩니다.
  /// 예: 날짜, 카테고리, 숫자 값 등
  final List<String> labels;
  
  /// 레이블에 해당하는 값 목록 (위치 계산에 사용)
  ///
  /// 각 값은 0.0에서 1.0 사이의 값이어야 합니다.
  /// 0.0은 축의 시작 위치, 1.0은 축의 끝 위치를 의미합니다.
  /// 예: [0.0, 0.25, 0.5, 0.75, 1.0]
  final List<double> values;
  
  /// 그리드 라인 표시 여부
  ///
  /// true인 경우 각 라벨 위치에 그리드 라인이 표시됩니다.
  final bool showGrid;
  
  /// 그리드 라인 색상
  ///
  /// null인 경우 현재 테마의 dividerColor에 투명도를 적용한 색상이 사용됩니다.
  final Color? gridColor;
  
  /// 그리드 라인 두께
  ///
  /// 기본값은 0.5픽셀입니다.
  final double gridWidth;
  
  /// 그리드 라인 대시 패턴 (null이면 실선)
  ///
  /// 예: [5, 3]은 5픽셀 선과 3픽셀 공백이 번갈아가며 표시됩니다.
  final List<double>? gridDashPattern;
  
  /// 레이블 텍스트 스타일
  ///
  /// null인 경우 현재 테마의 bodySmall 텍스트 스타일이 사용됩니다.
  final TextStyle? labelStyle;
  
  /// 축 라인 색상
  ///
  /// null인 경우 현재 테마의 dividerColor가 사용됩니다.
  final Color? axisColor;
  
  /// 축 라인 두께
  ///
  /// 기본값은 1.0픽셀입니다.
  final double axisWidth;
  
  /// 눈금 길이
  ///
  /// 축에서 눈금의 돌출 길이를 픽셀 단위로 지정합니다.
  /// 기본값은 5.0픽셀입니다.
  final double tickLength;
  
  /// 눈금 두께
  ///
  /// 기본값은 1.0픽셀입니다.
  final double tickWidth;
  
  /// 눈금 색상
  ///
  /// null인 경우 현재 테마의 dividerColor가 사용됩니다.
  final Color? tickColor;
  
  /// 레이블 표시 여부
  ///
  /// false인 경우 축에 레이블이 표시되지 않습니다.
  final bool showLabels;
  
  /// 레이블 패딩
  ///
  /// 레이블과 눈금 사이의 여백을 지정합니다.
  /// 기본값은 모든 방향에 4.0픽셀입니다.
  final EdgeInsetsGeometry labelPadding;
  
  /// 레이블 회전 각도 (라디안)
  ///
  /// 레이블을 회전하는 각도를 라디안 단위로 지정합니다.
  /// 예: 0.0은 회전 없음, pi/4는 45도 회전
  final double labelRotation;

  @override
  Widget build(BuildContext context) {
    // 현재 테마를 가져와 기본 스타일 설정에 사용
    final theme = Theme.of(context);
    
    // CustomPaint 위젯을 사용하여 축을 그림
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
      size: Size.infinite, // 부모 위젯의 크기에 맞춤
    );
  }
}

/// 차트 축을 그리는 커스텀 페인터
///
/// [CustomPainter]를 확장하여 캔버스에 축, 눈금, 그리드 라인, 레이블을 그립니다.
/// [AtomChartAxis] 위젯의 내부 구현에 사용됩니다.
class _AxisPainter extends CustomPainter {
  /// _AxisPainter 생성자
  ///
  /// 모든 렌더링 관련 속성을 받아 축을 그리는 데 사용합니다.
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

  // 속성들에 대한 정의 (AtomChartAxis에서 전달받음)
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
    // 축 라인을 그리기 위한 Paint 객체
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = axisWidth
      ..style = PaintingStyle.stroke;
      
    // 눈금을 그리기 위한 Paint 객체
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = tickWidth
      ..style = PaintingStyle.stroke;
      
    // 그리드 라인을 그리기 위한 Paint 객체
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = gridWidth
      ..style = PaintingStyle.stroke;
    
    // 대시 패턴 설정 (점선)
    if (gridDashPattern != null && gridDashPattern!.isNotEmpty) {
      gridPaint.shader = null; // 이전 셰이더 제거
      gridPaint.strokeCap = StrokeCap.butt; // 직선 끝 스타일
    }
    
    // 축 방향에 따라 다르게 그리기
    if (direction == AxisDirection.horizontal) {
      _drawHorizontalAxis(canvas, size, axisPaint, tickPaint, gridPaint);
    } else {
      _drawVerticalAxis(canvas, size, axisPaint, tickPaint, gridPaint);
    }
  }
  
  /// 수평축(X축) 그리기
  ///
  /// 캔버스에 수평 방향 축, 눈금, 그리드 라인, 레이블을 그립니다.
  /// 
  /// [canvas]: 그림을 그릴 캔버스
  /// [size]: 캔버스의 크기
  /// [axisPaint]: 축 라인을 그리기 위한 Paint 객체
  /// [tickPaint]: 눈금을 그리기 위한 Paint 객체
  /// [gridPaint]: 그리드 라인을 그리기 위한 Paint 객체
  void _drawHorizontalAxis(Canvas canvas, Size size, Paint axisPaint, 
                           Paint tickPaint, Paint gridPaint) {
    // X축 그리기 (하단 수평선)
    canvas.drawLine(
      Offset(0, size.height), // 왼쪽 하단 시작점
      Offset(size.width, size.height), // 오른쪽 하단 끝점
      axisPaint,
    );
    
    // 각 값에 대한 눈금과 그리드 그리기
    for (int i = 0; i < values.length; i++) {
      // labels 배열 범위 확인
      if (i >= labels.length) continue;
      
      // 값의 상대적 위치를 실제 x 좌표로 변환 (0.0~1.0 → 0~size.width)
      final x = values[i] * size.width;
      
      // 그리드 라인 (세로선) 그리기
      if (showGrid) {
        if (gridDashPattern != null && gridDashPattern!.isNotEmpty) {
          // 점선 그리드 라인
          _drawDashedLine(
            canvas, 
            Offset(x, 0), // 위쪽 시작점
            Offset(x, size.height), // 아래쪽 끝점
            gridPaint,
            gridDashPattern!,
          );
        } else {
          // 실선 그리드 라인
          canvas.drawLine(
            Offset(x, 0), // 위쪽 시작점
            Offset(x, size.height), // 아래쪽 끝점
            gridPaint,
          );
        }
      }
      
      // 눈금 그리기 (축에서 위쪽으로 돌출된 작은 선)
      canvas.drawLine(
        Offset(x, size.height), // 축 위의 시작점
        Offset(x, size.height - tickLength), // 위쪽으로 tickLength만큼 이동한 끝점
        tickPaint,
      );
      
      // 레이블 그리기
      if (showLabels) {
        // 텍스트 스팬 생성
        final textSpan = TextSpan(
          text: labels[i],
          style: labelStyle,
        );
        
        // 텍스트 페인터 설정
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        
        // 텍스트 레이아웃 계산
        textPainter.layout();
        
        // 레이블 회전 적용 (캔버스 변환 시작)
        canvas.save();
        // EdgeInsets 타입으로 캐스팅하여 구체적인 속성 접근
        canvas.translate(x, size.height + (labelPadding as EdgeInsets).top + (labelPadding as EdgeInsets).bottom / 2);
        canvas.rotate(labelRotation); // 회전 적용
        
        // 텍스트 그리기
        textPainter.paint(
          canvas, 
          Offset(
            -textPainter.width / 2, // 레이블 중앙 정렬
            tickLength + (labelPadding as EdgeInsets).top, // 눈금 아래에 배치
          ),
        );
        
        // 캔버스 변환 복원
        canvas.restore();
      }
    }
  }
  
  /// 수직축(Y축) 그리기
  ///
  /// 캔버스에 수직 방향 축, 눈금, 그리드 라인, 레이블을 그립니다.
  /// 
  /// [canvas]: 그림을 그릴 캔버스
  /// [size]: 캔버스의 크기
  /// [axisPaint]: 축 라인을 그리기 위한 Paint 객체
  /// [tickPaint]: 눈금을 그리기 위한 Paint 객체
  /// [gridPaint]: 그리드 라인을 그리기 위한 Paint 객체
  void _drawVerticalAxis(Canvas canvas, Size size, Paint axisPaint, 
                         Paint tickPaint, Paint gridPaint) {
    // Y축 그리기 (왼쪽 수직선)
    canvas.drawLine(
      Offset(0, 0), // 왼쪽 상단 시작점
      Offset(0, size.height), // 왼쪽 하단 끝점
      axisPaint,
    );
    
    // 각 값에 대한 눈금과 그리드 그리기
    for (int i = 0; i < values.length; i++) {
      // labels 배열 범위 확인
      if (i >= labels.length) continue;
      
      // 값의 상대적 위치를 실제 y 좌표로 변환 (주의: y축은 위아래가 반전됨)
      // 0.0은 아래쪽, 1.0은 위쪽을 의미함
      final y = size.height - (values[i] * size.height);
      
      // 그리드 라인 (가로선) 그리기
      if (showGrid) {
        if (gridDashPattern != null && gridDashPattern!.isNotEmpty) {
          // 점선 그리드 라인
          _drawDashedLine(
            canvas, 
            Offset(0, y), // 왼쪽 시작점
            Offset(size.width, y), // 오른쪽 끝점
            gridPaint,
            gridDashPattern!,
          );
        } else {
          // 실선 그리드 라인
          canvas.drawLine(
            Offset(0, y), // 왼쪽 시작점
            Offset(size.width, y), // 오른쪽 끝점
            gridPaint,
          );
        }
      }
      
      // 눈금 그리기 (축에서 오른쪽으로 돌출된 작은 선)
      canvas.drawLine(
        Offset(0, y), // 축 위의 시작점
        Offset(tickLength, y), // 오른쪽으로 tickLength만큼 이동한 끝점
        tickPaint,
      );
      
      // 레이블 그리기
      if (showLabels) {
        // 텍스트 스팬 생성
        final textSpan = TextSpan(
          text: labels[i],
          style: labelStyle,
        );
        
        // 텍스트 페인터 설정
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right, // 오른쪽 정렬 (Y축은 레이블이 왼쪽에 표시)
        );
        
        // 텍스트 레이아웃 계산
        textPainter.layout();
        
        // 레이블 회전 적용 (캔버스 변환 시작)
        canvas.save();
        // EdgeInsets 타입으로 캐스팅하여 구체적인 속성 접근
        canvas.translate(-((labelPadding as EdgeInsets).left + (labelPadding as EdgeInsets).right) / 2, y);
        canvas.rotate(labelRotation); // 회전 적용
        
        // 텍스트 그리기
        textPainter.paint(
          canvas, 
          Offset(
            -textPainter.width - tickLength - (labelPadding as EdgeInsets).right, // 눈금 왼쪽에 배치
            -textPainter.height / 2, // 세로 중앙 정렬
          ),
        );
        
        // 캔버스 변환 복원
        canvas.restore();
      }
    }
  }
  
  /// 점선 그리기 헬퍼 메서드
  ///
  /// 두 점 사이에 점선을 그립니다.
  /// 
  /// [canvas]: 그림을 그릴 캔버스
  /// [p1]: 시작점
  /// [p2]: 끝점
  /// [paint]: 선을 그리기 위한 Paint 객체
  /// [dashPattern]: 점선 패턴 (예: [5, 3]은 5픽셀 선과 3픽셀 공백)
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, 
                      Paint paint, List<double> dashPattern) {
    // 두 점을 잇는 경로 생성
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);
      
    // 점선 경로로 변환하여 그리기
    canvas.drawPath(
      dashPath(path, dashArray: CircularIntervalList(dashPattern)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 항상 다시 그리도록 true 반환
    // 최적화가 필요한 경우 이전 값과 비교하여 변경된 경우만 다시 그리도록 수정 가능
    return true;
  }
}

/// 대시 패턴을 위한 헬퍼 클래스
///
/// 점선 패턴을 순환적으로 제공하는 클래스입니다.
/// 리스트의 끝에 도달하면 다시 처음부터 값을 제공합니다.
class CircularIntervalList<T> {
  /// 순환 간격 리스트 생성자
  ///
  /// [values]: 순환할 값 목록
  CircularIntervalList(this.values);
  
  /// 순환할 값 목록
  final List<T> values;
  
  /// 현재 인덱스
  int _index = 0;
  
  /// 다음 값 가져오기
  ///
  /// 현재 인덱스의 값을 반환하고 인덱스를 증가시킵니다.
  /// 인덱스가 리스트 길이를 초과하면 모듈로 연산으로 다시 처음으로 순환합니다.
  /// 
  /// 리스트가 비어있으면 예외를 발생시킵니다.
  /// 
  /// 반환값: 현재 인덱스의 값
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
///
/// 주어진 경로를 따라 점선 패턴을 적용한 새 경로를 반환합니다.
///
/// [source]: 원본 경로
/// [dashArray]: 점선 패턴 (순환 간격 리스트)
/// [dashOffset]: 시작 오프셋 (기본값: 0.0)
///
/// 반환값: 점선 패턴이 적용된 새 경로
Path dashPath(
  Path source, {
  required CircularIntervalList<double> dashArray,
  double? dashOffset,
}) {
  // 기본 오프셋 값 설정
  dashOffset ??= 0.0;
  
  // 결과 경로 생성
  final Path dest = Path();
  
  // 원본 경로의 메트릭스 계산 (경로 길이 정보)
  for (final PathMetric metric in source.computeMetrics()) {
    double distance = dashOffset;
    bool draw = true; // 그리기 상태 (true: 선, false: 공백)
    
    // 경로를 따라 점선 패턴 적용
    while (distance < metric.length) {
      // 다음 대시 또는 공백 길이 가져오기
      final double len = dashArray.next;
      
      // 그리기 상태일 때만 경로에 추가
      if (draw) {
        // 현재 위치에서 특정 길이만큼의 부분 경로 추출하여 결과 경로에 추가
        dest.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
      }
      
      // 다음 위치로 이동
      distance += len;
      
      // 그리기 상태 토글 (선 → 공백 → 선 → ...)
      draw = !draw;
    }
  }
  
  // 점선 패턴이 적용된 결과 경로 반환
  return dest;
} 