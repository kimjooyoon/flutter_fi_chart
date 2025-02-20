import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_icon.dart';

void main() {
  goldenTest(
    'AppIcon renders correctly',
    fileName: 'app_icon',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const AppIcon(
            icon: AppIcons.trade,
          ),
        ),
        GoldenTestScenario(
          name: 'with custom color',
          child: const AppIcon(
            icon: AppIcons.portfolio,
            color: Colors.blue,
          ),
        ),
        GoldenTestScenario(
          name: 'with custom size',
          child: const AppIcon(
            icon: AppIcons.chart,
            size: 48.0,
          ),
        ),
        GoldenTestScenario(
          name: 'with theme color',
          child: const AppIcon(
            icon: AppIcons.settings,
          ),
        ),
      ],
    ),
  );
}
