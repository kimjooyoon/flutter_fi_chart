.PHONY: all clean test lint format analyze security deps

# 모든 검증을 실행
all: deps format lint analyze test

# 의존성 설치
deps:
	@echo "Installing dependencies..."
	@flutter pub get

# 코드 포맷팅
format:
	@echo "Formatting code..."
	@dart format lib test

# 린트 검사
lint:
	@echo "Running linter..."
	@flutter analyze

# 정적 분석
analyze:
	@echo "Running static analysis..."
	@flutter analyze --fatal-infos --fatal-warnings

# 테스트 실행
test:
	@echo "Running tests..."
	@flutter test --coverage

# 보안 검사 (dependency check)
security:
	@echo "Checking dependencies for security issues..."
	@flutter pub outdated
	@flutter pub deps

# 클린
clean:
	@echo "Cleaning..."
	@flutter clean
	@rm -rf coverage/
	@rm -rf build/ 