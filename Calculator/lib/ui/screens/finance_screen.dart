import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final calculators = [
      {'title': l10n.calcAmortization, 'icon': FontAwesomeIcons.tableList, 'route': '/finance/amortization'},
      {'title': l10n.calcAutoLoan, 'icon': FontAwesomeIcons.car, 'route': '/finance/car'},
      {'title': l10n.calcBreakEven, 'icon': FontAwesomeIcons.scaleBalanced, 'route': '/finance/breakeven'},
      {'title': l10n.calcCAGR, 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/finance/cagr'},
      {'title': l10n.calcCommission, 'icon': FontAwesomeIcons.handHoldingDollar, 'route': '/finance/commission'},
      {'title': l10n.calcCurrency, 'icon': FontAwesomeIcons.arrowRightArrowLeft, 'route': '/finance/currency'},
      {'title': l10n.calcDebtSnowball, 'icon': FontAwesomeIcons.snowflake, 'route': '/finance/debtsnowball'},
      {'title': l10n.calcDiscount, 'icon': FontAwesomeIcons.tags, 'route': '/finance/discount'},
      {'title': l10n.calcEffectiveRate, 'icon': FontAwesomeIcons.chartLine, 'route': '/finance/effectiverate'},
      {'title': l10n.calcElectricity, 'icon': FontAwesomeIcons.bolt, 'route': '/finance/electricity'},
      {'title': l10n.calcInflation, 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/finance/inflation'},
      {'title': l10n.calcCompoundInterest, 'icon': FontAwesomeIcons.chartLine, 'route': '/finance/interest/compound'},
      {'title': l10n.calcCreditCardPayoff, 'icon': FontAwesomeIcons.creditCard, 'route': '/finance/creditcard'},
      {'title': l10n.calcInvestment, 'icon': FontAwesomeIcons.moneyBillTrendUp, 'route': '/finance/investment'},
      {'title': l10n.calcLoan, 'icon': FontAwesomeIcons.moneyBillWave, 'route': '/finance/loan'},
      {'title': l10n.calcLoanAffordability, 'icon': FontAwesomeIcons.handHoldingDollar, 'route': '/finance/affordability'},
      {'title': l10n.calcMargin, 'icon': FontAwesomeIcons.shop, 'route': '/finance/margin'},
      {'title': l10n.calcMortgage, 'icon': FontAwesomeIcons.house, 'route': '/finance/mortgage'},
      {'title': l10n.calcRefinance, 'icon': FontAwesomeIcons.rotate, 'route': '/finance/refinance'},
      {'title': l10n.calcRentalProperty, 'icon': FontAwesomeIcons.houseUser, 'route': '/finance/rental'},
      {'title': l10n.calcRetirement, 'icon': FontAwesomeIcons.umbrellaBeach, 'route': '/finance/retirement'},
      {'title': l10n.calcROI, 'icon': FontAwesomeIcons.chartPie, 'route': '/finance/roi'},
      {'title': l10n.calcRule72, 'icon': FontAwesomeIcons.hourglassHalf, 'route': '/finance/rule72'},
      {'title': l10n.calcSalary, 'icon': FontAwesomeIcons.briefcase, 'route': '/finance/salary'},
      {'title': l10n.calcSavingsGoal, 'icon': FontAwesomeIcons.piggyBank, 'route': '/finance/savings'},
      {'title': l10n.calcSalesTax, 'icon': FontAwesomeIcons.receipt, 'route': '/finance/salestax'},
      {'title': l10n.calcSimpleInterest, 'icon': FontAwesomeIcons.percent, 'route': '/finance/interest'},
      {'title': l10n.calcStockProfit, 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/finance/stock'},
      {'title': l10n.calcTax, 'icon': FontAwesomeIcons.calculator, 'route': '/finance/tax'},
      {'title': l10n.calcTVM, 'icon': FontAwesomeIcons.moneyBillTrendUp, 'route': '/finance/tvm'},
      {'title': l10n.calcUnitPrice, 'icon': FontAwesomeIcons.tag, 'route': '/finance/unitprice'},
      // NEW CALCULATORS
      {'title': 'NPV Calculator', 'icon': FontAwesomeIcons.chartLine, 'route': '/finance/npv'},
      {'title': 'IRR Calculator', 'icon': FontAwesomeIcons.chartLine, 'route': '/finance/irr'},
      {'title': 'Down Payment', 'icon': FontAwesomeIcons.house, 'route': '/finance/downpayment'},
      {'title': 'Paycheck', 'icon': FontAwesomeIcons.moneyCheck, 'route': '/finance/paycheck'},
      {'title': 'CD Calculator', 'icon': FontAwesomeIcons.buildingColumns, 'route': '/finance/cd'},
      {'title': 'Tip Split', 'icon': FontAwesomeIcons.users, 'route': '/finance/tipsplit'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(l10n.financialCalculators),
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
