import 'package:flutter/material.dart';

/// 캔들스틱 차트에 사용되는 OHLC(Open, High, Low, Close) 데이터 모델
class CandleData {
  /// OHLC 데이터 생성자
  const CandleData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  /// 데이터 시간
  final DateTime date;
  
  /// 시가
  final double open;
  
  /// 고가
  final double high;
  
  /// 저가
  final double low;
  
  /// 종가
  final double close;
  
  /// 거래량
  final double volume;
  
  /// 양봉인지 여부
  bool get isIncreasing => close >= open;
  
  /// 캔들 몸통의 길이
  double get bodyLength => (close - open).abs();
  
  /// 캔들 전체 길이
  double get totalLength => high - low;
  
  /// 캔들 위쪽 그림자 길이
  double get upperShadowLength => isIncreasing ? high - close : high - open;
  
  /// 캔들 아래쪽 그림자 길이
  double get lowerShadowLength => isIncreasing ? open - low : close - low;
  
  /// 거래일 표시 문자열
  String get formattedDate => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  
  /// 거래일 시간 표시 문자열
  String get formattedTime => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  
  /// 시분할 차트용 시간 문자열
  String get timeString => date.hour < 12 ? 
                           '${date.hour == 0 ? 12 : date.hour}:${date.minute.toString().padLeft(2, '0')} AM' : 
                           '${date.hour == 12 ? 12 : date.hour - 12}:${date.minute.toString().padLeft(2, '0')} PM';
}

/// 금융 시계열 데이터 모델
class FinancialSeries {
  /// 금융 시계열 데이터 생성자
  const FinancialSeries({
    required this.name,
    required this.data,
    this.color,
    this.isVisible = true,
    this.thickness = 2.0,
    this.dashPattern,
  });
  
  /// 시리즈 이름
  final String name;
  
  /// 시리즈 데이터
  final List<CandleData> data;
  
  /// 시리즈 색상
  final Color? color;
  
  /// 차트에 표시 여부
  final bool isVisible;
  
  /// 라인 차트의 경우 선 두께
  final double thickness;
  
  /// 라인 차트의 경우 선 패턴
  final List<double>? dashPattern;
  
  /// 최고가
  double get maxHigh => data.isEmpty ? 0 : data.map((d) => d.high).reduce((a, b) => a > b ? a : b);
  
  /// 최저가
  double get minLow => data.isEmpty ? 0 : data.map((d) => d.low).reduce((a, b) => a < b ? a : b);
  
  /// 최대 거래량
  double get maxVolume => data.isEmpty ? 0 : data.map((d) => d.volume).reduce((a, b) => a > b ? a : b);
  
  /// 가격 변동률
  double get changeRate => data.isEmpty ? 0 : (data.last.close / data.first.open - 1) * 100;
  
  /// 볼륨 가중 평균 가격 (VWAP)
  double get vwap {
    if (data.isEmpty) return 0;
    
    double sumPriceVolume = 0;
    double sumVolume = 0;
    
    for (final candle in data) {
      final typicalPrice = (candle.high + candle.low + candle.close) / 3;
      sumPriceVolume += typicalPrice * candle.volume;
      sumVolume += candle.volume;
    }
    
    return sumVolume == 0 ? 0 : sumPriceVolume / sumVolume;
  }
}

/// 기술적 지표 유형
enum IndicatorType {
  /// 단순 이동평균 (Simple Moving Average)
  sma,
  
  /// 지수 이동평균 (Exponential Moving Average)
  ema,
  
  /// 볼린저 밴드 (Bollinger Bands)
  bollinger,
  
  /// 상대강도지수 (Relative Strength Index)
  rsi,
  
  /// 이동평균수렴확산지수 (Moving Average Convergence Divergence)
  macd,
  
  /// 스토캐스틱 (Stochastic)
  stochastic,
}

/// 기술적 지표 데이터 모델
class IndicatorData {
  /// 기술적 지표 데이터 생성자
  const IndicatorData({
    required this.type,
    required this.name,
    required this.values,
    required this.dates,
    this.color,
    this.isVisible = true,
    this.secondaryValues,
    this.secondaryColor,
    this.tertiaryValues,
    this.tertiaryColor,
  });
  
  /// 지표 유형
  final IndicatorType type;
  
  /// 지표 이름
  final String name;
  
  /// 기본 값 리스트
  final List<double> values;
  
  /// 날짜 리스트
  final List<DateTime> dates;
  
  /// 기본 선 색상
  final Color? color;
  
  /// 차트에 표시 여부
  final bool isVisible;
  
  /// 보조 값 리스트 (볼린저 밴드의 상단, MACD 시그널 라인 등)
  final List<double>? secondaryValues;
  
  /// 보조 선 색상
  final Color? secondaryColor;
  
  /// 세 번째 값 리스트 (볼린저 밴드의 하단 등)
  final List<double>? tertiaryValues;
  
  /// 세 번째 선 색상
  final Color? tertiaryColor;
  
  /// 최대값
  double get maxValue {
    double max = values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
    
    if (secondaryValues != null && secondaryValues!.isNotEmpty) {
      final secMax = secondaryValues!.reduce((a, b) => a > b ? a : b);
      max = max > secMax ? max : secMax;
    }
    
    if (tertiaryValues != null && tertiaryValues!.isNotEmpty) {
      final tertMax = tertiaryValues!.reduce((a, b) => a > b ? a : b);
      max = max > tertMax ? max : tertMax;
    }
    
    return max;
  }
  
  /// 최소값
  double get minValue {
    double min = values.isEmpty ? 0 : values.reduce((a, b) => a < b ? a : b);
    
    if (secondaryValues != null && secondaryValues!.isNotEmpty) {
      final secMin = secondaryValues!.reduce((a, b) => a < b ? a : b);
      min = min < secMin ? min : secMin;
    }
    
    if (tertiaryValues != null && tertiaryValues!.isNotEmpty) {
      final tertMin = tertiaryValues!.reduce((a, b) => a < b ? a : b);
      min = min < tertMin ? min : tertMin;
    }
    
    return min;
  }
} 