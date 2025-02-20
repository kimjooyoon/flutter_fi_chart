import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_text_field.dart';

void main() {
  goldenTest(
    'AppTextField renders correctly',
    fileName: 'app_text_field',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const SizedBox(
            width: 300,
            child: AppTextField(
              label: 'Enter text',
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with value',
          child: const SizedBox(
            width: 300,
            child: AppTextField(
              label: 'Label',
              value: 'Sample text',
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with error',
          child: const SizedBox(
            width: 300,
            child: AppTextField(
              label: 'Label',
              error: 'Error message',
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'disabled',
          child: const SizedBox(
            width: 300,
            child: AppTextField(
              label: 'Disabled field',
              enabled: false,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with prefix',
          child: const SizedBox(
            width: 300,
            child: AppTextField(
              label: 'Amount',
              prefix: Icon(Icons.attach_money),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with label',
          child: const AppTextField(
            label: 'Label',
          ),
        ),
      ],
    ),
  );
}
