import 'package:flutter/material.dart';
import 'package:flutter_fi_chart/presentation/atomic/atoms/app_text.dart';
import 'package:flutter_fi_chart/presentation/atomic/organisms/organism_financial_chart.dart';
import 'package:flutter_fi_chart/presentation/atomic/templates/template_finance_chart_page.dart';

/// 주식 상세 정보 페이지
///
/// 특정 주식의 상세 정보와 차트를 표시하는 페이지입니다.
/// 템플릿을 사용하여 레이아웃을 구성하고, 실제 데이터를 표시합니다.
class PageStockDetail extends StatelessWidget {
  /// 주식 상세 페이지 생성자
  const PageStockDetail({
    super.key,
    required this.stockSymbol,
    required this.stockName,
    this.stockPrice,
    this.priceChange,
    this.priceChangePercentage,
    this.stockData,
  });

  /// 주식 심볼 (예: AAPL)
  final String stockSymbol;
  
  /// 주식 이름 (예: Apple Inc.)
  final String stockName;
  
  /// 현재 주가
  final double? stockPrice;
  
  /// 가격 변동
  final double? priceChange;
  
  /// 가격 변동률 (%)
  final double? priceChangePercentage;
  
  /// 차트에 표시할 주가 데이터
  final List<dynamic>? stockData;

  @override
  Widget build(BuildContext context) {
    return TemplateFinanceChartPage(
      // 헤더 빌더: 주식명과 심볼 표시
      headerBuilder: (context) => _buildHeader(context),
      
      // 차트 빌더: 주식 차트 표시
      chartBuilder: (context) => _buildChart(context),
      
      // 정보 빌더: 주식 상세 정보 표시
      infoBuilder: (context) => _buildInfo(context),
      
      // 액션 빌더: 매수/매도 버튼 등 표시
      actionBuilder: (context) => _buildActions(context),
    );
  }

  /// 헤더 영역 구성
  Widget _buildHeader(BuildContext context) {
    final isPositive = priceChange != null && priceChange! >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppText(
              stockName,
              variant: TextVariant.heading,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: AppText(
                stockSymbol,
                variant: TextVariant.caption,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (stockPrice != null) ...[
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText(
                '\$${stockPrice!.toStringAsFixed(2)}',
                variant: TextVariant.heading,
              ),
              if (priceChange != null && priceChangePercentage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: changeColor,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        '${priceChange!.toStringAsFixed(2)} (${priceChangePercentage!.toStringAsFixed(2)}%)',
                        color: changeColor,
                        variant: TextVariant.caption,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// 차트 영역 구성
  Widget _buildChart(BuildContext context) {
    return const OrganismFinancialChart();
  }

  /// 정보 영역 구성
  Widget _buildInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText('기본 정보', variant: TextVariant.label),
            const SizedBox(height: 8),
            _buildInfoRow('시가총액', '₩1,234,567,890,000'),
            _buildInfoRow('PER', '25.4'),
            _buildInfoRow('PBR', '3.2'),
            _buildInfoRow('배당 수익률', '0.5%'),
          ],
        ),
      ),
    );
  }

  /// 정보 행 구성
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: AppText(label, variant: TextVariant.caption),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: AppText(
              value, 
              variant: TextVariant.body,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 액션 영역 구성
  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('매수'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('매도'),
          ),
        ),
      ],
    );
  }
} 