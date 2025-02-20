import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_divider.dart';

void main() {
  goldenTest(
    'AppDivider renders correctly',
    fileName: 'app_divider',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const SizedBox(
            width: 200,
            child: AppDivider(),
          ),
        ),
        GoldenTestScenario(
          name: 'with custom color',
          child: const SizedBox(
            width: 200,
            child: AppDivider(
              color: Colors.blue,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with custom thickness',
          child: const SizedBox(
            width: 200,
            child: AppDivider(
              thickness: 4.0,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with custom indent',
          child: const SizedBox(
            width: 200,
            child: AppDivider(
              indent: 20.0,
              endIndent: 20.0,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'vertical divider',
          child: const SizedBox(
            height: 200,
            child: AppVerticalDivider(),
          ),
        ),
      ],
    ),
  );
}
