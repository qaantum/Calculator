import 'dart:math';

class LoanLogic {
  static Map<String, double> calculateLoan({
    required double principal,
    required double annualRate,
    required int termMonths,
  }) {
    final monthlyRate = annualRate / 100 / 12;
    double monthlyPayment;

    if (monthlyRate == 0) {
      monthlyPayment = principal / termMonths;
    } else {
      monthlyPayment = principal *
          (monthlyRate * pow(1 + monthlyRate, termMonths)) /
          (pow(1 + monthlyRate, termMonths) - 1);
    }

    final totalPayment = monthlyPayment * termMonths;
    final totalInterest = totalPayment - principal;

    return {
      'monthlyPayment': monthlyPayment,
      'totalInterest': totalInterest,
      'totalCost': totalPayment,
    };
  }
}
