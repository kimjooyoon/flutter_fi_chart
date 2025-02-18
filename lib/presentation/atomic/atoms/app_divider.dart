import 'package:flutter/material.dart';

/// 앱에서 사용하는 기본 구분선 컴포넌트
class AppDivider extends StatelessWidget {
  /// 구분선 컴포넌트 생성자
  const AppDivider({
    this.height = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
    this.thickness = 1.0,
    super.key,
  });

  /// 구분선의 높이 (패딩 포함)
  final double height;

  /// 시작 부분 들여쓰기
  final double indent;

  /// 끝 부분 들여쓰기
  final double endIndent;

  /// 구분선 색상 (null일 경우 테마 색상 사용)
  final Color? color;

  /// 구분선 두께
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: height,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.colorScheme.outlineVariant,
      thickness: thickness,
    );
  }
}

/// 앱에서 사용하는 기본 수직 구분선 컴포넌트
class AppVerticalDivider extends StatelessWidget {
  /// 수직 구분선 컴포넌트 생성자
  const AppVerticalDivider({
    this.width = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
    this.thickness = 1.0,
    super.key,
  });

  /// 구분선의 너비 (패딩 포함)
  final double width;

  /// 시작 부분 들여쓰기
  final double indent;

  /// 끝 부분 들여쓰기
  final double endIndent;

  /// 구분선 색상 (null일 경우 테마 색상 사용)
  final Color? color;

  /// 구분선 두께
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VerticalDivider(
      width: width,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.colorScheme.outlineVariant,
      thickness: thickness,
    );
  }
}
