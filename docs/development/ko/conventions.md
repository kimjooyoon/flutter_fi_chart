# 개발 컨벤션

## 코드 스타일

### 린트 규칙
- `very_good_analysis` 패키지의 린트 규칙을 따릅니다.
- 추가적인 커스텀 린트 규칙은 `analysis_options.yaml`에 정의되어 있습니다.

### 네이밍 컨벤션
1. 클래스/enum: `PascalCase`
   ```dart
   class UserRepository {}
   enum AssetType {}
   ```

2. 변수/메서드: `camelCase`
   ```dart
   final userName = 'John';
   void getUserData() {}
   ```

3. 상수: `SCREAMING_SNAKE_CASE`
   ```dart
   const int MAX_RETRY_COUNT = 3;
   ```

4. 프라이빗 멤버: `_`로 시작
   ```dart
   final _cache = <String, dynamic>{};
   void _initialize() {}
   ```

### 파일 네이밍
1. 소스 파일: `snake_case.dart`
   ```
   user_repository.dart
   home_screen.dart
   ```

2. 테스트 파일: `{source_file}_test.dart`
   ```
   user_repository_test.dart
   home_screen_test.dart
   ```

## 코드 구조

### 파일 구조
```dart
// 1. 라이브러리 선언 (필요한 경우)
library user_repository;

// 2. 임포트 (dart, flutter, 패키지, 프로젝트)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

// 3. 파트 선언 (필요한 경우)
part 'user_repository_impl.dart';

// 4. 타입 선언
class UserRepository {
  // 5. 상수/static 멤버
  static const int timeout = 5000;
  
  // 6. 인스턴스 변수
  final _client = HttpClient();
  
  // 7. 생성자
  UserRepository();
  
  // 8. 메서드
  Future<User> getUser(String id) async {
    // ...
  }
}
```

## 테스트 컨벤션

### 테스트 구조
```dart
void main() {
  group('UserRepository', () {
    late UserRepository repository;
    
    setUp(() {
      repository = UserRepository();
    });
    
    tearDown(() {
      repository.dispose();
    });
    
    test('getUser returns user for valid id', () async {
      // Arrange
      const id = 'test-id';
      
      // Act
      final user = await repository.getUser(id);
      
      // Assert
      expect(user.id, equals(id));
    });
  });
}
```

### 테스트 네이밍
- 설명적이고 명확한 이름 사용
- 테스트 시나리오와 예상 결과를 포함
```dart
'should return cached data when network is offline'
'should throw exception when user is not found'
```

## 문서화

### 클래스/메서드 문서
```dart
/// 사용자 정보를 관리하는 리포지토리
///
/// 로컬 캐시와 원격 API를 통해 사용자 데이터를 관리합니다.
class UserRepository {
  /// 주어진 ID에 해당하는 사용자 정보를 조회합니다.
  ///
  /// [id]가 유효하지 않은 경우 [UserNotFoundException]를 발생시킵니다.
  /// 네트워크 오류 발생 시 캐시된 데이터를 반환합니다.
  Future<User> getUser(String id) async {
    // ...
  }
}
```

## 커밋 메시지

### 포맷
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 타입
- feat: 새로운 기능
- fix: 버그 수정
- docs: 문서 변경
- style: 코드 포맷팅
- refactor: 코드 리팩토링
- test: 테스트 코드
- chore: 빌드, 패키지 매니저 설정

### 예시
```
feat(auth): 소셜 로그인 기능 추가

- Google 로그인 구현
- Apple 로그인 구현
- 로그인 상태 관리 추가

Resolves: #123
```

## 품질 관리

### 필수 검증 단계
1. 린트 검사
   ```bash
   make lint
   ```

2. 테스트 실행
   ```bash
   make test
   ```

3. 정적 분석
   ```bash
   make analyze
   ```

4. 보안 검사
   ```bash
   make security
   ```

### 선택적 검증 단계
1. 의존성 검사
   ```bash
   make deps
   ```

2. 코드 포맷팅
   ```bash
   make format
   ```

### CI/CD 파이프라인
모든 PR은 다음 단계를 통과해야 합니다:
1. 코드 포맷팅 검사
2. 린트 검사
3. 정적 분석
4. 단위 테스트
5. 통합 테스트
6. 보안 검사 