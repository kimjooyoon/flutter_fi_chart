import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/financial_data.dart';
import '../utils/chart_utils.dart';

/// 금융 데이터 서비스
///
/// 차트에 표시할 금융 데이터를 생성하고 관리하는 서비스입니다.
class FinancialDataService {
  /// 단일 인스턴스
  static final FinancialDataService _instance = FinancialDataService._internal();
  
  /// 팩토리 생성자
  factory FinancialDataService() => _instance;
  
  /// 내부 생성자
  FinancialDataService._internal();
  
  /// 시계열 데이터 캐시
  final Map<String, FinancialSeries> _seriesCache = {};
  
  /// 저장된 시리즈 가져오기
  FinancialSeries? getSeries(String name) => _seriesCache[name];
  
  /// 시리즈 저장하기
  void saveSeries(FinancialSeries series) {
    _seriesCache[series.name] = series;
  }
  
  /// 시리즈 삭제하기
  void removeSeries(String name) {
    _seriesCache.remove(name);
  }
  
  /// 모든 시리즈 삭제하기
  void clearAllSeries() {
    _seriesCache.clear();
  }
  
  /// 샘플 데이터 생성
  FinancialSeries generateSampleData({
    String name = 'SAMPLE',
    int dataPoints = 100,
    double startPrice = 100.0,
    double volatility = 0.02,
    double trend = 0.0001,
    double volumeBase = 1000000,
    Color? color,
  }) {
    final data = <CandleData>[];
    final random = math.Random();
    
    double price = startPrice;
    final now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    
    // 주말 건너뛰기
    if (currentDate.weekday == DateTime.saturday) {
      currentDate = currentDate.subtract(const Duration(days: 1));
    } else if (currentDate.weekday == DateTime.sunday) {
      currentDate = currentDate.subtract(const Duration(days: 2));
    }
    
    for (int i = 0; i < dataPoints; i++) {
      // 이전 날짜로 이동 (주말 건너뛰기)
      if (i > 0) {
        currentDate = currentDate.subtract(const Duration(days: 1));
        while (currentDate.weekday == DateTime.saturday || 
               currentDate.weekday == DateTime.sunday) {
          currentDate = currentDate.subtract(const Duration(days: 1));
        }
      }
      
      // 가격 변동성 계산
      final change = price * (random.nextDouble() * 2 - 1) * volatility;
      final dailyTrend = price * trend;
      
      // OHLC 값 계산
      final open = price;
      final close = price + change + dailyTrend;
      
      final maxChange = math.max(open, close) * volatility * 0.5;
      final minChange = math.min(open, close) * volatility * 0.5;
      
      final high = math.max(open, close) + maxChange * random.nextDouble();
      final low = math.min(open, close) - minChange * random.nextDouble();
      
      // 거래량 계산 (랜덤 + 가격 변동에 비례)
      final volumeChange = (change.abs() / price) * volumeBase;
      final volume = volumeBase + volumeChange + (random.nextDouble() * volumeBase * 0.5);
      
      // 캔들 데이터 추가
      data.add(CandleData(
        date: currentDate,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));
      
      // 다음 날 시가 설정
      price = close;
    }
    
    // 최근 날짜가 먼저 오도록 정렬
    //data.sort((a, b) => a.date.compareTo(b.date));
    
    // 데이터 시리즈 생성
    final series = FinancialSeries(
      name: name,
      data: data,
      color: color,
    );
    
    // 캐시에 저장
    _seriesCache[name] = series;
    
    return series;
  }
  
  /// 이동평균선 지표 생성
  IndicatorData createMovingAverage({
    required FinancialSeries series,
    required int period,
    required IndicatorType type,
    Color? color,
    String? name,
  }) {
    final prices = series.data.map((e) => e.close).toList();
    final dates = series.data.map((e) => e.date).toList();
    
    List<double> maValues;
    
    if (type == IndicatorType.sma) {
      maValues = ChartUtils.calculateSMA(prices, period);
      name ??= 'SMA($period)';
    } else {
      maValues = ChartUtils.calculateEMA(prices, period);
      name ??= 'EMA($period)';
    }
    
    return IndicatorData(
      type: type,
      name: name,
      values: maValues,
      dates: dates,
      color: color ?? Colors.blue,
    );
  }
  
  /// 볼린저 밴드 지표 생성
  IndicatorData createBollingerBands({
    required FinancialSeries series,
    int period = 20,
    double stdDev = 2.0,
    Color? middleColor,
    Color? upperColor,
    Color? lowerColor,
    String? name,
  }) {
    final prices = series.data.map((e) => e.close).toList();
    final dates = series.data.map((e) => e.date).toList();
    
    final result = ChartUtils.calculateBollingerBands(prices, period, stdDev);
    
    return IndicatorData(
      type: IndicatorType.bollinger,
      name: name ?? 'BB($period, $stdDev)',
      values: result['middle']!,
      dates: dates,
      color: middleColor ?? Colors.purple,
      secondaryValues: result['upper'],
      secondaryColor: upperColor ?? Colors.red.withOpacity(0.7),
      tertiaryValues: result['lower'],
      tertiaryColor: lowerColor ?? Colors.green.withOpacity(0.7),
    );
  }
  
  /// RSI 지표 생성
  IndicatorData createRSI({
    required FinancialSeries series,
    int period = 14,
    Color? color,
    String? name,
  }) {
    final prices = series.data.map((e) => e.close).toList();
    final dates = series.data.map((e) => e.date).toList();
    
    final rsiValues = ChartUtils.calculateRSI(prices, period);
    
    return IndicatorData(
      type: IndicatorType.rsi,
      name: name ?? 'RSI($period)',
      values: rsiValues,
      dates: dates,
      color: color ?? Colors.orange,
    );
  }
} 