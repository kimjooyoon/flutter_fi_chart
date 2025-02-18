import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_divider.dart';
import '../../helpers/golden_test_helper.dart';

void main() {
  group('AppDivider Golden Tests', () {
    setUpAll(() async {
      await GoldenTestHelper.setupGoldenTests();
    });

    testGoldens('AppDivider renders correctly in different states',
        (tester) async {
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Default Divider',
          widget: const SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Above'),
                AppDivider(),
                Text('Below'),
              ],
            ),
          ),
          useMaterialApp: true,
          useScaffold: true,
        ),
        GoldenTestHelper.createScenario(
          name: 'Colored Divider',
          widget: const SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Above'),
                AppDivider(
                  color: Colors.blue,
                  thickness: 2,
                ),
                Text('Below'),
              ],
            ),
          ),
          brightness: Brightness.light,
        ),
        GoldenTestHelper.createScenario(
          name: 'Indented Divider',
          widget: const SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Above'),
                AppDivider(
                  indent: 16,
                  endIndent: 16,
                ),
                Text('Below'),
              ],
            ),
          ),
          theme: ThemeData.light(),
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_divider_states',
        scenarios,
        surfaceSize: const Size(300, 800),
        skipPumpAndSettle: false,
      );
    });

    testGoldens('AppVerticalDivider renders correctly in different states',
        (tester) async {
      final scenarios = [
        GoldenTestHelper.createScenario(
          name: 'Default Vertical',
          widget: const SizedBox(
            height: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Left'),
                AppVerticalDivider(),
                Text('Right'),
              ],
            ),
          ),
          brightness: Brightness.light,
        ),
        GoldenTestHelper.createScenario(
          name: 'Colored Vertical',
          widget: const SizedBox(
            height: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Left'),
                AppVerticalDivider(
                  color: Colors.blue,
                  thickness: 2,
                ),
                Text('Right'),
              ],
            ),
          ),
          theme: ThemeData.dark(),
        ),
      ];

      await GoldenTestHelper.pumpGoldenTest(
        tester,
        'app_vertical_divider_states',
        scenarios,
        surfaceSize: const Size(300, 400),
      );
    });
  });
}
