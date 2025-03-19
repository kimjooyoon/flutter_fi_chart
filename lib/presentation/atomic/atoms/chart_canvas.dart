import 'package:flutter/material.dart';

/// 차트 렌더링을 위한 기본 캔버스 위젯
/// 
/// 모든 차트 유형의 기본이 되는 캔버스 영역을 제공합니다.
/// 그리드, 축, 테두리를 포함하고 차트 렌더링 영역을 정의합니다.
class AtomChartCanvas extends StatelessWidget {
  /// 차트 캔버스 생성자
  const AtomChartCanvas({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  /// 차트 내부에 표시될 위젯
  final Widget child;
  
  /// 차트 캔버스의 너비 (null일 경우 사용 가능한 전체 너비)
  final double? width;
  
  /// 차트 캔버스의 높이 (null일 경우 사용 가능한 전체 높이)
  final double? height;
  
  /// 차트 배경색 (null일 경우 테마 배경색 사용)
  final Color? backgroundColor;
  
  /// 차트 테두리 색상 (null일 경우 테마 경계선 색상 사용)
  final Color? borderColor;
  
  /// 차트 테두리 두께
  final double borderWidth;
  
  /// 차트 내부 패딩
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        border: Border.all(
          color: borderColor ?? theme.dividerColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
} 