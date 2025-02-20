import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GoldenTestHelper {
  /// 골든 테스트 환경 설정
  static Future<void> setupGoldenTests() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // 디바이스 설정
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.displays.first.devicePixelRatio = 1.0;
    binding.platformDispatcher.displays.first.size = const Size(1080, 1920);
  }

  /// 테스트 시나리오 생성
  static GoldenTestScenario createScenario({
    required String name,
    required Widget widget,
    ThemeData? theme,
    Brightness? brightness,
    bool useMaterialApp = true,
    bool useScaffold = false,
  }) {
    Widget wrappedWidget = widget;

    if (useScaffold) {
      wrappedWidget = Scaffold(body: Center(child: widget));
    }

    if (useMaterialApp) {
      wrappedWidget = MaterialApp(
        theme: theme ??
            (brightness == Brightness.dark
                ? ThemeData.dark()
                : ThemeData.light()),
        debugShowCheckedModeBanner: false,
        home: wrappedWidget,
      );
    }

    return GoldenTestScenario(
      name: name,
      widget: wrappedWidget,
    );
  }

  /// 골든 테스트 실행
  static Future<void> pumpGoldenTest(
    WidgetTester tester,
    String name,
    List<GoldenTestScenario> scenarios, {
    Size? surfaceSize,
    bool skipPumpAndSettle = true,
  }) async {
    await tester.binding.setSurfaceSize(surfaceSize ?? const Size(800, 600));

    await tester.pumpWidget(
      Column(
        children: scenarios.map((scenario) => scenario.widget).toList(),
      ),
    );

    if (!skipPumpAndSettle) {
      await tester.pumpAndSettle();
    }

    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/$name.png'),
    );
  }
}

@immutable
class GoldenTestScenario {
  final String name;
  final Widget widget;
  final ThemeData? theme;
  final bool useScaffold;
  final bool useMaterialApp;
  final Brightness? brightness;

  const GoldenTestScenario({
    required this.name,
    required this.widget,
    this.theme,
    this.useScaffold = true,
    this.useMaterialApp = true,
    this.brightness,
  });
}
