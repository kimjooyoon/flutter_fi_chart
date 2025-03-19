import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/chart_canvas.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/chart_grid.dart';

/// 바 차트 데이터 모델
class BarChartDataItem {
  /// 바 차트 데이터 아이템 생성자
  BarChartDataItem({
    required this.x,
    required this.y,
    this.color,
    this.label,
  });

  /// X축 값 (인덱스)
  final int x;
  
  /// Y축 값 (높이)
  final double y;
  
  /// 막대 색상 (null이면 테마 기본 색상 사용)
  final Color? color;
  
  /// 막대에 표시할 레이블 (선택적)
  final String? label;
}

/// 바 차트 분자 컴포넌트
///
/// 카테고리별 데이터를 막대 형태로 표시하는 분자 컴포넌트입니다.
/// 여러 원자 컴포넌트(차트 캔버스, 그리드 등)를 조합하여 바 차트를 구성합니다.
class MoleculeBarChart extends StatelessWidget {
  /// 바 차트 생성자
  const MoleculeBarChart({
    super.key,
    required this.data,
    this.title,
    this.defaultBarColor,
    this.barWidth = 22,
    this.borderRadius,
    this.showGridLines = true,
    this.showLabelsOnBars = false,
    this.spacing = 12,
    this.height,
    this.topTitle,
    this.xAxisLabels,
    this.onBarTap,
  });

  /// 차트 데이터
  final List<BarChartDataItem> data;
  
  /// 차트 제목 (선택적)
  final String? title;
  
  /// 기본 막대 색상 (null이면 테마 기본 색상 사용)
  final Color? defaultBarColor;
  
  /// 막대 너비
  final double barWidth;
  
  /// 막대 모서리 둥글기 (null이면 기본값 적용)
  final BorderRadius? borderRadius;
  
  /// 그리드 라인 표시 여부
  final bool showGridLines;
  
  /// 막대 위에 값 레이블 표시 여부
  final bool showLabelsOnBars;
  
  /// 막대 간 간격
  final double spacing;
  
  /// 차트 높이 (null이면 주변 컨테이너에 맞춤)
  final double? height;
  
  /// 차트 상단에 표시할 위젯 (선택적)
  final Widget? topTitle;
  
  /// X축 레이블 (null이면 인덱스 표시)
  final List<String>? xAxisLabels;
  
  /// 막대 탭 핸들러
  final void Function(int index, BarChartDataItem item)? onBarTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualBarColor = defaultBarColor ?? theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 타이틀 위젯 (있는 경우)
        if (topTitle != null) ...[
          topTitle!,
          const SizedBox(height: 8),
        ],
        
        // 제목 (있는 경우)
        if (title != null) ...[
          Text(
            title!,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
        ],
        
        // 차트 영역
        SizedBox(
          height: height,
          child: AtomChartCanvas(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 8.0,
                top: 24.0, // 막대 위에 레이블을 표시할 공간
                bottom: 8.0,
              ),
              child: showGridLines
                ? AtomChartGrid(
                    showHorizontalLines: true,
                    showVerticalLines: false,
                    horizontalLineColor: theme.dividerColor.withOpacity(0.3),
                    horizontalDashPattern: [5, 5],
                    child: _buildBarChart(
                      actualBarColor,
                      context,
                    ),
                  )
                : _buildBarChart(
                    actualBarColor,
                    context,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  /// 바 차트 위젯을 생성하는 메서드
  Widget _buildBarChart(
    Color defaultColor,
    BuildContext context,
  ) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${xAxisLabels != null && groupIndex < xAxisLabels!.length ? xAxisLabels![groupIndex] : 'X: $groupIndex'}\n',
                const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${data[groupIndex].y.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            },
          ),
          touchCallback: (event, touchResponse) {
            if (touchResponse != null && touchResponse.spot != null && event is FlTapUpEvent) {
              final int index = touchResponse.spot!.touchedBarGroupIndex;
              if (index >= 0 && index < data.length && onBarTap != null) {
                onBarTap!(index, data[index]);
              }
            }
          },
        ),
        gridData: FlGridData(
          show: false, // AtomChartGrid에서 처리
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final label = xAxisLabels != null && index < xAxisLabels!.length
                      ? xAxisLabels![index]
                      : index.toString();
                  
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xff68737d),
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Color(0xff68737d),
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _createBarGroups(defaultColor),
        minY: 0,
        maxY: data.isEmpty ? 10 : data.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1,
      ),
    );
  }

  /// 바 그룹을 생성하는 메서드
  List<BarChartGroupData> _createBarGroups(Color defaultColor) {
    return List.generate(data.length, (index) {
      final item = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.y,
            color: item.color ?? defaultColor,
            width: barWidth,
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            // 막대 위에 레이블 표시
            backDrawRodData: showLabelsOnBars ? BackgroundBarChartRodData(
              show: true,
              toY: item.y + 2,
              color: Colors.transparent,
            ) : null,
          ),
        ],
        // 막대 위에 값 표시
        showingTooltipIndicators: showLabelsOnBars ? [0] : [],
      );
    });
  }
} 