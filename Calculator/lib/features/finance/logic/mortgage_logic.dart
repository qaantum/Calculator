import 'dart:math';

class MortgageLogic {
  static double calculateMonthlyPayment({
    required double principal,
    required double annualRate,
    required int termYears,
  }) {
    final monthlyRate = annualRate / 100 / 12;
    final termMonths = termYears * 12;

    if (monthlyRate == 0) {
      return principal / termMonths;
    }

    return principal *
        (monthlyRate * pow(1 + monthlyRate, termMonths)) /
        (pow(1 + monthlyRate, termMonths) - 1);
  }

  static double calculateTotalMonthlyPayment({
    required double principalAndInterest,
    required double annualPropertyTax,
    required double annualInsurance,
    required double monthlyHOA,
  }) {
    return principalAndInterest + (annualPropertyTax / 12) + (annualInsurance / 12) + monthlyHOA;
  }
}
