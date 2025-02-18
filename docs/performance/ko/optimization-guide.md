# 성능 최적화 가이드

## 개요

Flutter Financial Chart의 성능 최적화 가이드는 앱의 반응성, 메모리 사용량, 배터리 효율성을 개선하기 위한 지침을 제공합니다.

## 렌더링 최적화

### 1. 위젯 리빌드 최소화
```dart
// Bad
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(price.toString()),
        Text(DateTime.now().toString()), // 매 빌드마다 새로운 값
      ],
    );
  }
}

// Good
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(price.toString()),
        const TimeDisplay(), // 별도 위젯으로 분리
      ],
    );
  }
}
```

### 2. const 생성자 활용
```dart
// Bad
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Icon(Icons.trending_up),
  );
}

// Good
Widget build(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Icon(Icons.trending_up),
  );
}
```

### 3. 리스트 최적화
```dart
class AssetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // 화면에 보이는 항목만 렌더링
      itemCount: assets.length,
      itemBuilder: (context, index) {
        return RepaintBoundary( // 개별 항목의 리페인트 격리
          child: AssetCard(
            key: ValueKey(assets[index].id), // 적절한 키 사용
            asset: assets[index],
          ),
        );
      },
    );
  }
}
```

## 메모리 관리

### 1. 이미지 최적화
```dart
// 이미지 캐싱
final imageCache = PaintingBinding.instance.imageCache;
imageCache.maximumSize = 100; // 캐시 크기 제한
imageCache.maximumSizeBytes = 50 << 20; // 50MB

// 이미지 사이즈 최적화
Image.network(
  url,
  cacheWidth: 300, // 표시 크기에 맞는 해상도로 다운로드
  cacheHeight: 300,
)
```

### 2. 메모리 누수 방지
```dart
class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = priceStream.listen(_updatePrice);
  }

  @override
  void dispose() {
    _subscription.cancel(); // 구독 해제
    super.dispose();
  }
}
```

### 3. 큰 객체 관리
```dart
class DataCache {
  static final _instance = DataCache._();
  final _cache = <String, WeakReference<dynamic>>{};

  void store(String key, dynamic data) {
    _cache[key] = WeakReference(data);
  }

  T? retrieve<T>(String key) {
    final ref = _cache[key]?.target as T?;
    if (ref == null) {
      _cache.remove(key);
    }
    return ref;
  }
}
```

## 네트워크 최적화

### 1. 데이터 프리페칭
```dart
class AssetListScreen extends StatefulWidget {
  @override
  _AssetListScreenState createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 500) {
      // 스크롤이 하단에 가까워지면 다음 페이지 프리페치
      context.read<AssetBloc>().add(PreFetchNextPage());
    }
  }
}
```

### 2. 이미지 프리로딩
```dart
class ImagePreloader {
  static Future<void> preloadImages(BuildContext context) async {
    final assets = ['chart_bg.png', 'logo.png'];
    for (final asset in assets) {
      await precacheImage(
        AssetImage('assets/images/$asset'),
        context,
      );
    }
  }
}
```

## 애니메이션 최적화

### 1. 효율적인 애니메이션
```dart
class OptimizedAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child, // child는 재사용됨
        );
      },
      child: const ExpensiveWidget(), // 애니메이션 중 재빌드되지 않음
    );
  }
}
```

### 2. 하드웨어 가속
```dart
class OptimizedChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ChartPainter(),
        isComplex: true, // 복잡한 그래픽은 별도 레이어로 처리
      ),
    );
  }
}
```

## 프로파일링

### 1. 성능 측정
```dart
class PerformanceMonitor {
  static void measureBuildTime(String widgetName, VoidCallback build) {
    final stopwatch = Stopwatch()..start();
    build();
    print('$widgetName build time: ${stopwatch.elapsedMilliseconds}ms');
  }

  static void trackMemory(String operation) {
    final usage = ProcessInfo.currentRss;
    print('Memory usage after $operation: ${usage ~/ 1024 ~/ 1024}MB');
  }
}
```

### 2. 디버그 플래그
```dart
class DebugConfig {
  static const enablePerformanceOverlay = false;
  static const showSemanticsDebugger = false;
  static const debugShowMaterialGrid = false;

  static void initialize() {
    if (kDebugMode) {
      debugPrintRebuildDirtyWidgets = true;
      debugPrintLayouts = true;
    }
  }
}
```

## CI/CD 통합

### 1. 성능 테스트 자동화
```yaml
name: Performance Tests

on:
  pull_request:
    branches: [ main ]

jobs:
  performance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Run Performance Tests
        run: flutter test --tags=performance
        
      - name: Check Memory Usage
        run: flutter run --profile --dart-define=MEASURE_MEMORY=true
```

### 2. 성능 메트릭스 수집
```dart
class PerformanceMetrics {
  static final _buildTimes = <String, List<int>>{};
  
  static void recordBuildTime(String widget, int milliseconds) {
    _buildTimes.putIfAbsent(widget, () => []).add(milliseconds);
  }
  
  static Map<String, double> getAverageBuildTimes() {
    return _buildTimes.map((key, times) {
      final avg = times.reduce((a, b) => a + b) / times.length;
      return MapEntry(key, avg);
    });
  }
}
``` 