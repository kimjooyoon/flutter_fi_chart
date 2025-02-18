import 'package:flutter/material.dart';

/// 앱에서 사용하는 기본 아이콘 컴포넌트
class AppIcon extends StatelessWidget {
  /// 아이콘 컴포넌트 생성자
  const AppIcon({
    required this.icon,
    this.size = 24.0,
    this.color,
    super.key,
  });

  /// 아이콘 데이터
  final IconData icon;

  /// 아이콘 크기
  final double size;

  /// 아이콘 색상 (null일 경우 테마 색상 사용)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(
      icon,
      size: size,
      color: color ?? theme.colorScheme.onSurface,
    );
  }
}

/// 앱에서 사용하는 아이콘 세트
class AppIcons {
  /// 거래 아이콘
  static const IconData trade = Icons.swap_horiz;

  /// 포트폴리오 아이콘
  static const IconData portfolio = Icons.pie_chart;

  /// 설정 아이콘
  static const IconData settings = Icons.settings;

  /// 차트 아이콘
  static const IconData chart = Icons.show_chart;

  /// 알림 아이콘
  static const IconData notification = Icons.notifications;

  /// 검색 아이콘
  static const IconData search = Icons.search;

  /// 필터 아이콘
  static const IconData filter = Icons.filter_list;

  /// 더보기 아이콘
  static const IconData more = Icons.more_vert;

  /// 닫기 아이콘
  static const IconData close = Icons.close;

  /// 추가 아이콘
  static const IconData add = Icons.add;

  /// 삭제 아이콘
  static const IconData delete = Icons.delete;

  /// 편집 아이콘
  static const IconData edit = Icons.edit;
}
