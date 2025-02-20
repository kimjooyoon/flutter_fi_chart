import 'package:alchemist/alchemist.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_button.dart';

void main() {
  goldenTest(
    'AppButton renders correctly',
    fileName: 'app_button',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: AppButton(
            label: 'Click me',
            onPressed: () {},
          ),
        ),
        GoldenTestScenario(
          name: 'disabled',
          child: const AppButton(
            label: 'Disabled Button',
            isEnabled: false,
          ),
        ),
      ],
    ),
  );
}
