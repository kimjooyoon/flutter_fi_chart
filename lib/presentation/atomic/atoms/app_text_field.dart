import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 앱에서 사용하는 기본 텍스트 필드 컴포넌트
class AppTextField extends StatelessWidget {
  /// 텍스트 필드 생성자
  const AppTextField({
    required this.label,
    this.prefix,
    this.value,
    this.error,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// 레이블 텍스트
  final String label;

  /// 접두사 위젯 (예: 통화 기호)
  final Widget? prefix;

  /// 초기값
  final String? value;

  /// 에러 메시지
  final String? error;

  /// 활성화 여부
  final bool enabled;

  /// 키보드 타입
  final TextInputType? keyboardType;

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// 값 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 제출 콜백
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: value != null ? TextEditingController(text: value) : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        errorText: error,
        enabled: enabled,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: theme.textTheme.bodyLarge,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
    );
  }
}
