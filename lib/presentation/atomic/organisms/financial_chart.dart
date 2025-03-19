import 'package:flutter/material.dart';
import '../../../core/models/financial_data.dart';
import '../molecules/candle_chart.dart';

/// 차트 유형
enum ChartType {
  /// 캔들스틱 차트
  candlestick,
  
  /// 라인 차트
  line,
  
  /// 영역 차트
  area,
  
  /// 바 차트
  bar,
  
  /// 혼합 차트
  combo,
}

/// 시간 프레임
enum TimeFrame {
  /// 1분봉
  m1('1분', Duration(minutes: 1)),
  
  /// 5분봉
  m5('5분', Duration(minutes: 5)),
  
  /// 15분봉
  m15('15분', Duration(minutes: 15)),
  
  /// 30분봉
  m30('30분', Duration(minutes: 30)),
  
  /// 1시간봉
  h1('1시간', Duration(hours: 1)),
  
  /// 4시간봉
  h4('4시간', Duration(hours: 4)),
  
  /// 일봉
  d1('일봉', Duration(days: 1)),
  
  /// 주봉
  w1('주봉', Duration(days: 7)),
  
  /// 월봉
  mo1('월봉', Duration(days: 30));
  
  /// 시간 프레임 생성자
  const TimeFrame(this.label, this.duration);
  
  /// 시간 프레임 레이블
  final String label;
  
  /// 시간 간격
  final Duration duration;
}

/// 금융 차트 컴포넌트
///
/// 금융 데이터를 다양한 형태로 시각화하는 완전한 차트 컴포넌트입니다.
/// 차트 유형 전환, 시간 프레임 선택, 기술적 지표 표시 등 다양한 기능을 제공합니다.
class OrganismFinancialChart extends StatefulWidget {
  /// 금융 차트 생성자
  const OrganismFinancialChart({
    super.key,
    required this.series,
    this.initialChartType = ChartType.candlestick,
    this.initialTimeFrame = TimeFrame.d1,
    this.indicators = const [],
    this.title,
    this.showToolbar = true,
    this.showTitleBar = true,
    this.width,
    this.height = 500,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(8),
    this.increasingColor,
    this.decreasingColor,
    this.onTimeFrameChanged,
    this.candleWidth = 8,
    this.candleSpacing = 4,
    this.onChartTypeChanged,
    this.onCandleTap,
  });

  /// 차트 데이터 시리즈
  final FinancialSeries series;
  
  /// 초기 차트 유형
  final ChartType initialChartType;
  
  /// 초기 시간 프레임
  final TimeFrame initialTimeFrame;
  
  /// 기술적 지표 목록
  final List<IndicatorData> indicators;
  
  /// 차트 제목
  final String? title;
  
  /// 툴바 표시 여부
  final bool showToolbar;
  
  /// 제목 표시줄 표시 여부
  final bool showTitleBar;
  
  /// 차트 너비
  final double? width;
  
  /// 차트 높이
  final double height;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 테두리 색상
  final Color? borderColor;
  
  /// 내부 패딩
  final EdgeInsets padding;
  
  /// 상승 캔들 색상
  final Color? increasingColor;
  
  /// 하락 캔들 색상
  final Color? decreasingColor;
  
  /// 캔들 너비
  final double candleWidth;
  
  /// 캔들 간격
  final double candleSpacing;
  
  /// 시간 프레임 변경 콜백
  final void Function(TimeFrame timeFrame)? onTimeFrameChanged;
  
  /// 차트 유형 변경 콜백
  final void Function(ChartType chartType)? onChartTypeChanged;
  
  /// 캔들 탭 이벤트 콜백
  final void Function(CandleData candle)? onCandleTap;

  @override
  State<OrganismFinancialChart> createState() => _OrganismFinancialChartState();
}

class _OrganismFinancialChartState extends State<OrganismFinancialChart> {
  late ChartType _chartType;
  late TimeFrame _timeFrame;
  CandleData? _selectedCandle;
  bool _showIndicators = true;
  bool _isFullScreen = false;
  List<IndicatorData> _activeIndicators = [];
  
