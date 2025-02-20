import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_text.dart';

void main() {
  goldenTest(
    'AppText renders correctly',
    fileName: 'app_text',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'heading variant',
          child: const AppText(
            'Heading Text',
            variant: TextVariant.heading,
          ),
        ),
        GoldenTestScenario(
          name: 'body variant',
          child: const AppText(
            'Body Text',
            variant: TextVariant.body,
          ),
        ),
        GoldenTestScenario(
          name: 'label variant',
          child: const AppText(
            'Label Text',
            variant: TextVariant.label,
          ),
        ),
        GoldenTestScenario(
          name: 'caption variant',
          child: const AppText(
            'Caption Text',
            variant: TextVariant.caption,
          ),
        ),
        GoldenTestScenario(
          name: 'with custom color',
          child: const AppText(
            'Colored Text',
            variant: TextVariant.body,
            color: Colors.blue,
          ),
        ),
        GoldenTestScenario(
          name: 'with overflow',
          child: const SizedBox(
            width: 100,
            child: AppText(
              'This is a very long text that should overflow',
              variant: TextVariant.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
