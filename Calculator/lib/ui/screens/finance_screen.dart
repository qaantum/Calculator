import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'Amortization', 'icon': FontAwesomeIcons.tableList, 'route': '/finance/amortization'},
      {'title': 'Auto Loan', 'icon': FontAwesomeIcons.car, 'route': '/finance/car'},
      {'title': 'Break-Even', 'icon': FontAwesomeIcons.scaleBalanced, 'route': '/finance/breakeven'},
      {'title': 'CAGR', 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/finance/cagr'},
      {'title': 'Commission', 'icon': FontAwesomeIcons.handHoldingDollar, 'route': '/finance/commission'},
      {'title': 'Currency', 'icon': FontAwesomeIcons.arrowRightArrowLeft, 'route': '/finance/currency'},
      {'title': 'Debt Snowball', 'icon': FontAwesomeIcons.snowflake, 'route': '/finance/debtsnowball'},
      {'title': 'Discount', 'icon': FontAwesomeIcons.tags, 'route': '/finance/discount'},
      {'title': 'Effective Rate', 'icon': FontAwesomeIcons.chartLine, 'route': '/finance/effectiverate'},
      {'title': 'Electricity', 'icon': FontAwesomeIcons.bolt, 'route': '/finance/electricity'},
      {'title': 'Inflation', 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/finance/inflation'},
      {'title': 'Compound Interest', 'icon': FontAwesomeIcons.chartLine, 'route': '/finance/interest/compound'},
      {'title': 'Credit Card Payoff', 'icon': FontAwesomeIcons.creditCard, 'route': '/finance/creditcard'},
      {'title': 'Investment', 'icon': FontAwesomeIcons.moneyBillTrendUp, 'route': '/finance/investment'},
      {'title': 'Loan', 'icon': FontAwesomeIcons.moneyBillWave, 'route': '/finance/loan'},
      {'title': 'Loan Affordability', 'icon': FontAwesomeIcons.handHoldingDollar, 'route': '/finance/affordability'},
      {'title': 'Margin', 'icon': FontAwesomeIcons.shop, 'route': '/finance/margin'},
      {'title': 'Mortgage', 'icon': FontAwesomeIcons.house, 'route': '/finance/mortgage'},
      {'title': 'Refinance', 'icon': FontAwesomeIcons.rotate, 'route': '/finance/refinance'},
      {'title': 'Rental Property', 'icon': FontAwesomeIcons.houseUser, 'route': '/finance/rental'},
      {'title': 'Retirement', 'icon': FontAwesomeIcons.umbrellaBeach, 'route': '/finance/retirement'},
      {'title': 'ROI', 'icon': FontAwesomeIcons.chartPie, 'route': '/finance/roi'},
      {'title': 'Rule of 72', 'icon': FontAwesomeIcons.hourglassHalf, 'route': '/finance/rule72'},
      {'title': 'Salary', 'icon': FontAwesomeIcons.briefcase, 'route': '/finance/salary'},
      {'title': 'Savings Goal', 'icon': FontAwesomeIcons.piggyBank, 'route': '/finance/savings'},
      {'title': 'Sales Tax', 'icon': FontAwesomeIcons.receipt, 'route': '/finance/salestax'},
      {'title': 'Simple Interest', 'icon': FontAwesomeIcons.percent, 'route': '/finance/interest'},
      {'title': 'Stock Profit', 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/finance/stock'},
      {'title': 'Tax', 'icon': FontAwesomeIcons.calculator, 'route': '/finance/tax'},
      {'title': 'TVM Calculator', 'icon': FontAwesomeIcons.moneyBillTrendUp, 'route': '/finance/tvm'},
      {'title': 'Unit Price', 'icon': FontAwesomeIcons.tag, 'route': '/finance/unitprice'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Financial Calculators'),
            centerTitle: false,
            floating: true,
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final calc = calculators[index];
                  return CalculatorCard(
                    title: calc['title'] as String,
                    icon: calc['icon'] as IconData,
                    color: Colors.blue, // You might want to vary colors here later
                    route: calc['route'] as String,
                    onTap: () => context.go(calc['route'] as String),
                  );
                },
                childCount: calculators.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
