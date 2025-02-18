import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_icon.dart';
import '../../../helpers/atomic/golden_test_helper.dart';

void main() {
  group('AppIcon Golden Tests', () {
    setUpAll(() async {
      await GoldenTestHelper.setupGoldenTests();
    });

    testGoldens('AppIcon renders correctly in different states',
        (tester) async {
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Default Icon',
          widget: const AppIcon(
            icon: AppIcons.trade,
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'Colored Icon',
          widget: const AppIcon(
            icon: AppIcons.portfolio,
            color: Colors.blue,
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'Large Icon',
          widget: const AppIcon(
            icon: AppIcons.chart,
            size: 48,
          ),
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_icon_states',
        scenarios,
      );
    });

    testGoldens('AppIcon renders correctly in dark theme', (tester) async {
      final darkTheme = ThemeData.dark();
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Default Dark',
          widget: const AppIcon(
            icon: AppIcons.settings,
          ),
          theme: darkTheme,
        ),
        GoldenTestHelper.createScenario(
          name: 'Colored Dark',
          widget: const AppIcon(
            icon: AppIcons.notification,
            color: Colors.blue,
          ),
          theme: darkTheme,
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_icon_dark_theme',
        scenarios,
      );
    });
  });
}
