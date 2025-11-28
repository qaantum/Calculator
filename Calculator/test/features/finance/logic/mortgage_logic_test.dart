import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_hub/features/finance/logic/mortgage_logic.dart';

void main() {
  group('MortgageLogic', () {
    test('calculateMonthlyPayment returns correct value for standard loan', () {
      // $300,000 loan, 4% interest, 30 years
      final payment = MortgageLogic.calculateMonthlyPayment(
        principal: 300000,
        annualRate: 4,
        termYears: 30,
      );
      // Expected: ~1432.25
      expect(payment, closeTo(1432.25, 0.01));
    });

    test('calculateMonthlyPayment handles 0% interest', () {
      // $300,000 loan, 0% interest, 30 years
      final payment = MortgageLogic.calculateMonthlyPayment(
        principal: 300000,
        annualRate: 0,
        termYears: 30,
      );
      // Expected: 300000 / (30 * 12) = 833.33
      expect(payment, closeTo(833.33, 0.01));
    });

    test('calculateTotalMonthlyPayment adds expenses correctly', () {
      final total = MortgageLogic.calculateTotalMonthlyPayment(
        principalAndInterest: 1000,
        annualPropertyTax: 2400, // 200/mo
        annualInsurance: 1200, // 100/mo
        monthlyHOA: 50,
      );
      // Expected: 1000 + 200 + 100 + 50 = 1350
      expect(total, 1350);
    });
  });
}
