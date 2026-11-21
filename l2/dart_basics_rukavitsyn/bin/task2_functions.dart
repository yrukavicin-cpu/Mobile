import 'package:dart_basics_rukavitsyn/utils/data_processor.dart';

void main() {
  print('=== Dart Functions Demo ===');

  testBasicFunctions();
  testAdvancedFunctions();
  testFunctionalProgramming();
  textAnalyzerDemo();
}

// 1. Звичайні функції
int calculateSum(int a, int b) {
  return a + b;
}

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) return 0;
  double sum = 0;
  for (var n in numbers) {
    sum += n;
  }
  return sum / numbers.length;
}

// 2. optional та named параметри
String formatName(String firstName, String lastName,
    {String? middleName, bool uppercase = false}) {
  String result = middleName == null
      ? '$firstName $lastName'
      : '$firstName $middleName $lastName';
  return uppercase ? result.toUpperCase() : result;
}

// позиційний необов'язковий параметр
String greet(String name, [String greeting = 'Привіт']) => '$greeting, $name!';

// 4. Рекурсія
int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
  if (n < 0) throw ArgumentError('n не може бути відємним');
  if (n == 0) return 1;
  return n * factorial(n - 1);
}

void testBasicFunctions() {
  print('\n--- Звичайні функції ---');
  print('calculateSum(3, 4) = ${calculateSum(3, 4)}');
  print('calculateAverage([90, 75, 60]) = ${calculateAverage([90, 75, 60])}');
  print('fibonacci(10) = ${fibonacci(10)}');
  print('factorial(5) = ${factorial(5)}');
  // print(factorial(-1)); // кидає помилку
}

void testAdvancedFunctions() {
  print('\n--- Named / optional параметри ---');
  print(formatName('Юрій', 'Рукавіцин'));
  print(formatName('Тарас', 'Шевченко', middleName: 'Григорович'));
  print(formatName('Леся', 'Українка', uppercase: true));
  print(greet('Олег'));
  print(greet('Олег', 'Добрий день'));

  // функція як параметр
  int applyTwice(int Function(int) f, int x) => f(f(x));
  print('applyTwice(x*3, 2) = ${applyTwice((x) => x * 3, 2)}');
}

// 3. Anonymous functions та closures
void testFunctionalProgramming() {
  print('\n--- Функціональне програмування ---');
  List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  var squares = nums.map((n) => n * n).toList();
  var even = nums.where((n) => n.isEven).toList();
  var sum = nums.fold(0, (acc, n) => acc + n);
  var max = nums.reduce((a, b) => a > b ? a : b);
  print('map (квадрати): $squares');
  print('where (парні): $even');
  print('fold (сума): $sum');
  print('reduce (макс): $max');

  // анонімна функція в forEach
  nums.take(3).forEach((n) {
    print('  елемент $n');
  });

  // closure - функція запамятовує змінну count
  Function makeCounter() {
    int count = 0;
    return () {
      count++;
      return count;
    };
  }

  var counter1 = makeCounter();
  var counter2 = makeCounter();
  counter1();
  counter1();
  print('counter1 викликали 3 рази: ${counter1()}');
  print('counter2 окремий: ${counter2()}');

  // scope
  var multiplier = 10;
  var multiply = (int x) => x * multiplier;
  multiplier = 100; // замикання бачить нове значення
  print('multiply(2) = ${multiply(2)}');
}

void textAnalyzerDemo() {
  print('\n--- Текстовий аналізатор ---');
  const text = '''Dart - це мова програмування від Google. Dart використовується у Flutter.
Flutter дозволяє писати мобільні застосунки! Це зручно, і це швидко?''';

  final info = DataProcessor.analyzeText(text);
  print('Текст:\n$text\n');
  print('Символів: ${info['symbols']}');
  print('Символів без пробілів: ${info['symbolsNoSpaces']}');
  print('Слів: ${info['words']}');
  print('Унікальних слів: ${info['uniqueWords']}');
  print('Речень: ${info['sentences']}');
  print('Найчастіше слово: "${info['topWord']}" (${info['topWordCount']} рази)');

  final counts = DataProcessor.countWords(text);
  final top = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  print('Топ-3 слова: ${top.take(3).map((e) => '${e.key}=${e.value}').join(', ')}');
}
