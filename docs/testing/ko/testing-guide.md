# 테스트 가이드

## 테스트 종류

### 1. 단위 테스트
- 개별 클래스/함수의 동작 검증
- 외부 의존성은 모킹 처리
- `test` 패키지 사용

```dart
void main() {
  group('AssetRepository', () {
    late AssetRepository repository;
    late MockAssetApi mockApi;

    setUp(() {
      mockApi = MockAssetApi();
      repository = AssetRepository(api: mockApi);
    });

    test('getAsset returns asset for valid id', () async {
      // Arrange
      const id = 'test-id';
      final expectedAsset = Asset(id: id, name: 'Test Asset');
      when(mockApi.getAsset(id)).thenAnswer((_) async => expectedAsset);

      // Act
      final result = await repository.getAsset(id);

      // Assert
      expect(result, equals(expectedAsset));
      verify(mockApi.getAsset(id)).called(1);
    });
  });
}
```

### 2. 위젯 테스트
- UI 컴포넌트의 동작 검증
- `flutter_test` 패키지 사용
- 위젯 렌더링 및 상호작용 테스트

```dart
void main() {
  group('AssetListView', () {
    testWidgets('displays assets correctly', (WidgetTester tester) async {
      // Arrange
      final assets = [
        Asset(id: '1', name: 'Asset 1'),
        Asset(id: '2', name: 'Asset 2'),
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: AssetListView(assets: assets),
        ),
      );

      // Assert
      expect(find.text('Asset 1'), findsOneWidget);
      expect(find.text('Asset 2'), findsOneWidget);
    });
  });
}
```

### 3. 통합 테스트
- 여러 컴포넌트 간의 상호작용 검증
- 실제 의존성 사용
- `integration_test` 패키지 사용

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('add asset flow', (WidgetTester tester) async {
      // 앱 시작
      await tester.pumpWidget(const MyApp());

      // 자산 추가 버튼 탭
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // 자산 정보 입력
      await tester.enterText(
        find.byKey(const Key('asset-name-field')),
        'New Asset',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 결과 확인
      expect(find.text('New Asset'), findsOneWidget);
    });
  });
}
```

### 4. 골든 테스트
- UI 레이아웃 및 스타일 검증
- 스크린샷 기반 비교
- 다양한 디바이스/화면 크기 지원

```dart
void main() {
  group('AssetCard Golden Tests', () {
    testWidgets('matches golden file', (WidgetTester tester) async {
      final asset = Asset(id: '1', name: 'Test Asset');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      await expectLater(
        find.byType(AssetCard),
        matchesGoldenFile('asset_card.png'),
      );
    });
  });
}
```

## 테스트 실행

### 전체 테스트 실행
```bash
make test
```

### 특정 테스트 실행
```bash
flutter test test/path/to/test_file.dart
```

### 골든 테스트 업데이트
```bash
flutter test --update-goldens
```

## 테스트 커버리지

### 커버리지 리포트 생성
```bash
flutter test --coverage
```

### 커버리지 리포트 확인
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 모범 사례

### 1. 테스트 구조화
- Arrange, Act, Assert 패턴 사용
- 명확한 테스트 설명 작성
- 테스트 그룹화로 관련 테스트 구성

### 2. 테스트 격리
- 각 테스트는 독립적으로 실행 가능해야 함
- `setUp`과 `tearDown`으로 상태 초기화
- 공유 상태 최소화

### 3. 테스트 가독성
- 설명적인 테스트 이름 사용
- 복잡한 설정은 헬퍼 함수로 추출
- 실패 시 명확한 메시지 제공

### 4. 테스트 유지보수
- 깨지기 쉬운 테스트 피하기
- 구현 세부사항이 아닌 동작 테스트
- 테스트 코드도 리팩토링 대상

## CI/CD 통합

### GitHub Actions 설정
```yaml
name: Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: make test
      - name: Upload coverage
        uses: codecov/codecov-action@v2
        with:
          file: coverage/lcov.info
```

### 품질 게이트
- 테스트 커버리지 최소 80% 유지
- 모든 테스트 통과 필수
- 골든 테스트 불일치 시 실패 