import 'package:dart_basics_rukavitsyn/utils/calculator.dart';

void main() {
  print('=== Dart Variables & Types Demo ===');

  demonstrateNumbers();
  demonstrateStrings();
  demonstrateBooleans();
  demonstrateCollections();
  demonstrateNullSafety();
  calculatorDemo();
}

void demonstrateNumbers() {
  print('\n--- Числа ---');
  int a = 17;
  double b = 4.5;
  num c = 10; // num може бути і int і double
  var d = 3; // тип виводиться сам (int)

  print('int a = $a, double b = $b, num c = $c, var d = $d');
  print('a + b = ${a + b}');
  print('a / 5 = ${a / 5}'); // звичайне ділення дає double
  print('a ~/ 5 = ${a ~/ 5}'); // цілочисельне
  print('a % 5 = ${a % 5}');
  print('b * 2 = ${b * 2}');

  // перетворення типів
  String s = '42';
  int fromString = int.parse(s);
  double fromString2 = double.parse('3.14');
  print('int.parse("42") = $fromString, double.parse("3.14") = $fromString2');
  print('17.toDouble() = ${a.toDouble()}, 4.5.toInt() = ${b.toInt()}');
  print('4.5.round() = ${b.round()}, pi до 2 знаків = ${3.14159.toStringAsFixed(2)}');
  print('int.tryParse("abc") = ${int.tryParse('abc')}');
  c = 2.5;
  print('тепер c = $c (${c.runtimeType})');
}

void demonstrateStrings() {
  print('\n--- Рядки ---');
  String name = 'Юрій';
  String group = "аІк-43";
  print('Привіт, $name з групи $group!');
  print('Довжина імені: ${name.length}');

  String multi = '''
Це багаторядковий
рядок у Dart''';
  print(multi);

  print('Екранування: \'лапки\', \\ слеш, табуляція:\tось');
  print(r'raw рядок: \n не переносить');

  String text = '  Dart is Fun  ';
  print('trim: "${text.trim()}"');
  print('upper: ${text.trim().toUpperCase()}');
  print('contains("Fun"): ${text.contains('Fun')}');
  print('replaceAll: ${text.trim().replaceAll('Fun', 'Cool')}');
  print('split: ${text.trim().split(' ')}');
  print('substring(2, 6): ${text.trim().substring(2, 6)}');
  print('конкатенація: ${'abc' + 'def'}');
}

void demonstrateBooleans() {
  print('\n--- Boolean ---');
  int grade = 75;
  bool isStudent = grade > 0;
  bool hasDebt = grade < 60;

  print('isStudent && !hasDebt = ${isStudent && !hasDebt}');
  print('isStudent || hasDebt = ${isStudent || hasDebt}');
  print('grade > 60: ${grade > 60}, grade == 100: ${grade == 100}');

  String result = grade >= 60 ? 'здав' : 'не здав';
  print('Тернарний оператор: $result');

  if (grade >= 90) {
    print('Оцінка A');
  } else if (grade >= 75) {
    print('Оцінка B');
  } else {
    print('Оцінка C або нижче');
  }
}

void demonstrateCollections() {
  print('\n--- Колекції ---');
  List<int> numbers = [5, 3, 8, 1];
  numbers.add(10);
  numbers.sort();
  print('List: $numbers, перший: ${numbers.first}, довжина: ${numbers.length}');

  Set<String> langs = ['dart', 'java', 'dart', 'kotlin'].toSet();
  print('Set (без дублікатів): $langs');

  Map<String, int> ages = {'Олег': 19, 'Марія': 20};
  ages['Іван'] = 18;
  print('Map: $ages');
  print('ключі: ${ages.keys}, значення: ${ages.values}');
  print('є Марія? ${ages.containsKey('Марія')}');
}

void demonstrateNullSafety() {
  print('\n--- Null safety ---');
  String? nickname = findNickname('Юрій'); // може бути null
  print('nickname = $nickname');
  print('nickname ?? "немає" = ${nickname ?? 'немає'}');
  print('nickname?.length = ${nickname?.length}');

  nickname ??= 'yura';
  print('після ??= : $nickname, довжина ${nickname.length}');

  String? maybe = findNickname('admin');
  print('оператор ! : ${maybe!.toUpperCase()}'); // тут я знаю що не null

  late String lateVar; // ініціалізую пізніше
  lateVar = 'late змінна';
  print(lateVar);

  printInfo(name: 'Юрій'); // required параметр
  printInfo(name: 'Олена', age: 20);
}

// повертає null якщо ніка нема
String? findNickname(String name) {
  if (name == 'admin') return 'root';
  return null;
}

void printInfo({required String name, int? age}) {
  print('Ім\'я: $name, вік: ${age ?? 'невідомо'}');
}

void calculatorDemo() {
  print('\n--- Калькулятор ---');
  final calc = Calculator();
  print('12 + 5 = ${calc.add(12, 5)}');
  print('12 - 5 = ${calc.subtract(12, 5)}');
  print('12 * 5 = ${calc.multiply(12, 5)}');
  print('12 / 5 = ${calc.divide(12, 5)}');
  print('2 ^ 10 = ${calc.power(2, 10)}');
  print('17 % 5 = ${calc.mod(17, 5)}');
  print('calculate(7, "*", 6) = ${calc.calculate(7, '*', 6)}');
  try {
    calc.divide(1, 0);
  } catch (e) {
    print('Помилка: $e');
  }
  print('Історія операцій:');
  for (var h in calc.history) {
    print('  $h');
  }
}
