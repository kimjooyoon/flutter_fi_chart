.PHONY: all clean test lint format analyze security deps build-dev build-prod coverage performance golden-test check-atomic

# 모든 검증을 실행
all: deps format lint analyze check-atomic test

# 의존성 설치
deps:
	@echo "Installing dependencies..."
	@flutter pub get

# 코드 포맷팅
format:
	@echo "Formatting code..."
	@dart format lib test
	@dart format --set-exit-if-changed lib test

# 린트 검사
lint:
	@echo "Running linter..."
	@flutter analyze --no-fatal-infos

# 정적 분석
analyze:
	@echo "Running static analysis..."
	@flutter analyze --fatal-infos --fatal-warnings

# Atomic Design 검사
check-atomic:
	@echo "Checking atomic design conventions..."
	@dart run scripts/check_atomic_naming.dart

# 테스트 실행
test:
	@echo "Running tests..."
	@flutter test --coverage --exclude-tags=performance,golden

# 커버리지 리포트 생성 (선택적)
coverage: test
	@echo "Generating coverage report..."
	@if command -v genhtml >/dev/null 2>&1; then \
		genhtml coverage/lcov.info -o coverage/html && \
		echo "Coverage report generated at coverage/html/index.html"; \
	else \
		echo "Warning: genhtml not found. Install lcov for HTML coverage reports"; \
		echo "Coverage data available in coverage/lcov.info"; \
	fi

# 성능 테스트
performance:
	@echo "Running performance tests..."
	@flutter test --tags=performance
	@flutter run --profile --dart-define=MEASURE_MEMORY=true

# 골든 테스트
golden-test:
	@echo "Running golden tests..."
	@flutter test --tags=golden --update-goldens

# 보안 검사
security:
	@echo "Checking dependencies for security issues..."
	@flutter pub outdated
	@flutter pub deps
	@flutter analyze --fatal-warnings

# 개발용 빌드
build-dev:
	@echo "Building development version..."
	@flutter build apk --debug
	@flutter build ios --debug --no-codesign

# 프로덕션 빌드
build-prod:
	@echo "Building production version..."
	@flutter build apk --release
	@flutter build ios --release --no-codesign

# 클린
clean:
	@echo "Cleaning..."
	@flutter clean
	@rm -rf coverage/
	@rm -rf build/
	@rm -rf .dart_tool/
	@rm -rf ios/Pods/
	@rm -rf android/.gradle/

# 에러 처리를 위한 함수
define check_exit
	@if [ $$? -ne 0 ]; then \
		echo "Error: $1 failed"; \
		exit 1; \
	fi
endef

# 의존성 체크
check-environment:
	@flutter doctor
	$(call check_exit,"Environment check")

# CI 환경 검증
ci: deps format lint analyze check-atomic test
	@echo "CI checks completed successfully" 