import 'dart:io';

import 'package:dart_basics_rukavitsyn/models/university.dart';
import 'package:dart_basics_rukavitsyn/utils/data_processor.dart';

void main() {
  print('=== Dart Collections & Data Processing Demo ===');

  demonstrateLists();
  demonstrateSets();
  demonstrateMaps();
  demonstrateAdvancedOperations();
  analyzeCsv();
  performanceTest();
}

void demonstrateLists() {
  print('\n--- Lists ---');
  List<int> nums = [42, 7, 19, 3, 88, 21, 56, 10];
  print('Список: $nums');
  print('Парні: ${DataProcessor.filterEvenNumbers(nums)}');

  final sorted = List<int>.from(nums)..sort();
  print('Відсортований: $sorted');
  print('За спаданням: ${sorted.reversed.toList()}');
  print('map (x2): ${nums.map((n) => n * 2).toList()}');
  print('where (>20): ${nums.where((n) => n > 20).toList()}');
  print('fold (сума): ${nums.fold(0, (a, b) => a + b)}');
  print('reduce (мін): ${nums.reduce((a, b) => a < b ? a : b)}');
  print('any > 80: ${nums.any((n) => n > 80)}, every > 0: ${nums.every((n) => n > 0)}');
  print('indexOf(19): ${nums.indexOf(19)}, sublist(2,5): ${nums.sublist(2, 5)}');
}

void demonstrateSets() {
  print('\n--- Sets ---');
  Set<String> group1 = {'Dart', 'Java', 'Python', 'C++'};
  Set<String> group2 = {'Dart', 'Kotlin', 'Python', 'Swift'};
  print('group1: $group1');
  print('group2: $group2');
  print('union: ${group1.union(group2)}');
  print('intersection: ${group1.intersection(group2)}');
  print('difference (1-2): ${group1.difference(group2)}');
  group1.add('Dart'); // дубль не додасться
  print('після add("Dart") довжина все ще ${group1.length}');
}

void demonstrateMaps() {
  print('\n--- Maps ---');
  Map<String, double> prices = {'кава': 55, 'чай': 35, 'круасан': 70};
  prices['сік'] = 48;
  prices.update('кава', (v) => v + 5);
  print('Ціни: $prices');

  final expensive = Map.fromEntries(prices.entries.where((e) => e.value > 50));
  print('Дорожче 50: $expensive');

  final upper = prices.map((k, v) => MapEntry(k.toUpperCase(), v.round()));
  print('Трансформація: $upper');

  // групування слів по першій букві
  final words = ['яблуко', 'банан', 'ягода', 'бульба', 'апельсин'];
  Map<String, List<String>> byLetter = {};
  for (var w in words) {
    byLetter.putIfAbsent(w[0], () => []).add(w);
  }
  print('Групування по першій букві: $byLetter');
}

void demonstrateAdvancedOperations() {
  print('\n--- Складніші операції ---');
  // вкладені колекції
  Map<String, List<Map<String, dynamic>>> groups = {
    'аІк-43': [
      {'name': 'Юрій', 'score': 91},
      {'name': 'Олена', 'score': 78},
    ],
    'аІк-42': [
      {'name': 'Максим', 'score': 65},
      {'name': 'Ірина', 'score': 88},
      {'name': 'Тарас', 'score': 72},
    ],
  };
  groups.forEach((group, list) {
    final avg = list.map((s) => s['score'] as int).reduce((a, b) => a + b) / list.length;
    print('$group: ${list.length} студ., середній бал ${avg.toStringAsFixed(1)}');
  });

  // flatten + кастомне сортування (спочатку за балом, потім за імям)
  final all = groups.values.expand((l) => l).toList();
  all.sort((a, b) {
    final c = (b['score'] as int).compareTo(a['score'] as int);
    return c != 0 ? c : (a['name'] as String).compareTo(b['name'] as String);
  });
  print('Всі за балом: ${all.map((s) => '${s['name']}(${s['score']})').join(', ')}');
}

// аналізатор даних з CSV файлу
void analyzeCsv() {
  print('\n=== Аналіз data/students.csv ===');
  final file = File('data/students.csv');
  if (!file.existsSync()) {
    print('Файл не знайдено, запускайте з папки проекту');
    return;
  }
  final students = DataProcessor.parseStudentsCsv(file.readAsStringSync());
  print('Завантажено студентів: ${students.length}');

  final uni = University(name: 'Тестовий універ', students: students);
  final sb = StringBuffer();
  sb.writeln('ЗВІТ ПО СТУДЕНТАХ (${DateTime.now().toString().substring(0, 16)})');
  sb.writeln('Кількість студентів: ${students.length}');

  sb.writeln('\nРейтинг за GPA:');
  final rating = DataProcessor.sortStudentsByGPA(students);
  for (var i = 0; i < rating.length; i++) {
    sb.writeln('  ${i + 1}. ${rating[i]['name']} - ${rating[i]['gpa']}');
  }

  sb.writeln('\nСередні оцінки по курсах:');
  DataProcessor.calculateAverageGradesByCourse(students).forEach((course, avg) {
    sb.writeln('  $course: ${avg.toStringAsFixed(1)}');
  });

  sb.writeln('\nГрупи за роком народження:');
  final byYear = DataProcessor.groupStudentsByYear(students);
  final years = byYear.keys.toList()..sort();
  for (var y in years) {
    sb.writeln('  $y: ${byYear[y]!.map((s) => s.firstName).join(', ')}');
  }

  sb.writeln('\nУнікальні навички: ${DataProcessor.getUniqueSkills(students).join(', ')}');
  sb.writeln('Спільні курси для всіх: ${DataProcessor.findCommonCourses(students)}');

  sb.writeln('\nДетальний звіт:');
  for (var r in DataProcessor.generateReport(uni)) {
    sb.writeln('  ${r['name']}: вік ${r['age']}, курсів ${r['courses']}, '
        'здано ${r['passed']}, GPA ${r['gpa']} - ${r['status']}');
  }

  print(sb.toString());
  File('data/report.txt').writeAsStringSync(sb.toString());
  print('Звіт збережено у data/report.txt');
}

// замір швидкості List vs Set
void performanceTest() {
  print('\n=== Performance ===');
  const n = 100000;
  final list = List<int>.generate(n, (i) => i);
  final set = list.toSet();

  final sw = Stopwatch()..start();
  int found = 0;
  for (var i = 0; i < 1000; i++) {
    if (list.contains(n - i)) found++;
  }
  sw.stop();
  print('List.contains x1000: ${sw.elapsedMicroseconds} мкс (знайдено $found)');

  sw
    ..reset()
    ..start();
  found = 0;
  for (var i = 0; i < 1000; i++) {
    if (set.contains(n - i)) found++;
  }
  sw.stop();
  print('Set.contains x1000: ${sw.elapsedMicroseconds} мкс (знайдено $found)');

  final toSort = List<int>.generate(n, (i) => (i * 7919) % n);
  sw
    ..reset()
    ..start();
  toSort.sort();
  sw.stop();
  print('Сортування $n елементів: ${sw.elapsedMilliseconds} мс');
}
