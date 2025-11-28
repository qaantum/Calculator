import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class MathError {
  final String message;
  final int? position;
  final String? rawError;

  MathError({required this.message, this.position, this.rawError});

  @override
  String toString() => message;
}

class MathResult {
  final double? value;
  final MathError? error;

  bool get isSuccess => value != null && error == null;

  MathResult.success(this.value) : error = null;
  MathResult.failure(this.error) : value = null;
}

class MathEngine {
  static const int _maxIntegrationSteps = 1000;
  
  static MathResult evaluate(String formula, Map<String, double> variables) {
    try {
      // 1. Normalization
      String normalizedFormula = formula.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (normalizedFormula.isEmpty) return MathResult.failure(MathError(message: 'Formula is empty'));
      if (normalizedFormula.length > 1000) return MathResult.failure(MathError(message: 'Formula too long'));

      // 2. Pre-process custom functions (deriv, integrate, log, root)
      // We use regex for now as a pragmatic "Registry" for these complex/custom functions
      String processedFormula = _processCustomFunctions(normalizedFormula, variables);

      // 3. Parse and Bind
      Parser p = Parser();
      Expression exp = p.parse(processedFormula);
      ContextModel cm = ContextModel();
      
      variables.forEach((key, value) {
        cm.bindVariable(Variable(key), Number(value));
      });
      
      // Bind constants
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      // 4. Evaluate with Safety Checks
      double result = exp.evaluate(EvaluationType.REAL, cm);
      
      if (result.isNaN) return MathResult.failure(MathError(message: 'Result is NaN'));
      if (result.isInfinite) return MathResult.failure(MathError(message: 'Result is Infinite'));
      
      return MathResult.success(result);
    } catch (e) {
      if (e is FormatException) return MathResult.failure(MathError(message: 'Syntax Error', rawError: e.toString()));
      if (e is ArgumentError) return MathResult.failure(MathError(message: 'Invalid Argument: ${e.message}', rawError: e.toString()));
      return MathResult.failure(MathError(message: 'Evaluation Error', rawError: e.toString()));
    }
  }

  static String _processCustomFunctions(String formula, Map<String, double> variables) {
    String result = formula;

    // log(value, base) -> (ln(value)/ln(base))
    final logRegex = RegExp(r'log\(([^,]+),([^)]+)\)');
    result = result.replaceAllMapped(logRegex, (match) {
      final val = match.group(1);
      final base = match.group(2);
      return '(ln($val)/ln($base))';
    });
    
    // root(value, n) -> value^(1/n)
    final rootRegex = RegExp(r'root\(([^,]+),([^)]+)\)');
    result = result.replaceAllMapped(rootRegex, (match) {
      final val = match.group(1);
      final n = match.group(2);
      return '($val^(1/$n))';
    });

    // integrate(expression, var, start, end)
    final integrateRegex = RegExp(r'integrate\(([^,]+),([^,]+),([^,]+),([^)]+)\)');
    result = result.replaceAllMapped(integrateRegex, (match) {
      final exprStr = match.group(1)!.trim();
      final varName = match.group(2)!.trim();
      final startStr = match.group(3)!.trim();
      final endStr = match.group(4)!.trim();

      double start = _basicEval(startStr, variables);
      double end = _basicEval(endStr, variables);

      double integral = _simpsonsRule(exprStr, varName, start, end, variables);
      return integral.toString();
    });

    // deriv(expression, var, point)
    final derivRegex = RegExp(r'deriv\(([^,]+),([^,]+),([^)]+)\)');
    result = result.replaceAllMapped(derivRegex, (match) {
      final exprStr = match.group(1)!.trim();
      final varName = match.group(2)!.trim();
      final pointStr = match.group(3)!.trim();

      double point = _basicEval(pointStr, variables);
      double derivative = _centralDifference(exprStr, varName, point, variables);
      return derivative.toString();
    });

    // daysBetween(t1, t2) -> abs(t1 - t2) / 86400
    final daysBetweenRegex = RegExp(r'daysBetween\(([^,]+),([^)]+)\)');
    result = result.replaceAllMapped(daysBetweenRegex, (match) {
      final t1 = match.group(1)!;
      final t2 = match.group(2)!;
      return '(abs($t1 - $t2) / 86400)';
    });

    // addDays(t, days) -> t + (days * 86400)
    final addDaysRegex = RegExp(r'addDays\(([^,]+),([^)]+)\)');
    result = result.replaceAllMapped(addDaysRegex, (match) {
      final t = match.group(1)!;
      final days = match.group(2)!;
      return '($t + ($days * 86400))';
    });

    // age(birthdate) -> (now - birthdate) / 31557600 (approx seconds in year)
    final ageRegex = RegExp(r'age\(([^)]+)\)');
    result = result.replaceAllMapped(ageRegex, (match) {
      final birthdate = match.group(1)!;
      final now = DateTime.now().millisecondsSinceEpoch / 1000;
      return '(($now - $birthdate) / 31557600)';
    });

    return result;
  }

  static double _basicEval(String expr, Map<String, double> variables) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      variables.forEach((key, value) {
        cm.bindVariable(Variable(key), Number(value));
      });
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception('Error evaluating sub-expression: $expr');
    }
  }

  static double _simpsonsRule(String expr, String varName, double a, double b, Map<String, double> variables) {
    int n = 100; // Steps (must be even)
    if (n > _maxIntegrationSteps) n = _maxIntegrationSteps;
    
    double h = (b - a) / n;
    
    double f(double x) {
      var localVars = Map<String, double>.from(variables);
      localVars[varName] = x;
      return _basicEval(expr, localVars);
    }

    double sum = f(a) + f(b);
    
    for (int i = 1; i < n; i++) {
      double x = a + i * h;
      sum += (i % 2 == 0 ? 2 : 4) * f(x);
    }

    return (h / 3) * sum;
  }

  static double _centralDifference(String expr, String varName, double x, Map<String, double> variables) {
    double h = 1e-5;
    
    double f(double val) {
      var localVars = Map<String, double>.from(variables);
      localVars[varName] = val;
      return _basicEval(expr, localVars);
    }

    return (f(x + h) - f(x - h)) / (2 * h);
  }
}
