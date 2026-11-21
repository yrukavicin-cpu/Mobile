import 'package:dart_basics_rukavitsyn/models/student.dart';
import 'package:dart_basics_rukavitsyn/utils/calculator.dart';
import 'package:dart_basics_rukavitsyn/utils/data_processor.dart';
import 'package:test/test.dart';

void main() {
  group('Calculator', () {
    final calc = Calculator();

    test('основні операції', () {
      expect(calc.add(2, 3), 5);
      expect(calc.subtract(2, 3), -1);
      expect(calc.multiply(4, 2.5), 10);
      expect(calc.divide(9, 3), 3);
      expect(calc.power(2, 8), 256);
      expect(calc.calculate(6, '*', 7), 42);
    });

    test('ділення на нуль', () {
      expect(() => calc.divide(1, 0), throwsArgumentError);
    });

    test('історія пишеться', () {
      expect(calc.history.isNotEmpty, true);
    });
  });

  group('DataProcessor', () {
    test('filterEvenNumbers', () {
      expect(DataProcessor.filterEvenNumbers([1, 2, 3, 4, 10]), [2, 4, 10]);
    });

    test('countWords', () {
      final r = DataProcessor.countWords('Dart dart, Flutter!');
      expect(r['dart'], 2);
      expect(r['flutter'], 1);
    });

    test('analyzeText', () {
      final r = DataProcessor.analyzeText('Привіт світ. Привіт!');
      expect(r['words'], 3);
      expect(r['sentences'], 2);
      expect(r['topWord'], 'привіт');
    });

    final s1 = Student(
        id: '1',
        firstName: 'A',
        lastName: 'A',
        birthDate: DateTime(2005),
        enrolledCourses: ['CS', 'MATH'],
        grades: {'CS': 90, 'MATH': 70},
        skills: ['dart']);
    final s2 = Student(
        id: '2',
        firstName: 'B',
        lastName: 'B',
        birthDate: DateTime(2004),
        enrolledCourses: ['CS', 'ENG'],
        grades: {'CS': 60},
        skills: ['dart', 'git']);

    test('findCommonCourses і getUniqueSkills', () {
      expect(DataProcessor.findCommonCourses([s1, s2]), {'CS'});
      expect(DataProcessor.getUniqueSkills([s1, s2]), {'dart', 'git'});
    });

    test('sortStudentsByGPA', () {
      final r = DataProcessor.sortStudentsByGPA([s2, s1]);
      expect(r.first['name'], 'A A');
    });

    test('calculateAverageGradesByCourse', () {
      expect(DataProcessor.calculateAverageGradesByCourse([s1, s2])['CS'], 75);
    });

    test('groupStudentsByYear', () {
      final g = DataProcessor.groupStudentsByYear([s1, s2]);
      expect(g.keys.toSet(), {'2005', '2004'});
    });

    test('parseStudentsCsv', () {
      const csv = 'id,firstName,lastName,birthDate,courses,grades,skills\n'
          'S1,Юрій,Р,2005-03-14,CS101;MATH201,CS101=95;MATH201=82,dart\n';
      final list = DataProcessor.parseStudentsCsv(csv);
      expect(list.length, 1);
      expect(list.first.grades['MATH201'], 82);
      expect(list.first.enrolledCourses, ['CS101', 'MATH201']);
    });
  });
}
