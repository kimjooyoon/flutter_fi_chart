import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/templates/template_finance_chart_page.dart';

void main() {
  goldenTest(
    'TemplateFinanceChartPage renders correctly with different layouts',
    fileName: 'template_finance_chart_page',
    constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
      children: [
        // 시나리오: 기본 레이아웃 (헤더와 차트만 있는 경우)
        GoldenTestScenario(
          name: '기본 레이아웃 (헤더와 차트만)',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: TemplateFinanceChartPage(
              headerBuilder: (context) => Container(
                height: 80,
                color: Colors.blue.withOpacity(0.1),
                child: const Center(
                  child: Text('헤더 영역'),
                ),
              ),
              chartBuilder: (context) => Container(
                color: Colors.green.withOpacity(0.1),
                child: const Center(
                  child: Text('차트 영역'),
                ),
              ),
            ),
          ),
        ),
        
        // 시나리오: 모든 요소가 포함된 전체 레이아웃
        GoldenTestScenario(
          name: '전체 레이아웃 (헤더, 차트, 정보, 액션)',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: TemplateFinanceChartPage(
              headerBuilder: (context) => Container(
                height: 80,
                color: Colors.blue.withOpacity(0.1),
                child: const Center(
                  child: Text('헤더 영역'),
                ),
              ),
              chartBuilder: (context) => Container(
                color: Colors.green.withOpacity(0.1),
                child: const Center(
                  child: Text('차트 영역'),
                ),
              ),
              infoBuilder: (context) => Container(
                color: Colors.orange.withOpacity(0.1),
                child: const Center(
                  child: Text('정보 영역'),
                ),
              ),
              actionBuilder: (context) => Container(
                height: 50,
                color: Colors.purple.withOpacity(0.1),
                child: const Center(
                  child: Text('액션 영역'),
                ),
              ),
            ),
          ),
        ),
        
        // 시나리오: 다크 테마 레이아웃
        GoldenTestScenario(
          name: '다크 테마 레이아웃',
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: TemplateFinanceChartPage(
              headerBuilder: (context) => Container(
                height: 80,
                color: Colors.blueGrey.withOpacity(0.2),
                child: const Center(
                  child: Text('헤더 영역 (다크)'),
                ),
              ),
              chartBuilder: (context) => Container(
                color: Colors.teal.withOpacity(0.2),
                child: const Center(
                  child: Text('차트 영역 (다크)'),
                ),
              ),
              infoBuilder: (context) => Container(
                color: Colors.amber.withOpacity(0.2),
                child: const Center(
                  child: Text('정보 영역 (다크)'),
                ),
              ),
              actionBuilder: (context) => Container(
                height: 50,
                color: Colors.deepPurple.withOpacity(0.2),
                child: const Center(
                  child: Text('액션 영역 (다크)'),
                ),
              ),
            ),
          ),
        ),
        
        // 시나리오: 커스텀 배경색 레이아웃
        GoldenTestScenario(
          name: '커스텀 배경색 레이아웃',
          child: MaterialApp(
            theme: ThemeData.light(),
            home: TemplateFinanceChartPage(
              backgroundColor: Colors.grey.shade100,
              headerBuilder: (context) => Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(4),
                child: const Center(
                  child: Text('헤더 영역 (커스텀)'),
                ),
              ),
              chartBuilder: (context) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(4),
                child: const Center(
                  child: Text('차트 영역 (커스텀)'),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
} 