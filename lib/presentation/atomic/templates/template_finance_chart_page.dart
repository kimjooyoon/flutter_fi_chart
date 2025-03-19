import 'package:flutter/material.dart';

/// 금융 차트 페이지의 템플릿
/// 
/// 금융 차트 관련 페이지의 기본 레이아웃을 정의합니다.
/// 헤더, 차트 영역, 정보 패널 등의 배치를 담당합니다.
class TemplateFinanceChartPage extends StatelessWidget {
  /// 금융 차트 페이지 템플릿 생성자
  const TemplateFinanceChartPage({
    super.key,
    required this.headerBuilder,
    required this.chartBuilder,
    this.infoBuilder,
    this.actionBuilder,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
  });

  /// 헤더 위젯 빌더
  final WidgetBuilder headerBuilder;
  
  /// 차트 위젯 빌더
  final WidgetBuilder chartBuilder;
  
  /// 정보 패널 위젯 빌더 (선택적)
  final WidgetBuilder? infoBuilder;
  
  /// 액션 버튼 위젯 빌더 (선택적)
  final WidgetBuilder? actionBuilder;
  
  /// 배경색 (null일 경우 테마 배경색 사용)
  final Color? backgroundColor;
  
  /// 내부 패딩
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 헤더 영역
              Builder(builder: headerBuilder),
              
              const SizedBox(height: 16),
              
              // 차트 영역 - Expanded로 가용 공간을 최대한 활용
              Expanded(
                flex: 3,
                child: Builder(builder: chartBuilder),
              ),
              
              // 정보 패널 영역 (있는 경우)
              if (infoBuilder != null) ...[
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: Builder(builder: infoBuilder!),
                ),
              ],
              
              // 액션 버튼 영역 (있는 경우)
              if (actionBuilder != null) ...[
                const SizedBox(height: 16),
                Builder(builder: actionBuilder!),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 