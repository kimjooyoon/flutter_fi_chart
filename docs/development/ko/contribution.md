# 기여 가이드

## 개요

Flutter Financial Chart는 오픈 소스 프로젝트로, 커뮤니티의 기여를 환영합니다. 이 가이드는 프로젝트에 기여하는 방법을 설명합니다.

## 기여 프로세스

### 1. 이슈 생성
- 새로운 기능 제안
- 버그 리포트
- 문서 개선 제안

```markdown
## 기능 제안 템플릿

### 설명
[기능에 대한 상세 설명]

### 필요성
[이 기능이 필요한 이유]

### 구현 방안
[구현 아이디어나 접근 방법]

### 예상 결과
[기능 구현 후 예상되는 결과]
```

### 2. 브랜치 생성
```bash
# 기능 개발
git checkout -b feature/asset-chart

# 버그 수정
git checkout -b bugfix/price-update

# 문서 개선
git checkout -b docs/api-guide
```

### 3. 개발 가이드라인

#### 코드 스타일
```dart
// Good
class AssetRepository {
  final AssetApi _api;
  
  Future<Asset> getAsset(String id) async {
    try {
      return await _api.getAsset(id);
    } catch (e) {
      throw AssetException(e.toString());
    }
  }
}

// Bad
class assetRepository {
  var api;
  
  getAsset(id) {
    try {
      return api.getAsset(id);
    } catch (e) {
      throw e;
    }
  }
}
```

#### 테스트 작성
```dart
void main() {
  group('AssetRepository', () {
    late AssetRepository repository;
    late MockAssetApi mockApi;
    
    setUp(() {
      mockApi = MockAssetApi();
      repository = AssetRepository(mockApi);
    });
    
    test('getAsset returns asset for valid id', () async {
      // Arrange
      const id = 'test-id';
      final expectedAsset = Asset(id: id);
      when(mockApi.getAsset(id))
          .thenAnswer((_) async => expectedAsset);
      
      // Act
      final result = await repository.getAsset(id);
      
      // Assert
      expect(result, equals(expectedAsset));
    });
  });
}
```

### 4. 커밋 메시지
```
<type>(<scope>): <subject>

<body>

<footer>
```

예시:
```
feat(chart): 캔들스틱 차트 구현

- 일봉/주봉/월봉 지원
- 기술적 지표 표시
- 확대/축소 기능

Resolves: #123
```

### 5. Pull Request

#### PR 템플릿
```markdown
## 변경 사항
[변경 사항에 대한 상세 설명]

## 관련 이슈
[관련된 이슈 번호]

## 테스트
- [ ] 단위 테스트
- [ ] 통합 테스트
- [ ] UI 테스트

## 스크린샷
[UI 변경이 있는 경우 스크린샷 첨부]

## 체크리스트
- [ ] 코드 스타일 준수
- [ ] 테스트 코드 작성
- [ ] 문서 업데이트
```

### 6. 코드 리뷰

#### 리뷰어 가이드라인
- 코드 품질 검토
- 테스트 커버리지 확인
- 성능 영향 평가
- 보안 취약점 검토

#### 피드백 예시
```
파일: lib/features/chart/presentation/widgets/candlestick_chart.dart

L45: 성능 개선 제안
- `build` 메서드에서 계산 로직을 분리하여 별도 메서드로 추출
- 불필요한 리빌드 방지를 위해 `const` 생성자 사용 검토

L78: 메모리 누수 가능성
- `StreamSubscription` 해제 로직 추가 필요
- `dispose` 메서드에서 리소스 정리 구현
```

## CI/CD 파이프라인

### 1. 자동화된 검증
```yaml
name: PR Validation

on:
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Install dependencies
        run: flutter pub get
        
      - name: Check formatting
        run: dart format --set-exit-if-changed .
        
      - name: Analyze
        run: flutter analyze
        
      - name: Run tests
        run: flutter test --coverage
```

### 2. 품질 게이트
- 테스트 커버리지 80% 이상
- 정적 분석 경고 없음
- 성능 테스트 통과

## 문서화

### 1. API 문서
```dart
/// 자산 정보를 관리하는 리포지토리
///
/// 로컬 캐시와 원격 API를 통해 자산 데이터를 관리합니다.
/// 오프라인 지원과 자동 동기화 기능을 제공합니다.
class AssetRepository {
  /// 주어진 ID에 해당하는 자산 정보를 조회합니다.
  ///
  /// [id]가 유효하지 않은 경우 [AssetNotFoundException]를 발생시킵니다.
  /// 네트워크 오류 발생 시 캐시된 데이터를 반환합니다.
  Future<Asset> getAsset(String id) async {
    // ...
  }
}
```

### 2. 예제 코드
```dart
// 차트 위젯 사용 예시
class ChartExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CandlestickChart(
      data: priceData,
      options: ChartOptions(
        interval: ChartInterval.day,
        indicators: [
          MovingAverage(period: 20),
          RelativeStrengthIndex(),
        ],
      ),
      onIntervalChanged: (interval) {
        // 간격 변경 처리
      },
    );
  }
}
```

## 릴리스 프로세스

### 1. 버전 관리
```yaml
# pubspec.yaml
name: flutter_fi_chart
version: 1.2.3  # Major.Minor.Patch
```

### 2. 체인지로그
```markdown
# Changelog

## [1.2.3] - 2024-03-15

### 추가
- 캔들스틱 차트 구현
- RSI 지표 추가

### 수정
- 차트 렌더링 성능 개선
- 메모리 누수 수정

### 제거
- 사용하지 않는 레거시 코드 정리
```

## 커뮤니티

### 1. 행동 강령
- 상호 존중
- 건설적인 피드백
- 포용적인 환경

### 2. 커뮤니케이션 채널
- GitHub 이슈
- 디스커션
- 슬랙 채널

## 라이선스

### MIT 라이선스
```
Copyright (c) 2024 Flutter Financial Chart

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
``` 