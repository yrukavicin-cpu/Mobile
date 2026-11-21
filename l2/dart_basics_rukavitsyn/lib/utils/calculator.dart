// Простий калькулятор (Task 1)
class Calculator {
  // тут зберігаються всі операції
  final List<String> history = [];

  double add(double a, double b) {
    final r = a + b;
    history.add('$a + $b = $r');
    return r;
  }

  double subtract(double a, double b) {
    final r = a - b;
    history.add('$a - $b = $r');
    return r;
  }

  double multiply(double a, double b) {
    final r = a * b;
    history.add('$a * $b = $r');
    return r;
  }

  double divide(double a, double b) {
    if (b == 0) {
      throw ArgumentError('Ділення на нуль!');
    }
    final r = a / b;
    history.add('$a / $b = $r');
    return r;
  }

  // степінь через цикл, тільки для цілих n >= 0
  double power(double a, int n) {
    double r = 1;
    for (int i = 0; i < n; i++) {
      r *= a;
    }
    history.add('$a ^ $n = $r');
    return r;
  }

  int mod(int a, int b) {
    final r = a % b;
    history.add('$a % $b = $r');
    return r;
  }

  // обчислення по символу операції
  double calculate(double a, String op, double b) {
    switch (op) {
      case '+':
        return add(a, b);
      case '-':
        return subtract(a, b);
      case '*':
        return multiply(a, b);
      case '/':
        return divide(a, b);
      default:
        throw ArgumentError('Невідома операція: $op');
    }
  }
}
