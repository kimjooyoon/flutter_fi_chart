import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_card.dart';

void main() {
  goldenTest(
    'AppCard renders correctly',
    fileName: 'app_card',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const AppCard(
            child: SizedBox(
              width: 200,
              height: 100,
              child: Center(
                child: Text('Default Card'),
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with custom padding',
          child: const AppCard(
            padding: EdgeInsets.all(32),
            child: SizedBox(
              width: 200,
              height: 100,
              child: Center(
                child: Text('Card with Custom Padding'),
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with custom elevation',
          child: const AppCard(
            elevation: 8,
            child: SizedBox(
              width: 200,
              height: 100,
              child: Center(
                child: Text('Card with Custom Elevation'),
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with custom color',
          child: AppCard(
            color: Colors.blue.shade50,
            child: const SizedBox(
              width: 200,
              height: 100,
              child: Center(
                child: Text('Card with Custom Color'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
