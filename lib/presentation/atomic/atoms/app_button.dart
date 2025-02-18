import 'package:flutter/material.dart';

/// 앱에서 사용하는 기본 버튼 컴포넌트
class AppButton extends StatelessWidget {
  /// 버튼 생성자
  const AppButton({
    required this.label,
    this.onPressed,
    this.isEnabled = true,
    super.key,
  });

  /// 버튼에 표시될 텍스트
  final String label;

  /// 버튼 클릭 시 실행될 콜백
  final VoidCallback? onPressed;

  /// 버튼 활성화 여부
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        foregroundColor: isEnabled
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}
