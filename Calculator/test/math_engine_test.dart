import 'package:test/test.dart';
import '../lib/features/custom_calculator/services/math_engine.dart';

void main() {
  group('MathEngine Tests', () {
    test('Basic Arithmetic', () {
      final res = MathEngine.evaluate('2 + 3 * 4', {});
      expect(res.isSuccess, true);
      expect(res.value, 14.0);
    });

    test('Variables', () {
      final res = MathEngine.evaluate('x^2', {'x': 3});
      expect(res.isSuccess, true);
      expect(res.value, 9.0);
    });

    test('Logarithm', () {
      final res = MathEngine.evaluate('log(100, 10)', {});
      expect(res.isSuccess, true);
      expect(res.value, closeTo(2.0, 0.001));
    });

    test('Root', () {
      final res = MathEngine.evaluate('root(27, 3)', {});
      expect(res.isSuccess, true);
      expect(res.value, closeTo(3.0, 0.001));
    });

    test('Derivative (x^2 at x=3)', () {
      final res = MathEngine.evaluate('deriv(x^2, x, 3)', {});
      expect(res.isSuccess, true);
      // derivative of x^2 is 2x. at x=3, it should be 6.
      expect(res.value, closeTo(6.0, 0.01));
    });

    test('Integration (x from 0 to 1)', () {
      final res = MathEngine.evaluate('integrate(x, x, 0, 1)', {});
      expect(res.isSuccess, true);
      // integral of x is 0.5*x^2. from 0 to 1 is 0.5.
      expect(res.value, closeTo(0.5, 0.01));
    });

    test('Integration (x^2 from 0 to 3)', () {
      final res = MathEngine.evaluate('integrate(x^2, x, 0, 3)', {});
      expect(res.isSuccess, true);
      // integral of x^2 is (1/3)x^3. at 3 is 9.
      expect(res.value, closeTo(9.0, 0.01));
    });

    test('Constants', () {
      final res = MathEngine.evaluate('pi', {});
      expect(res.isSuccess, true);
      expect(res.value, closeTo(3.14159, 0.00001));
    });

    test('Error Handling (Division by Zero)', () {
      final res = MathEngine.evaluate('1/0', {});
      expect(res.isSuccess, false);
      expect(res.error?.message, 'Result is Infinite');
    });
    
    test('Normalization', () {
      final res = MathEngine.evaluate('  2   +   2  ', {});
      expect(res.isSuccess, true);
      expect(res.value, 4.0);
    });
  });
}
