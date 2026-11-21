import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_basics_rukavitsyn/models/student.dart';

void main() async {
  print('=== Dart Async Programming Demo ===');

  await demonstrateFutures();
  await demonstrateStreams();
  await demonstrateFileOperations();
}

// симуляція запиту до API
Future<String> fetchStudentData(String studentId) async {
  await Future.delayed(Duration(seconds: 1));
  if (studentId.isEmpty) {
    throw Exception('Порожній id');
  }
  return 'Дані студента $studentId';
}

Future<List<Student>> loadStudentsFromFile(String filename) async {
  final content = await File(filename).readAsString();
  final List<dynamic> data = jsonDecode(content);
  return data.map((e) => Student.fromJson(e)).toList();
}

Future<void> saveStudentsToFile(List<Student> students, String filename) async {
  final json = JsonEncoder.withIndent('  ').convert(students.map((s) => s.toJson()).toList());
  await File(filename).writeAsString(json);
}

Stream<Student> studentStream() async* {
  final students = await loadStudentsFromFile('data/students.json');
  for (var s in students) {
    await Future.delayed(Duration(milliseconds: 200));
    yield s;
  }
}

Future<void> demonstrateFutures() async {
  print('\n--- Futures ---');
  final one = await fetchStudentData('S1');
  print(one);

  // послідовно vs паралельно
  final sw = Stopwatch()..start();
  await fetchStudentData('S1');
  await fetchStudentData('S2');
  await fetchStudentData('S3');
  sw.stop();
  final seq = sw.elapsedMilliseconds;
  print('Послідовно 3 запити: $seq мс');

  sw
    ..reset()
    ..start();
  final results = await Future.wait([
    fetchStudentData('S1'),
    fetchStudentData('S2'),
    fetchStudentData('S3'),
  ]);
  sw.stop();
  print('Future.wait 3 запити: ${sw.elapsedMilliseconds} мс -> $results');
  print('Паралельно швидше приблизно в ${(seq / sw.elapsedMilliseconds).toStringAsFixed(1)} рази');

  // обробка помилок
  try {
    await fetchStudentData('');
  } catch (e) {
    print('Помилка спіймана: $e');
  }

  // таймаут
  try {
    await fetchStudentData('S9').timeout(Duration(milliseconds: 300));
  } on TimeoutException {
    print('Таймаут! запит довше 300 мс');
  }

  // then замість await
  await fetchStudentData('S5').then((v) => print('через then: $v'));
}

Future<void> demonstrateStreams() async {
  print('\n--- Streams ---');
  print('Студенти по одному (await for):');
  await for (var s in studentStream()) {
    print('  отримано: ${s.fullName}');
  }

  print('Тільки GPA >= 80 (where + map + listen):');
  final done = Completer<void>();
  studentStream()
      .where((s) => s.gpa >= 80)
      .map((s) => '${s.fullName} (${s.gpa.toStringAsFixed(1)})')
      .listen((text) => print('  $text'), onDone: () => done.complete());
  await done.future;

  // стрім з periodic
  final ticks = await Stream.periodic(Duration(milliseconds: 100), (i) => i + 1).take(5).toList();
  print('Stream.periodic: $ticks');
}

Future<void> demonstrateFileOperations() async {
  print('\n--- Робота з файлами ---');
  final sw = Stopwatch()..start();
  final students = await loadStudentsFromFile('data/students.json');
  print('Прочитано ${students.length} студентів з data/students.json (${sw.elapsedMilliseconds} мс)');

  // обробка
  students.sort((a, b) => b.gpa.compareTo(a.gpa));
  final good = students.where((s) => s.gpa >= 75).toList();
  final avg = students.map((s) => s.gpa).reduce((a, b) => a + b) / students.length;
  print('Середній GPA: ${avg.toStringAsFixed(2)}');
  print('GPA >= 75: ${good.map((s) => s.firstName).join(', ')}');

  await saveStudentsToFile(good, 'data/top_students.json');
  print('Збережено в data/top_students.json');

  // кілька файлів паралельно
  sw
    ..reset()
    ..start();
  await Future.wait([
    File('data/students.json').readAsString(),
    File('data/students.csv').readAsString(),
    File('data/top_students.json').readAsString(),
  ]);
  print('3 файли паралельно прочитано за ${sw.elapsedMilliseconds} мс');

  // файл якого нема
  try {
    await loadStudentsFromFile('data/nema_takogo.json');
  } on FileSystemException catch (e) {
    print('Помилка файлу: ${e.message} (${e.path})');
  }
}
