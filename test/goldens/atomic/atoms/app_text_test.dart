import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_text.dart';
import '../../../helpers/atomic/golden_test_helper.dart';

void main() {
  group('AppText Golden Tests', () {
    setUpAll(() async {
      await GoldenTestHelper.setupGoldenTests();
    });

    testGoldens('AppText renders correctly in light theme', (tester) async {
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Heading',
          widget: const AppText(
            'Heading Text',
            variant: TextVariant.heading,
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'Body',
          widget: const AppText(
            'Body Text',
            variant: TextVariant.body,
          ),
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_text_light_theme',
        scenarios,
      );
    });

    testGoldens('AppText renders correctly in dark theme', (tester) async {
      final darkTheme = ThemeData.dark();
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Heading Dark',
          widget: const AppText(
            'Heading Text',
            variant: TextVariant.heading,
          ),
          theme: darkTheme,
        ),
        GoldenTestHelper.createScenario(
          name: 'Body Dark',
          widget: const AppText(
            'Body Text',
            variant: TextVariant.body,
          ),
          theme: darkTheme,
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_text_dark_theme',
        scenarios,
      );
    });
  });
}
