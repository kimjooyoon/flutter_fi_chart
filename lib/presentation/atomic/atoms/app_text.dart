import 'package:flutter/material.dart';

/// 텍스트 변형 타입
enum TextVariant {
  /// 제목
  heading,

  /// 본문
  body,

  /// 레이블
  label,

  /// 캡션
  caption,
}

/// 앱에서 사용하는 기본 텍스트 컴포넌트
class AppText extends StatelessWidget {
  /// 텍스트 컴포넌트 생성자
  const AppText(
    this.text, {
    this.variant = TextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  /// 표시할 텍스트
  final String text;

  /// 텍스트 변형 타입
  final TextVariant variant;

  /// 텍스트 색상 (null일 경우 테마 색상 사용)
  final Color? color;

  /// 텍스트 정렬
  final TextAlign? textAlign;

  /// 최대 라인 수
  final int? maxLines;

  /// 오버플로우 처리 방식
  final TextOverflow? overflow;

  TextStyle _getStyleForVariant(BuildContext context, TextVariant variant) {
    final theme = Theme.of(context);

    switch (variant) {
      case TextVariant.heading:
        return theme.textTheme.headlineMedium!;
      case TextVariant.body:
        return theme.textTheme.bodyLarge!;
      case TextVariant.label:
        return theme.textTheme.labelLarge!;
      case TextVariant.caption:
        return theme.textTheme.bodySmall!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getStyleForVariant(context, variant).copyWith(
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
