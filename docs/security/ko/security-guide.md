# 보안 가이드

## 보안 검사

### 1. 의존성 취약점 검사
```bash
make security
```

이 명령은 다음을 수행합니다:
- 알려진 취약점이 있는 패키지 확인
- 사용 중인 패키지의 최신 버전 확인
- 보안 업데이트가 필요한 패키지 식별

### 2. 정적 코드 분석
```bash
make analyze
```

다음 항목을 검사합니다:
- 잠재적인 보안 취약점
- 안전하지 않은 코드 패턴
- 데이터 유출 가능성

## 보안 모범 사례

### 1. 데이터 저장
- 민감한 데이터는 암호화하여 저장
- 키체인/키스토어 활용
- 임시 데이터는 메모리에서만 처리

```dart
// 안전한 데이터 저장 예시
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

### 2. 네트워크 통신
- HTTPS 필수 사용
- 인증서 피닝 구현
- 민감한 데이터 전송 시 추가 암호화

```dart
// 인증서 피닝 예시
class SecureHttpClient {
  Dio _createDioWithCertificatePinning() {
    return Dio()
      ..interceptors.add(
        CertificatePinningInterceptor(
          allowedSHA256Fingerprints: [
            'EXPECTED_CERTIFICATE_HASH',
          ],
        ),
      );
  }
}
```

### 3. 인증 및 권한
- 토큰 기반 인증 사용
- 적절한 권한 검사
- 세션 관리 및 타임아웃 구현

```dart
// 인증 인터셉터 예시
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### 4. 입력 검증
- 모든 사용자 입력 검증
- SQL 인젝션 방지
- XSS 방지

```dart
// 입력 검증 예시
class InputValidator {
  static bool isValidAmount(String amount) {
    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
    return regex.hasMatch(amount);
  }

  static String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>]'), '');
  }
}
```

## 보안 테스트

### 1. 취약점 테스트
```dart
void main() {
  group('Security Tests', () {
    test('should not store sensitive data in plain text', () async {
      final storage = SecureStorage();
      await storage.saveToken('test_token');
      
      // 파일 시스템에서 직접 읽기 시도
      final file = File('path/to/storage');
      final contents = await file.readAsString();
      
      // 평문으로 저장되지 않았는지 확인
      expect(contents.contains('test_token'), isFalse);
    });
  });
}
```

### 2. 권한 테스트
```dart
void main() {
  group('Authorization Tests', () {
    test('should require authentication for protected endpoints', () async {
      final client = HttpClient();
      final response = await client.get('/api/protected');
      
      expect(response.statusCode, equals(401));
    });
  });
}
```

## 보안 모니터링

### 1. 로깅
- 보안 관련 이벤트 로깅
- 접근 시도 기록
- 에러 및 예외 추적

```dart
class SecurityLogger {
  static void logSecurityEvent(String event, {Map<String, dynamic>? details}) {
    log(
      event,
      name: 'Security',
      time: DateTime.now(),
      error: details,
    );
  }
}
```

### 2. 모니터링
- 비정상 패턴 감지
- 접근 시도 횟수 제한
- 실시간 알림 설정

```dart
class SecurityMonitor {
  static const maxAttempts = 5;
  static final _attempts = <String, int>{};

  static bool shouldBlockAccess(String ip) {
    final attempts = _attempts[ip] ?? 0;
    return attempts >= maxAttempts;
  }
}
```

## 보안 업데이트

### 1. 의존성 업데이트
```bash
flutter pub upgrade --major-versions
```

### 2. 보안 패치
- 정기적인 보안 업데이트 적용
- 취약점 패치 즉시 적용
- 변경 사항 테스트 필수

## CI/CD 보안

### 1. 시크릿 관리
- 환경 변수 사용
- 시크릿 관리 서비스 활용
- 하드코딩된 시크릿 방지

```yaml
# GitHub Actions 시크릿 사용 예시
name: Deploy
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: ./deploy.sh
```

### 2. 빌드 보안
- 의존성 검사 자동화
- 코드 스캐닝 통합
- 보안 테스트 자동화

```yaml
# 보안 검사 워크플로우 예시
name: Security Check
on: [pull_request]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Security Scan
        run: |
          make security
          make analyze
``` 