import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class GoldenTestHelper {
  static Future<void> setupGoldenTests() async {
    await loadAppFonts();
    // 디바이스 설정 초기화
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    // 기본 디바이스 설정
    binding.platformDispatcher.displays.first.devicePixelRatio = 1.0;
    binding.platformDispatcher.displays.first.size = const Size(1080, 1920);
  }

  static Future<void> pumpGoldenTest(
    WidgetTester tester,
    String description,
    List<GoldenTestScenario> scenarios, {
    Size surfaceSize = const Size(400, 600),
    bool useScaffold = true,
    bool useMaterialApp = true,
    ThemeData? theme,
    Brightness? brightness,
    List<Locale>? supportedLocales,
    bool skipPumpAndSettle = false,
  }) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Test Scenario',
        Container(
          width: surfaceSize.width,
          constraints: BoxConstraints(
            minHeight: surfaceSize.height,
            maxHeight: surfaceSize.height,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: scenarios
                  .map(
                    (scenario) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _wrapWidget(
                        scenario.widget,
                        useScaffold: useScaffold,
                        useMaterialApp: useMaterialApp,
                        theme: theme ?? scenario.theme,
                        brightness: brightness,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: surfaceSize,
    );

    if (!skipPumpAndSettle) {
      await tester.pumpAndSettle();
    }

    await screenMatchesGolden(tester, description);
  }

  static Widget _wrapWidget(
    Widget widget, {
    bool useScaffold = true,
    bool useMaterialApp = true,
    ThemeData? theme,
    Brightness? brightness,
  }) {
    Widget wrappedWidget = widget;

    if (useScaffold) {
      wrappedWidget = Scaffold(
        body: Center(child: wrappedWidget),
      );
    }

    if (useMaterialApp) {
      wrappedWidget = MaterialApp(
        theme: theme?.copyWith(
              brightness: brightness,
            ) ??
            ThemeData.light().copyWith(
              brightness: brightness,
            ),
        debugShowCheckedModeBanner: false,
        home: wrappedWidget,
      );
    }

    return wrappedWidget;
  }

  static GoldenTestScenario createScenario({
    required String name,
    required Widget widget,
    ThemeData? theme,
    bool useScaffold = true,
    bool useMaterialApp = true,
    Brightness? brightness,
  }) {
    return GoldenTestScenario(
      name: name,
      widget: widget,
      theme: theme,
      useScaffold: useScaffold,
      useMaterialApp: useMaterialApp,
      brightness: brightness,
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
