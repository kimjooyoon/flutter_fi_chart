import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/services/financial_data_service.dart';
import 'core/models/financial_data.dart';
import 'presentation/atomic/organisms/financial_chart.dart';
import 'presentation/atomic/pages/page_stock_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금융 차트 앱',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: '금융 차트 데모'),
      // 한글 텍스트 확인을 위한 스탁 디테일 페이지 주석 처리
      // home: const PageStockDetail(
      //   stockSymbol: 'AAPL',
      //   stockName: '애플',
      //   stockPrice: 182.63,
      //   priceChange: 3.24,
      //   priceChangePercentage: 1.81,
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 금융 데이터 서비스 인스턴스
  final _dataService = FinancialDataService();

  // 차트 데이터
  late FinancialSeries _stockSeries;
  late FinancialSeries _cryptoSeries;
  late List<IndicatorData> _indicators;

  // 현재 표시할 데이터 시리즈
  late FinancialSeries _currentSeries;

  @override
  void initState() {
    super.initState();
    // 샘플 데이터 생성
    _stockSeries = _dataService.generateSampleData(
      name: 'AAPL',
      dataPoints: 120,
      startPrice: 180.0,
      trend: 0.0002,
    );

    _cryptoSeries = _dataService.generateSampleData(
      name: 'BTC/USD',
      dataPoints: 100,
      startPrice: 42000.0,
      volatility: 0.03,
      trend: -0.0001,
    );

    _currentSeries = _stockSeries;

    // 기술적 지표 생성
    _indicators = [
      _dataService.createMovingAverage(
        series: _currentSeries,
        period: 20,
        type: IndicatorType.sma,
        color: Colors.blue,
      ),
      _dataService.createMovingAverage(
        series: _currentSeries,
        period: 50,
        type: IndicatorType.sma,
        color: Colors.orange,
      ),
    ];
  }

  // 시리즈 전환
  void _toggleSeries() {
    setState(() {
      if (_currentSeries == _stockSeries) {
        _currentSeries = _cryptoSeries;
      } else {
        _currentSeries = _stockSeries;
      }

      // 시리즈 변경 시 지표도 업데이트
      _indicators = [
        _dataService.createMovingAverage(
          series: _currentSeries,
          period: 20,
          type: IndicatorType.sma,
          color: Colors.blue,
        ),
        _dataService.createMovingAverage(
          series: _currentSeries,
          period: 50,
          type: IndicatorType.sma,
          color: Colors.orange,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: _toggleSeries,
            child: Text(
              _currentSeries == _stockSeries ? 'BTC/USD로 전환' : 'AAPL로 전환',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: OrganismFinancialChart(
                series: _currentSeries,
                indicators: _indicators,
                title: _currentSeries.name,
                showToolbar: true,
                showTitleBar: true,
                // 차트 설정
                increasingColor: Colors.green.shade700,
                decreasingColor: Colors.red.shade700,
                candleWidth: 10,
                candleSpacing: 4,
                onTimeFrameChanged: (timeFrame) {
                  // 시간 프레임 변경 처리
                  print('시간 프레임 변경: ${timeFrame.label}');
                },
                onChartTypeChanged: (chartType) {
                  // 차트 유형 변경 처리
                  print('차트 유형 변경: ${chartType.toString().split('.').last}');
                },
                onCandleTap: (candle) {
                  // 캔들 탭 처리
                  print('캔들 선택: ${candle.formattedDate} 종가: ${candle.close}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
