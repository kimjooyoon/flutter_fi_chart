import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/chart_grid.dart';

void main() {
  goldenTest(
    'AtomChartGrid 렌더링 테스트',
    fileName: 'atom_chart_grid',
    builder: () => GoldenTestGroup(
      children: [
        // 기본 그리드 테스트
        GoldenTestScenario(
          name: '기본 설정',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartGrid(
              horizontalLinesCount: 5,
              verticalLinesCount: 6,
            ),
          ),
        ),
        
        // 사용자 지정 색상 테스트
        GoldenTestScenario(
          name: '사용자 지정 색상',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartGrid(
              horizontalLinesCount: 5,
              verticalLinesCount: 6,
              horizontalLineColor: Colors.blue[200],
              verticalLineColor: Colors.blue[200],
            ),
          ),
        ),
        
        // 사용자 지정 선 두께 테스트
        GoldenTestScenario(
          name: '두꺼운 선',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartGrid(
              horizontalLinesCount: 5,
              verticalLinesCount: 6,
              horizontalLineWidth: 2.0,
              verticalLineWidth: 2.0,
            ),
          ),
        ),
        
        // 다양한 그리드 밀도 테스트
        GoldenTestScenario(
          name: '고밀도 그리드',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartGrid(
              horizontalLinesCount: 10,
              verticalLinesCount: 12,
            ),
          ),
        ),
        
        // 점선 스타일 테스트
        GoldenTestScenario(
          name: '점선 스타일',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartGrid(
              horizontalLinesCount: 5,
              verticalLinesCount: 6,
              horizontalDashPattern: [5, 5],
              verticalDashPattern: [5, 5],
            ),
          ),
        ),
      ],
    ),
  );
} 