import 'package:flutter/material.dart';

/// 금융 차트를 위한 유기체 컴포넌트
///
/// 다양한 금융 차트 유형(캔들스틱, 라인, 바 차트 등)과 
/// 부가 기능(거래량, 기술 지표 등)을 조합하여 완전한 금융 차트를 제공합니다.
class OrganismFinancialChart extends StatefulWidget {
  /// 금융 차트 생성자
  const OrganismFinancialChart({
    super.key,
    this.title,
    this.chartType = FinancialChartType.candle,
    this.timeRange = FinancialTimeRange.day,
    this.showVolume = true,
    this.showGridLines = true,
    this.priceData,
    this.volumeData,
    this.onTimeRangeChanged,
    this.onChartTypeChanged,
    this.onDataPointSelected,
  });

  /// 차트 제목
  final String? title;
  
  /// 차트 유형
  final FinancialChartType chartType;
  
  /// 시간 범위
  final FinancialTimeRange timeRange;
  
  /// 거래량 표시 여부
  final bool showVolume;
  
  /// 그리드 라인 표시 여부
  final bool showGridLines;
  
  /// 가격 데이터
  final List<dynamic>? priceData;
  
  /// 거래량 데이터
  final List<double>? volumeData;
  
  /// 시간 범위 변경 핸들러
  final void Function(FinancialTimeRange)? onTimeRangeChanged;
  
  /// 차트 유형 변경 핸들러
  final void Function(FinancialChartType)? onChartTypeChanged;
  
  /// 데이터 포인트 선택 핸들러
  final void Function(int)? onDataPointSelected;

  @override
  State<OrganismFinancialChart> createState() => _OrganismFinancialChartState();
}

/// 금융 차트 상태 관리 클래스
class _OrganismFinancialChartState extends State<OrganismFinancialChart> {
  late FinancialTimeRange _currentTimeRange;
  late FinancialChartType _currentChartType;
  int? _selectedDataIndex;

  @override
  void initState() {
    super.initState();
    _currentTimeRange = widget.timeRange;
    _currentChartType = widget.chartType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 차트 헤더 영역 (제목, 타임프레임 선택, 차트 타입 선택)
        _buildHeader(),
        
        const SizedBox(height: 16),
        
        // 메인 차트 영역
        Expanded(
          flex: 3,
          child: _buildMainChart(),
        ),
        
        // 거래량 차트 영역 (표시 설정된 경우)
        if (widget.showVolume) ...[
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: _buildVolumeChart(),
          ),
        ],
      ],
    );
  }

  /// 차트 헤더 영역 구성
  Widget _buildHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8,
      runSpacing: 8,
      children: [
        // 제목 영역
        if (widget.title != null)
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.titleMedium,
          )
        else
          const SizedBox(),
          
        // 차트 컨트롤 영역
        Wrap(
          spacing: 8,
          children: [
            // 타임프레임 선택 드롭다운
            DropdownButtonHideUnderline(
              child: DropdownButton<FinancialTimeRange>(
                isDense: true,
                value: _currentTimeRange,
                items: FinancialTimeRange.values.map((timeRange) {
                  return DropdownMenuItem<FinancialTimeRange>(
                    value: timeRange,
                    child: Text(
                      timeRange.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentTimeRange = newValue;
                    });
                    if (widget.onTimeRangeChanged != null) {
                      widget.onTimeRangeChanged!(newValue);
                    }
                  }
                },
              ),
            ),
            
            // 차트 유형 선택 드롭다운
            DropdownButtonHideUnderline(
              child: DropdownButton<FinancialChartType>(
                isDense: true,
                value: _currentChartType,
                items: FinancialChartType.values.map((chartType) {
                  return DropdownMenuItem<FinancialChartType>(
                    value: chartType,
                    child: Text(
                      chartType.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentChartType = newValue;
                    });
                    if (widget.onChartTypeChanged != null) {
                      widget.onChartTypeChanged!(newValue);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 메인 차트 영역 구성
  Widget _buildMainChart() {
    // 미리 구현된 차트 대신 단순화된 자리 표시자 사용
    switch (_currentChartType) {
      case FinancialChartType.line:
        return _buildPlaceholderChart('라인 차트', Colors.blue);
      case FinancialChartType.bar:
        return _buildPlaceholderChart('바 차트', Colors.green);
      case FinancialChartType.candle:
      default:
        return _buildPlaceholderChart('캔들스틱 차트', Colors.orange);
    }
  }

  /// 거래량 차트 영역 구성
  Widget _buildVolumeChart() {
    return _buildPlaceholderChart('거래량 차트', Colors.purple);
  }

  /// 차트 자리 표시자 위젯
  Widget _buildPlaceholderChart(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRect(
        child: OverflowBox(
          minHeight: 0,
          maxHeight: double.infinity,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 8),
                Text(
                  '$title - ${_currentTimeRange.label}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                if (widget.showGridLines)
                  Text(
                    '그리드 라인 표시',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 금융 차트 유형
enum FinancialChartType {
  /// 캔들스틱 차트
  candle('캔들스틱'),
  
  /// 라인 차트
  line('라인'),
  
  /// 바 차트
  bar('바');
  
  /// 생성자
  const FinancialChartType(this.label);
  
  /// 표시 레이블
  final String label;
}

/// 금융 차트 시간 범위
enum FinancialTimeRange {
  /// 일봉
  day('1일'),
  
  /// 주봉
  week('1주'),
  
  /// 월봉
  month('1개월'),
  
  /// 연봉
  year('1년');
  
  /// 생성자
  const FinancialTimeRange(this.label);
  
  /// 표시 레이블
  final String label;
} 