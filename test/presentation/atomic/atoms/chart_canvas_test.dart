import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/chart_canvas.dart';

void main() {
  goldenTest(
    'AtomChartCanvas 렌더링 테스트',
    fileName: 'atom_chart_canvas',
    builder: () => GoldenTestGroup(
      children: [
        // 기본 속성으로 차트 캔버스 테스트
        GoldenTestScenario(
          name: '기본 설정',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartCanvas(
              child: const Center(child: Text('기본 차트 캔버스')),
            ),
          ),
        ),
        
        // 사용자 지정 크기로 테스트
        GoldenTestScenario(
          name: '사용자 지정 크기',
          child: AtomChartCanvas(
            width: 250,
            height: 150,
            child: const Center(child: Text('사용자 지정 크기 캔버스')),
          ),
        ),
        
        // 사용자 지정 색상으로 테스트
        GoldenTestScenario(
          name: '사용자 지정 색상',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartCanvas(
              backgroundColor: Colors.lightBlue[50],
              borderColor: Colors.blue,
              child: const Center(child: Text('파란색 테마 캔버스')),
            ),
          ),
        ),
        
        // 사용자 지정 테두리 두께로 테스트
        GoldenTestScenario(
          name: '두꺼운 테두리',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartCanvas(
              borderWidth: 3.0,
              borderColor: Colors.red,
              child: const Center(child: Text('두꺼운 테두리 캔버스')),
            ),
          ),
        ),
        
        // 복잡한 자식 위젯으로 테스트
        GoldenTestScenario(
          name: '복잡한 내용',
          child: SizedBox(
            width: 300,
            height: 200,
            child: AtomChartCanvas(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('차트 제목', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    height: 80,
                    color: Colors.grey[200],
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          5,
                          (index) => Container(
                            width: 20,
                            height: 60 * (index + 1) / 5,
                            color: Colors.blue[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
} 