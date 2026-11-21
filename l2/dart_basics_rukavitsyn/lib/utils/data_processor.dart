import '../models/student.dart';
import '../models/university.dart';

class DataProcessor {
  // ---------- Lists ----------
  static List<int> filterEvenNumbers(List<int> numbers) {
    return numbers.where((n) => n % 2 == 0).toList();
  }

  // скільки разів кожне слово зустрічається
  static Map<String, int> countWords(String text) {
    Map<String, int> result = {};
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-zа-яіїєґ0-9'\s]"), ' ')
        .split(RegExp(r'\s+'));
    for (var w in words) {
      if (w.isEmpty) continue;
      result[w] = (result[w] ?? 0) + 1;
    }
    return result;
  }

  static List<Map<String, dynamic>> sortStudentsByGPA(List<Student> students) {
    final sorted = List<Student>.from(students);
    sorted.sort((a, b) => b.gpa.compareTo(a.gpa));
    return sorted
        .map((s) => {'name': s.fullName, 'gpa': double.parse(s.gpa.toStringAsFixed(2))})
        .toList();
  }

  // ---------- Sets ----------
  static Set<String> getUniqueSkills(List<Student> students) {
    Set<String> skills = {};
    for (var s in students) {
      skills.addAll(s.skills);
    }
    return skills;
  }

  // курси на які записані ВСІ студенти
  static Set<String> findCommonCourses(List<Student> students) {
    if (students.isEmpty) return {};
    Set<String> common = students.first.enrolledCourses.toSet();
    for (var s in students.skip(1)) {
      common = common.intersection(s.enrolledCourses.toSet());
    }
    return common;
  }

  // ---------- Maps ----------
  // групую по року народження
  static Map<String, List<Student>> groupStudentsByYear(List<Student> students) {
    Map<String, List<Student>> groups = {};
    for (var s in students) {
      final key = s.birthDate.year.toString();
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(s);
    }
    return groups;
  }

  static Map<String, double> calculateAverageGradesByCourse(
      List<Student> students) {
    Map<String, List<double>> all = {};
    for (var s in students) {
      s.grades.forEach((course, grade) {
        all.putIfAbsent(course, () => []).add(grade);
      });
    }
    return all.map((course, list) =>
        MapEntry(course, list.reduce((a, b) => a + b) / list.length));
  }

  // ---------- Advanced ----------
  static List<Map<String, dynamic>> generateReport(University university) {
    List<Map<String, dynamic>> report = [];
    for (var s in university.students) {
      report.add({
        'id': s.id,
        'name': s.fullName,
        'age': s.age,
        'courses': s.enrolledCourses.length,
        'passed': s.getPassedCourses().length,
        'gpa': double.parse(s.gpa.toStringAsFixed(2)),
        'status': s.gpa >= 90
            ? 'відмінник'
            : s.gpa >= 60
                ? 'норм'
                : 'боржник',
      });
    }
    report.sort((a, b) => (b['gpa'] as double).compareTo(a['gpa'] as double));
    return report;
  }

  // текстовий аналізатор для task2
  static Map<String, dynamic> analyzeText(String text) {
    final words = countWords(text);
    String? topWord;
    int topCount = 0;
    words.forEach((w, c) {
      if (c > topCount) {
        topWord = w;
        topCount = c;
      }
    });
    return {
      'symbols': text.length,
      'symbolsNoSpaces': text.replaceAll(RegExp(r'\s'), '').length,
      'words': words.values.fold(0, (sum, c) => sum + c),
      'uniqueWords': words.length,
      'sentences': text.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length,
      'topWord': topWord,
      'topWordCount': topCount,
    };
  }

  // парсинг csv: id,firstName,lastName,birthDate,courses,grades,skills
  // courses і skills через ; , grades як CS101=85;MATH201=70
  static List<Student> parseStudentsCsv(String csv) {
    List<Student> result = [];
    final lines = csv.trim().split('\n');
    for (var line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      final p = line.trim().split(',');
      Map<String, double> grades = {};
      if (p[5].isNotEmpty) {
        for (var g in p[5].split(';')) {
          final kv = g.split('=');
          grades[kv[0]] = double.parse(kv[1]);
        }
      }
      result.add(Student(
        id: p[0],
        firstName: p[1],
        lastName: p[2],
        birthDate: DateTime.parse(p[3]),
        enrolledCourses: p[4].isEmpty ? [] : p[4].split(';'),
        grades: grades,
        skills: p[6].isEmpty ? [] : p[6].split(';'),
      ));
    }
    return result;
  }
}
