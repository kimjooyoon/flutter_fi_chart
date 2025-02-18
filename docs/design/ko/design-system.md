# 디자인 시스템

## 개요

Flutter Financial Chart의 디자인 시스템은 일관된 사용자 경험을 제공하기 위한 기반입니다. Material Design 3을 기반으로 하며, 금융 애플리케이션에 특화된 컴포넌트와 스타일을 제공합니다.

## 아토믹 디자인

### 1. Atoms
- 버튼, 입력 필드, 아이콘 등 기본 UI 요소
- 독립적으로 존재할 수 있는 최소 단위
- 재사용성 극대화

### 2. Molecules
- Atoms의 조합으로 구성
- 검색 폼, 카드 헤더 등
- 단일 책임 원칙 준수

### 3. Organisms
- Molecules의 조합
- 차트 위젯, 거래 폼 등
- 특정 컨텍스트에서 동작

### 4. Templates
- 페이지 레이아웃
- 화면 구조 정의
- 실제 콘텐츠 제외

### 5. Pages
- 실제 콘텐츠가 적용된 화면
- 최종 사용자가 보는 UI
- 비즈니스 로직 통합

## 컬러 시스템

### 1. 브랜드 컬러
```dart
static const primaryColor = Color(0xFF2196F3);
static const secondaryColor = Color(0xFF1565C0);
static const accentColor = Color(0xFF00BCD4);
```

### 2. 시맨틱 컬러
```dart
static const successColor = Color(0xFF4CAF50);
static const warningColor = Color(0xFFFFC107);
static const errorColor = Color(0xFFF44336);
static const infoColor = Color(0xFF2196F3);
```

### 3. 중립 컬러
```dart
static const backgroundColor = Color(0xFFFFFFFF);
static const surfaceColor = Color(0xFFF5F5F5);
static const textPrimaryColor = Color(0xFF212121);
static const textSecondaryColor = Color(0xFF757575);
```

## 타이포그래피

### 1. 텍스트 스타일
```dart
static const TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    letterSpacing: 0.5,
  ),
  labelMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
);
```

### 2. 폰트 계층
- Display: 큰 제목, 배너
- Headline: 섹션 제목
- Body: 본문 텍스트
- Label: 버튼, 입력 필드

## 컴포넌트

### 1. 버튼
```dart
// Primary Button
AppButton(
  label: '매수',
  onPressed: () {},
  style: AppButtonStyle.primary,
)

// Secondary Button
AppButton(
  label: '취소',
  onPressed: () {},
  style: AppButtonStyle.secondary,
)
```

### 2. 입력 필드
```dart
AppTextField(
  label: '금액',
  keyboardType: TextInputType.number,
  prefix: Text('₩'),
  validator: (value) => validateAmount(value),
)
```

### 3. 차트
```dart
AssetChart(
  data: priceData,
  type: ChartType.candlestick,
  timeRange: TimeRange.oneDay,
)
```

## 반응형 디자인

### 1. 브레이크포인트
```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}
```

### 2. 레이아웃 그리드
```dart
class LayoutGrid {
  static const double gutterMobile = 16;
  static const double gutterTablet = 24;
  static const double gutterDesktop = 32;
  
  static const int columnsMobile = 4;
  static const int columnsTablet = 8;
  static const int columnsDesktop = 12;
}
```

## 애니메이션

### 1. 지속 시간
```dart
class AnimationDuration {
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const long = Duration(milliseconds: 500);
}
```

### 2. 이징 커브
```dart
class AnimationCurves {
  static const standard = Curves.easeInOut;
  static const accelerate = Curves.easeIn;
  static const decelerate = Curves.easeOut;
}
```

## 접근성

### 1. 색상 대비
- WCAG 2.1 AA 기준 준수
- 텍스트 최소 대비율 4.5:1
- 큰 텍스트 최소 대비율 3:1

### 2. 터치 타겟
- 최소 크기 48x48dp
- 터치 영역 간 최소 간격 8dp

### 3. 스크린 리더
- 모든 이미지에 대체 텍스트 제공
- 의미 있는 요소에 시맨틱 레이블 지정
- 논리적인 포커스 순서 보장

## 테마 시스템

### 1. 라이트 테마
```dart
final lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    // ...
  ),
  // ...
);
```

### 2. 다크 테마
```dart
final darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    // ...
  ),
  // ...
);
```

## 아이콘 시스템

### 1. 아이콘 세트
```dart
class AppIcons {
  static const IconData trade = Icons.swap_horiz;
  static const IconData portfolio = Icons.pie_chart;
  static const IconData settings = Icons.settings;
}
```

### 2. 아이콘 크기
```dart
class IconSizes {
  static const double small = 16;
  static const double medium = 24;
  static const double large = 32;
}
```

## 사용자 경험 가이드라인

### 1. 로딩 상태
- 스켈레톤 로더 사용
- 진행 상태 표시
- 적절한 피드백 제공

### 2. 에러 처리
- 명확한 에러 메시지
- 복구 액션 제공
- 사용자 친화적 안내

### 3. 성공 피드백
- 시각적 피드백
- 애니메이션 효과
- 확인 메시지 