import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/pages/page_stock_detail.dart';

void main() {
  goldenTest(
    'PageStockDetail renders correctly with different actor scenarios',
    fileName: 'page_stock_detail',
    // 더 큰 제약 조건 사용
    constraints: const BoxConstraints(maxWidth: 800, maxHeight: 1200),
    builder: () => GoldenTestGroup(
      // 더 큰 제약 조건 사용
      scenarioConstraints: const BoxConstraints(maxWidth: 600, maxHeight: 900),
      children: [
        // 액터: 투자자 (주식 상승 시나리오)
        // 시나리오: 투자자가 상승하는 주식을 보고 매수를 고려하는 상황
        GoldenTestScenario(
          name: '액터: 투자자 - 주식 상승 시나리오',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: PageStockDetail(
              stockSymbol: 'AAPL',
              stockName: '애플',
              stockPrice: 182.63,
              priceChange: 3.24,
              priceChangePercentage: 1.81,
              stockData: [], // 실제 데이터 구현 필요
            ),
          ),
        ),
        
        // 액터: 투자자 (주식 하락 시나리오)
        // 시나리오: 투자자가 하락하는 주식을 보고 매도를 고려하는 상황
        GoldenTestScenario(
          name: '액터: 투자자 - 주식 하락 시나리오',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: PageStockDetail(
              stockSymbol: 'NFLX',
              stockName: '넷플릭스',
              stockPrice: 632.41,
              priceChange: -12.53,
              priceChangePercentage: -1.94,
              stockData: [], // 실제 데이터 구현 필요
            ),
          ),
        ),
        
        // 액터: 분석가 (기술적 분석 시나리오)
        // 시나리오: 분석가가 주식의 기술적 지표를 분석하는 상황
        GoldenTestScenario(
          name: '액터: 분석가 - 기술적 분석 시나리오',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: PageStockDetail(
              stockSymbol: 'TSLA',
              stockName: '테슬라',
              stockPrice: 177.16,
              priceChange: 0.86,
              priceChangePercentage: 0.49,
              stockData: [], // 실제 데이터 구현 필요
            ),
          ),
        ),
        
        // 액터: 관리자 (시스템 모니터링 시나리오)
        // 시나리오: 관리자가 시스템 성능과 사용자 행동을 모니터링하는 상황
        GoldenTestScenario(
          name: '액터: 관리자 - 시스템 모니터링 시나리오',
          child: MaterialApp(
            theme: ThemeData.dark(), // 관리자 모드는 다크 테마 사용
            home: PageStockDetail(
              stockSymbol: 'AMZN',
              stockName: '아마존',
              stockPrice: 183.92,
              priceChange: 1.27,
              priceChangePercentage: 0.70,
              stockData: [], // 실제 데이터 구현 필요
            ),
          ),
        ),
        
        // 액터: 투자 초보자 (시각적 도움말 시나리오)
        // 시나리오: 투자 초보자가 정보를 이해하기 쉽게 도움말이 표시되는 상황
        GoldenTestScenario(
          name: '액터: 투자 초보자 - 시각적 도움말 시나리오',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: PageStockDetail(
                stockSymbol: 'GOOG',
                stockName: '구글',
                stockPrice: 164.25,
                priceChange: 2.18,
                priceChangePercentage: 1.35,
                stockData: [], // 실제 데이터 구현 필요
              ),
              // 실제로는 도움말 모드를 제공하는 플로팅 버튼 등이 추가될 수 있음
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.help_outline),
              ),
            ),
          ),
        ),
      ],
    ),
  );
} 