import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_card.dart';
import '../../helpers/golden_test_helper.dart';

void main() {
  group('AppCard Golden Tests', () {
    setUpAll(() async {
      await GoldenTestHelper.setupGoldenTests();
    });

    testGoldens('AppCard renders correctly in different states',
        (tester) async {
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Default Card',
          widget: AppCard(
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: const Text('Default Card'),
            ),
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'Colored Card',
          widget: AppCard(
            color: Colors.blue.shade50,
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: const Text('Colored Card'),
            ),
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'Elevated Card',
          widget: AppCard(
            elevation: 8,
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: const Text('Elevated Card'),
            ),
          ),
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_card_states',
        scenarios,
      );
    });

    testGoldens('AppCard renders correctly in dark theme', (tester) async {
      final darkTheme = ThemeData.dark();
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Default Dark',
          widget: AppCard(
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: const Text('Dark Card'),
            ),
          ),
          theme: darkTheme,
        ),
        GoldenTestHelper.createScenario(
          name: 'Colored Dark',
          widget: AppCard(
            color: Colors.blue.shade900,
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: const Text('Colored Dark Card'),
            ),
          ),
          theme: darkTheme,
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_card_dark_theme',
        scenarios,
      );
    });
  });
}