  @override
  void initState() {
    super.initState();
    _chartType = widget.initialChartType;
    _timeFrame = widget.initialTimeFrame;
    _activeIndicators = List.from(widget.indicators);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        border: Border.all(
          color: widget.borderColor ?? Theme.of(context).dividerColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showTitleBar) _buildTitleBar(),
          if (widget.showToolbar) _buildToolbar(),
          Expanded(
            child: _buildChart(),
          ),
          if (_selectedCandle != null) _buildCandleInfo(),
        ],
      ),
    );
  }
  
  /// 제목 표시줄 구성
  Widget _buildTitleBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title ?? widget.series.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              _buildPriceInfo(),
              IconButton(
                icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                onPressed: () {
                  setState(() {
                    _isFullScreen = !_isFullScreen;
                  });
                  // 여기에 전체화면 기능 구현
                },
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 가격 정보 위젯
  Widget _buildPriceInfo() {
    if (widget.series.data.isEmpty) return const SizedBox();
    
    final lastCandle = widget.series.data.last;
    final prevCandle = widget.series.data.length > 1 
        ? widget.series.data[widget.series.data.length - 2] 
        : null;
    
    final changePercent = prevCandle != null
        ? ((lastCandle.close / prevCandle.close) - 1) * 100
        : 0.0;
    
    final isPositive = changePercent > 0;
    final color = isPositive 
        ? (widget.increasingColor ?? Colors.green) 
        : (changePercent < 0 ? (widget.decreasingColor ?? Colors.red) : Colors.grey);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastCandle.close.toStringAsFixed(2),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 툴바 구성
  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          _buildChartTypeSelector(),
          const SizedBox(width: 16),
          _buildTimeFrameSelector(),
          const Spacer(),
          _buildIndicatorToggle(),
        ],
      ),
    );
  }
  
  /// 차트 유형 선택기
  Widget _buildChartTypeSelector() {
    return SegmentedButton<ChartType>(
      showSelectedIcon: false,
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: const [
        ButtonSegment<ChartType>(
          value: ChartType.candlestick,
          label: Text('캔들'),
          icon: Icon(Icons.candlestick_chart, size: 16),
        ),
        ButtonSegment<ChartType>(
          value: ChartType.line,
          label: Text('라인'),
          icon: Icon(Icons.show_chart, size: 16),
        ),
        ButtonSegment<ChartType>(
          value: ChartType.area,
          label: Text('영역'),
          icon: Icon(Icons.area_chart, size: 16),
        ),
        ButtonSegment<ChartType>(
          value: ChartType.bar,
          label: Text('바'),
          icon: Icon(Icons.bar_chart, size: 16),
        ),
      ],
      selected: {_chartType},
      onSelectionChanged: (Set<ChartType> selected) {
        if (selected.isNotEmpty) {
          setState(() {
            _chartType = selected.first;
          });
          if (widget.onChartTypeChanged != null) {
            widget.onChartTypeChanged!(_chartType);
          }
        }
      },
    );
  }
  
  /// 시간 프레임 선택기
  Widget _buildTimeFrameSelector() {
    return DropdownButton<TimeFrame>(
      value: _timeFrame,
      isDense: true,
      items: [
        TimeFrame.m1,
        TimeFrame.m5,
        TimeFrame.m15,
        TimeFrame.m30,
        TimeFrame.h1,
        TimeFrame.h4,
        TimeFrame.d1,
        TimeFrame.w1,
        TimeFrame.mo1,
      ].map((TimeFrame value) {
        return DropdownMenuItem<TimeFrame>(
          value: value,
          child: Text(value.label),
        );
      }).toList(),
      onChanged: (TimeFrame? newValue) {
        if (newValue != null) {
          setState(() {
            _timeFrame = newValue;
          });
          if (widget.onTimeFrameChanged != null) {
            widget.onTimeFrameChanged!(_timeFrame);
          }
        }
      },
    );
  }
  
  /// 지표 토글 버튼
  Widget _buildIndicatorToggle() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.analytics, size: 20),
      tooltip: '기술적 지표',
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'toggle',
          child: Text('지표 표시/숨김'),
        ),
        const PopupMenuItem(
          value: 'sma',
          child: Text('이동평균선 (SMA)'),
        ),
        const PopupMenuItem(
          value: 'ema',
          child: Text('지수이동평균선 (EMA)'),
        ),
        const PopupMenuItem(
          value: 'bollinger',
          child: Text('볼린저 밴드'),
        ),
        const PopupMenuItem(
          value: 'rsi',
          child: Text('RSI'),
        ),
        const PopupMenuItem(
          value: 'macd',
          child: Text('MACD'),
        ),
      ],
      onSelected: (String value) {
        if (value == 'toggle') {
          setState(() {
            _showIndicators = !_showIndicators;
          });
        } else {
          // 여기에 지표 선택 로직 구현
        }
      },
    );
  }
  
  /// 차트 구성
  Widget _buildChart() {
    if (_chartType == ChartType.candlestick) {
      return MoleculeCandleChart(
        data: widget.series.data,
        increasingColor: widget.increasingColor,
        decreasingColor: widget.decreasingColor,
        candleWidth: widget.candleWidth,
        candleSpacing: widget.candleSpacing,
        onTap: _handleCandleTap,
      );
    } else {
      // 다른 차트 타입 처리 (라인, 영역, 바 등)
      // 현재는 캔들스틱만 구현되어 있음
      return Center(
        child: Text('${_chartType.toString().split('.').last} 차트 타입은 아직 구현되지 않았습니다.'),
      );
    }
  }
  
  /// 캔들 탭 이벤트 처리
  void _handleCandleTap(CandleData candle) {
    setState(() {
      _selectedCandle = candle;
    });
    
    if (widget.onCandleTap != null) {
      widget.onCandleTap!(candle);
    }
  }
  
  /// 선택된 캔들 정보 표시
  Widget _buildCandleInfo() {
    final candle = _selectedCandle!;
    final increasingCol = widget.increasingColor ?? Colors.green;
    final decreasingCol = widget.decreasingColor ?? Colors.red;
    final color = candle.isIncreasing ? increasingCol : decreasingCol;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem('일자', candle.formattedDate),
          _buildInfoItem('시가', candle.open.toStringAsFixed(2)),
          _buildInfoItem('고가', candle.high.toStringAsFixed(2)),
          _buildInfoItem('저가', candle.low.toStringAsFixed(2)),
          _buildInfoItem(
            '종가', 
            candle.close.toStringAsFixed(2),
            color: color,
          ),
          _buildInfoItem(
            '변동', 
            '${((candle.close / candle.open - 1) * 100).toStringAsFixed(2)}%',
            color: color,
          ),
        ],
      ),
    );
  }
  
  /// 정보 항목 구성
  Widget _buildInfoItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 