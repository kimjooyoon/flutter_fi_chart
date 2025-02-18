import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_button.dart';

void main() {
  group('AppButton Golden Tests', () {
    testGoldens('renders correctly in different states', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 1,
      )
        ..addScenario(
          'Enabled Button',
          const AppButton(
            label: 'Click me',
            onPressed: null,
          ),
        )
        ..addScenario(
          'Disabled Button',
          const AppButton(
            label: 'Disabled',
            isEnabled: false,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
      );

      await screenMatchesGolden(tester, 'app_button_states');
    });
  });
}
