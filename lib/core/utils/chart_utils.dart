import 'package:flutter/material.dart';
import '../models/financial_data.dart';

/// 차트 관련 유틸리티 함수 모음
class ChartUtils {
  /// 가격 범위에 따른 눈금 간격 계산
  static double calculatePriceInterval(double min, double max) {
    final range = max - min;
    
    if (range <= 0.01) return 0.001;
    if (range <= 0.1) return 0.01;
    if (range <= 1) return 0.1;
    if (range <= 5) return 0.5;
    if (range <= 10) return 1;
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 500) return 50;
    if (range <= 1000) return 100;
    if (range <= 5000) return 500;
    if (range <= 10000) return 1000;
    
    return 5000;
  }
  
  /// 가격 형식화 함수
  static String formatPrice(double price, {int? precision}) {
    if (precision != null) {
      return price.toStringAsFixed(precision);
    }
    
    if (price < 0.01) return price.toStringAsFixed(6);
    if (price < 0.1) return price.toStringAsFixed(4);
    if (price < 1) return price.toStringAsFixed(3);
    if (price < 10) return price.toStringAsFixed(2);
    if (price < 1000) return price.toStringAsFixed(2);
    if (price < 10000) return price.toStringAsFixed(1);
    
    return price.toStringAsFixed(0);
  }
  
  /// 거래량 형식화 함수
  static String formatVolume(double volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(2)}B';
    }
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)}M';
    }
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)}K';
    }
    
    return volume.toStringAsFixed(0);
  }
  
  /// 가격에 대한 색상 반환 (상승, 하락, 보합)
  static Color getPriceColor(
    double price, 
    double referencePrice, 
    Color increasingColor, 
    Color decreasingColor, 
    Color neutralColor,
  ) {
    if (price > referencePrice) {
      return increasingColor;
    } else if (price < referencePrice) {
      return decreasingColor;
    } else {
      return neutralColor;
    }
  }
  
  /// 캔들 색상 가져오기
  static Color getCandleColor(
    CandleData candle, 
    Color increasingColor, 
    Color decreasingColor, 
    {Color? neutralColor}
  ) {
    if (candle.open < candle.close) {
      return increasingColor;
    } else if (candle.open > candle.close) {
      return decreasingColor;
    } else {
      return neutralColor ?? decreasingColor;
    }
  }
  
  /// 가격 변동률(%) 계산
  static String calculateChangePercent(double currentPrice, double previousPrice) {
    if (previousPrice == 0) return '0.00%';
    
    final percent = (currentPrice / previousPrice - 1) * 100;
    final sign = percent > 0 ? '+' : '';
    
    return '$sign${percent.toStringAsFixed(2)}%';
  }
  
  /// 날짜 형식 선택 함수
  static String getDateFormat(List<CandleData> data) {
    if (data.isEmpty) return 'MM-dd';
    
    // 시간 간격 확인
    if (data.length >= 2) {
      final diff = data[1].date.difference(data[0].date).inMinutes;
      
      if (diff <= 5) return 'HH:mm';
      if (diff <= 60) return 'HH:mm';
      if (diff <= 24 * 60) return 'MM-dd HH:mm';
      if (diff <= 7 * 24 * 60) return 'MM-dd';
    }
    
    return 'yyyy-MM-dd';
  }
  
  /// 이동평균선 계산
  static List<double> calculateSMA(List<double> prices, int period) {
    if (prices.isEmpty || period <= 0 || period > prices.length) {
      return [];
    }
    
    final result = <double>[];
    
    for (int i = 0; i < prices.length; i++) {
      if (i < period - 1) {
        result.add(0); // 계산 불가능한 초기 기간
        continue;
      }
      
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += prices[i - j];
      }
      
      result.add(sum / period);
    }
    
    return result;
  }
  
  /// 지수이동평균선 계산
  static List<double> calculateEMA(List<double> prices, int period) {
    if (prices.isEmpty || period <= 0 || period > prices.length) {
      return [];
    }
    
    final result = <double>[];
    final multiplier = 2 / (period + 1);
    
    // 초기 SMA 계산
    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += prices[i];
    }
    
    double ema = sum / period;
    
    // 초기 기간 동안 0 추가
    for (int i = 0; i < period - 1; i++) {
      result.add(0);
    }
    
    result.add(ema);
    
    // 나머지 기간 EMA 계산
    for (int i = period; i < prices.length; i++) {
      ema = (prices[i] - ema) * multiplier + ema;
      result.add(ema);
    }
    
    return result;
  }
  
  /// 볼린저 밴드 계산
  static Map<String, List<double>> calculateBollingerBands(
    List<double> prices, 
    int period, 
    double stdDevMultiplier,
  ) {
    if (prices.isEmpty || period <= 0 || period > prices.length) {
      return {
        'middle': [],
        'upper': [],
        'lower': [],
      };
    }
    
    final middle = calculateSMA(prices, period);
    final upper = <double>[];
    final lower = <double>[];
    
    for (int i = 0; i < prices.length; i++) {
      if (i < period - 1) {
        upper.add(0);
        lower.add(0);
        continue;
      }
      
      // 표준 편차 계산
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += (prices[i - j] - middle[i]) * (prices[i - j] - middle[i]);
      }
      
      final stdDev = (sum / period).sqrt();
      
      upper.add(middle[i] + stdDev * stdDevMultiplier);
      lower.add(middle[i] - stdDev * stdDevMultiplier);
    }
    
    return {
      'middle': middle,
      'upper': upper,
      'lower': lower,
    };
  }
  
  /// 상대강도지수(RSI) 계산
  static List<double> calculateRSI(List<double> prices, int period) {
    if (prices.isEmpty || period <= 0 || period >= prices.length) {
      return [];
    }
    
    final result = <double>[];
    final gains = <double>[];
    final losses = <double>[];
    
    // 초기 gains, losses 계산
    for (int i = 1; i < prices.length; i++) {
      final diff = prices[i] - prices[i - 1];
      
      if (diff >= 0) {
        gains.add(diff);
        losses.add(0);
      } else {
        gains.add(0);
        losses.add(-diff);
      }
    }
    
    // 초기 기간 동안 0 추가
    for (int i = 0; i < period; i++) {
      result.add(0);
    }
    
    double avgGain = 0;
    double avgLoss = 0;
    
    // 첫 번째 평균 이득/손실 계산
    for (int i = 0; i < period; i++) {
      avgGain += gains[i];
      avgLoss += losses[i];
    }
    
    avgGain /= period;
    avgLoss /= period;
    
    // 첫 번째 RSI 계산
    double rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
    double rsi = 100 - (100 / (1 + rs));
    result[period - 1] = rsi;
    
    // 나머지 기간 RSI 계산
    for (int i = period; i < gains.length; i++) {
      avgGain = ((avgGain * (period - 1)) + gains[i]) / period;
      avgLoss = ((avgLoss * (period - 1)) + losses[i]) / period;
      
      rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
      rsi = 100 - (100 / (1 + rs));
      
      result.add(rsi);
    }
    
    return result;
  }
}

/// double 확장 메서드
extension DoubleExtension on double {
  /// 제곱근 계산
  double sqrt() {
    if (this <= 0) return 0;
    
    double x = this;
    double y = 1;
    double e = 0.00001; // 오차 허용치
    
    while (x - y > e) {
      x = (x + y) / 2;
      y = this / x;
    }
    
    return x;
  }
} 