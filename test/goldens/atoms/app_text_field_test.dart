import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_text_field.dart';
import '../../helpers/golden_test_helper.dart';

void main() {
  group('AppTextField Golden Tests', () {
    setUpAll(() async {
      await GoldenTestHelper.setupGoldenTests();
    });

    testGoldens('AppTextField renders correctly in different states',
        (tester) async {
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Empty',
          widget: const AppTextField(
            label: 'Enter text',
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'With Value',
          widget: const AppTextField(
            label: 'Sample Text',
            value: 'Sample Value',
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'With Error',
          widget: const AppTextField(
            label: 'Error Field',
            error: 'Error message',
          ),
        ),
        GoldenTestHelper.createScenario(
          name: 'Disabled',
          widget: const AppTextField(
            label: 'Disabled field',
            enabled: false,
          ),
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_text_field_states',
        scenarios,
      );
    });

    testGoldens('AppTextField renders correctly in dark theme', (tester) async {
      final darkTheme = ThemeData.dark();
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Empty Dark',
          widget: const AppTextField(
            label: 'Enter text',
          ),
          theme: darkTheme,
        ),
        GoldenTestHelper.createScenario(
          name: 'With Value Dark',
          widget: const AppTextField(
            label: 'Sample Text',
            value: 'Sample Value',
          ),
          theme: darkTheme,
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_text_field_dark_theme',
        scenarios,
      );
    });
  });
}
