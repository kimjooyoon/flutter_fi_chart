import 'package:flutter/material.dart';

/// 앱에서 사용하는 기본 카드 컴포넌트
class AppCard extends StatelessWidget {
  /// 카드 컴포넌트 생성자
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.elevation = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.color,
    super.key,
  });

  /// 카드 내부 위젯
  final Widget child;

  /// 탭 이벤트 핸들러
  final VoidCallback? onTap;

  /// 내부 패딩
  final EdgeInsetsGeometry padding;

  /// 외부 마진
  final EdgeInsetsGeometry margin;

  /// 그림자 강도
  final double elevation;

  /// 모서리 둥글기
  final BorderRadiusGeometry borderRadius;

  /// 배경 색상 (null일 경우 테마 색상 사용)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: Material(
        color: color ?? theme.colorScheme.surface,
        elevation: elevation,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
