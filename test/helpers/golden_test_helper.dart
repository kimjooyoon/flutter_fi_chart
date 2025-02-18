import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class GoldenTestHelper {
  static Future<void> setupGoldenTests() async {
    await loadAppFonts();
  }

  static Future<void> pumpGoldenTest(
    WidgetTester tester,
    String description,
    List<GoldenTestScenario> scenarios, {
    Size surfaceSize = const Size(400, 600),
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
                      child: scenario.widget,
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

    await screenMatchesGolden(tester, description);
  }

  static GoldenTestScenario createScenario({
    required String name,
    required Widget widget,
    ThemeData? theme,
  }) {
    return GoldenTestScenario(
      name: name,
      widget: MaterialApp(
        theme: theme ?? ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: widget,
          ),
        ),
      ),
    );
  }
}

@immutable
class GoldenTestScenario {
  final String name;
  final Widget widget;

  const GoldenTestScenario({
    required this.name,
    required this.widget,
  });
}
