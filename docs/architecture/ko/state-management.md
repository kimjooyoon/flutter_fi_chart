# 상태 관리 전략

## 개요

Flutter Financial Chart는 BLoC 패턴을 주요 상태 관리 솔루션으로 사용하며, 필요에 따라 Provider와 Riverpod를 보조적으로 활용합니다.

## BLoC (Business Logic Component)

### 1. 기본 구조
```dart
// Event
abstract class AssetEvent {}
class LoadAssets extends AssetEvent {}
class UpdateAsset extends AssetEvent {
  final Asset asset;
  UpdateAsset(this.asset);
}

// State
abstract class AssetState {}
class AssetInitial extends AssetState {}
class AssetLoading extends AssetState {}
class AssetLoaded extends AssetState {
  final List<Asset> assets;
  AssetLoaded(this.assets);
}

// BLoC
class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepository repository;
  
  AssetBloc(this.repository) : super(AssetInitial()) {
    on<LoadAssets>(_onLoadAssets);
    on<UpdateAsset>(_onUpdateAsset);
  }
  
  Future<void> _onLoadAssets(
    LoadAssets event,
    Emitter<AssetState> emit,
  ) async {
    emit(AssetLoading());
    try {
      final assets = await repository.getAssets();
      emit(AssetLoaded(assets));
    } catch (e) {
      emit(AssetError(e.toString()));
    }
  }
}
```

### 2. 의존성 주입
```dart
void main() {
  final container = GetIt.instance;
  
  // 리포지토리 등록
  container.registerSingleton<AssetRepository>(
    AssetRepositoryImpl(),
  );
  
  // BLoC 등록
  container.registerFactory<AssetBloc>(
    () => AssetBloc(container.get<AssetRepository>()),
  );
  
  runApp(const MyApp());
}
```

### 3. UI 통합
```dart
class AssetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AssetBloc>()..add(LoadAssets()),
      child: BlocBuilder<AssetBloc, AssetState>(
        builder: (context, state) {
          if (state is AssetLoading) {
            return const CircularProgressIndicator();
          }
          if (state is AssetLoaded) {
            return ListView.builder(
              itemCount: state.assets.length,
              itemBuilder: (context, index) {
                return AssetCard(asset: state.assets[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
```

## Provider

### 1. 단순 상태 관리
```dart
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
```

### 2. 의존성 주입
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 3. 상태 접근
```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Switch(
          value: themeProvider.isDarkMode,
          onChanged: (_) => themeProvider.toggleTheme(),
        );
      },
    );
  }
}
```

## Riverpod

### 1. 프로바이더 정의
```dart
final marketDataProvider = StreamProvider.autoDispose((ref) {
  return MarketDataService().getPriceStream();
});

final filteredAssetsProvider = Provider<List<Asset>>((ref) {
  final assets = ref.watch(assetsProvider);
  final filter = ref.watch(filterProvider);
  
  return assets.where((asset) => 
    asset.type == filter.type &&
    asset.value >= filter.minValue
  ).toList();
});
```

### 2. 상태 소비
```dart
class MarketView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketData = ref.watch(marketDataProvider);
    
    return marketData.when(
      data: (data) => MarketChart(data: data),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorView(message: error.toString()),
    );
  }
}
```

## 상태 관리 가이드라인

### 1. BLoC 사용
- 복잡한 비즈니스 로직
- 비동기 작업이 많은 경우
- 여러 화면에서 공유되는 상태

### 2. Provider 사용
- 단순한 상태 관리
- 테마, 로케일 등 앱 전역 설정
- UI 관련 상태

### 3. Riverpod 사용
- 실시간 데이터 처리
- 복잡한 상태 의존성
- 테스트 용이성 필요

## 테스트

### 1. BLoC 테스트
```dart
void main() {
  group('AssetBloc', () {
    late AssetBloc bloc;
    late MockAssetRepository repository;
    
    setUp(() {
      repository = MockAssetRepository();
      bloc = AssetBloc(repository);
    });
    
    blocTest<AssetBloc, AssetState>(
      'emits [Loading, Loaded] when LoadAssets is added',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadAssets()),
      expect: () => [
        isA<AssetLoading>(),
        isA<AssetLoaded>(),
      ],
    );
  });
}
```

### 2. Provider 테스트
```dart
void main() {
  group('ThemeProvider', () {
    test('toggleTheme changes theme mode', () {
      final provider = ThemeProvider();
      expect(provider.isDarkMode, isFalse);
      
      provider.toggleTheme();
      expect(provider.isDarkMode, isTrue);
    });
  });
}
```

### 3. Riverpod 테스트
```dart
void main() {
  test('filteredAssetsProvider filters assets correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    
    container.read(filterProvider.notifier).state = Filter(
      type: AssetType.stock,
      minValue: 1000,
    );
    
    final filtered = container.read(filteredAssetsProvider);
    expect(filtered, hasLength(greaterThan(0)));
  });
}
```

## 성능 최적화

### 1. 상태 분리
- 독립적인 상태는 별도 관리
- 불필요한 리빌드 방지
- 메모리 효율성 고려

### 2. 캐싱 전략
- 자주 사용되는 데이터 캐싱
- 네트워크 요청 최소화
- 사용자 경험 개선

### 3. 메모리 관리
- 자동 디스포즈 활용
- 리소스 누수 방지
- 주기적인 상태 정리 