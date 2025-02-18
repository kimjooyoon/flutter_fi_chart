# Clean Architecture

## 개요

Flutter Financial Chart는 Clean Architecture 원칙을 따라 구현되었습니다. 이는 코드의 유지보수성, 테스트 용이성, 그리고 확장성을 보장합니다.

## 계층 구조

### 1. 프레젠테이션 계층 (`lib/presentation/`)
- UI 컴포넌트 및 화면
- BLoC/Provider를 통한 상태 관리
- 사용자 입력 처리
- 데이터 표시

### 2. 도메인 계층 (`lib/domain/`)
- 비즈니스 로직
- 엔티티 정의
- 유스케이스
- 리포지토리 인터페이스

### 3. 데이터 계층 (`lib/data/`)
- 리포지토리 구현
- 데이터 소스 (로컬/원격)
- 모델 정의
- 데이터 매핑

## 의존성 규칙

1. 외부 계층은 내부 계층에 의존할 수 있음
2. 내부 계층은 외부 계층을 알지 못함
3. 모든 의존성은 안쪽을 향해야 함

## 데이터 흐름

1. UI -> Presenter/BLoC
2. Presenter/BLoC -> UseCase
3. UseCase -> Repository
4. Repository -> DataSource

## 테스트 전략

각 계층별 테스트 전략:

1. 프레젠테이션 계층
   - 위젯 테스트
   - BLoC 테스트
   - 통합 테스트

2. 도메인 계층
   - 유스케이스 단위 테스트
   - 엔티티 테스트
   - 도메인 서비스 테스트

3. 데이터 계층
   - 리포지토리 테스트
   - 데이터 소스 테스트
   - 모델 매핑 테스트

## 폴더 구조

```
lib/
├── app/                # 앱 설정 및 라우팅
├── core/              # 공통 유틸리티
├── data/              # 데이터 계층
│   ├── models/        # 데이터 모델
│   ├── repositories/  # 리포지토리 구현
│   └── sources/       # 데이터 소스
├── domain/            # 도메인 계층
│   ├── entities/      # 엔티티
│   ├── repositories/  # 리포지토리 인터페이스
│   └── usecases/      # 유스케이스
└── presentation/      # UI 계층
    ├── screens/       # 화면
    ├── widgets/       # 위젯
    └── blocs/         # 상태 관리
``` 