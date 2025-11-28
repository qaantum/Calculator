import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_hub/features/finance/logic/loan_logic.dart';

void main() {
  group('LoanLogic', () {
    test('calculateLoan returns correct values for standard loan', () {
      // $10,000 loan, 5% interest, 3 years (36 months)
      final result = LoanLogic.calculateLoan(
        principal: 10000,
        annualRate: 5,
        termMonths: 36,
      );

      // Expected Payment: ~299.71
      expect(result['monthlyPayment'], closeTo(299.71, 0.01));
      
      // Total Cost: 299.71 * 36 = 10789.56
      expect(result['totalCost'], closeTo(10789.56, 0.1));

      // Total Interest: 10789.56 - 10000 = 789.56
      expect(result['totalInterest'], closeTo(789.56, 0.1));
    });

    test('calculateLoan handles 0% interest', () {
      final result = LoanLogic.calculateLoan(
        principal: 1200,
        annualRate: 0,
        termMonths: 12,
      );

      expect(result['monthlyPayment'], 100);
      expect(result['totalInterest'], 0);
      expect(result['totalCost'], 1200);
    });
  });
}
