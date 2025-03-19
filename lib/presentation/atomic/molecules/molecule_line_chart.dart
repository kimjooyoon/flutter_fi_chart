import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/chart_canvas.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/chart_grid.dart';

/// 라인 차트 분자 컴포넌트
///
/// 시계열 데이터를 라인 차트로 표시하는 분자 컴포넌트입니다.
/// 여러 원자 컴포넌트(차트 캔버스, 그리드 등)를 조합하여 라인 차트를 구성합니다.
class MoleculeLineChart extends StatelessWidget {
  /// 라인 차트 생성자
  const MoleculeLineChart({
    super.key,
    required this.data,
    this.title,
    this.lineColor,
    this.gradientColors,
    this.showDots = false,
    this.showAreaUnderLine = true,
    this.showGridLines = true,
    this.lineWidth = 2.0,
    this.height,
    this.topTitle,
    this.onDataPointTap,
  });

  /// 차트 데이터 (x: 인덱스, y: 값)
  final List<FlSpot> data;
  
  /// 차트 제목 (선택적)
  final String? title;
  
  /// 라인 색상 (null이면 테마 기본 색상 사용)
  final Color? lineColor;
  
  /// 그라데이션 색상 (null이면 라인 색상 기반으로 생성)
  final List<Color>? gradientColors;
  
  /// 데이터 포인트에 점 표시 여부
  final bool showDots;
  
  /// 라인 아래 영역 채우기 여부
  final bool showAreaUnderLine;
  
  /// 그리드 라인 표시 여부
  final bool showGridLines;
  
  /// 라인 두께
  final double lineWidth;
  
  /// 차트 높이 (null이면 주변 컨테이너에 맞춤)
  final double? height;
  
  /// 차트 상단에 표시할 위젯 (선택적)
  final Widget? topTitle;
  
  /// 데이터 포인트 탭 핸들러
  final void Function(int index, FlSpot spot)? onDataPointTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualLineColor = lineColor ?? theme.colorScheme.primary;
    final actualGradientColors = gradientColors ?? [
      actualLineColor.withOpacity(0.5),
      actualLineColor.withOpacity(0.1),
    ];
    
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
                top: 16.0,
                bottom: 8.0,
              ),
              child: showGridLines
                ? AtomChartGrid(
                    showHorizontalLines: true,
                    showVerticalLines: false,
                    horizontalLineColor: theme.dividerColor.withOpacity(0.3),
                    horizontalDashPattern: [5, 5],
                    child: _buildLineChart(
                      actualLineColor,
                      actualGradientColors,
                      context,
                    ),
                  )
                : _buildLineChart(
                    actualLineColor,
                    actualGradientColors,
                    context,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  /// 라인 차트 위젯을 생성하는 메서드
  Widget _buildLineChart(
    Color lineColor,
    List<Color> gradientColors,
    BuildContext context,
  ) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
          ),
          touchCallback: (touchEvent, touchResponse) {
            if (touchResponse != null && 
                touchResponse.lineBarSpots != null && 
                touchResponse.lineBarSpots!.isNotEmpty && 
                touchEvent is FlTapUpEvent && 
                onDataPointTap != null) {
              final spot = touchResponse.lineBarSpots!.first;
              onDataPointTap!(spot.spotIndex, FlSpot(spot.x, spot.y));
            }
          },
          handleBuiltInTouches: true,
        ),
        gridData: FlGridData(
          show: false, // AtomChartGrid에서 처리
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                // 데이터 포인트가 10개 이상이면 일부만 표시
                if (data.length > 10) {
                  final interval = (data.length / 5).ceil();
                  if (value.toInt() % interval != 0) {
                    return const SizedBox();
                  }
                }
                
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      value.toInt().toString(),
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
                  value.toStringAsFixed(1),
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
        minX: 0,
        maxX: data.isEmpty ? 0 : (data.length - 1).toDouble(),
        minY: data.isEmpty ? 0 : data.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.9,
        maxY: data.isEmpty ? 0 : data.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: lineColor,
            barWidth: lineWidth,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: showDots,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: lineColor,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: showAreaUnderLine,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 