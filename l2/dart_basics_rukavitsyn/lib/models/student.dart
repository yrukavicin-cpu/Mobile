// Модель студента
class Student {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<String> enrolledCourses;
  final Map<String, double> grades;
  final List<String> skills; // додав сам, для getUniqueSkills

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    List<String>? enrolledCourses,
    Map<String, double>? grades,
    List<String>? skills,
  })  : enrolledCourses = enrolledCourses ?? [],
        grades = grades ?? {},
        skills = skills ?? [];

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int result = now.year - birthDate.year;
    // якщо др в цьому році ще не було
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      result--;
    }
    return result;
  }

  // середній бал по всіх оцінках
  double get gpa {
    if (grades.isEmpty) return 0;
    double sum = 0;
    for (var g in grades.values) {
      sum += g;
    }
    return sum / grades.length;
  }

  void enrollInCourse(String courseId) {
    if (!enrolledCourses.contains(courseId)) {
      enrolledCourses.add(courseId);
    }
  }

  void addGrade(String courseId, double grade) {
    if (grade < 0 || grade > 100) {
      throw ArgumentError('Оцінка має бути від 0 до 100, а не $grade');
    }
    grades[courseId] = grade;
  }

  List<String> getPassedCourses() {
    return grades.entries
        .where((e) => e.value >= 60)
        .map((e) => e.key)
        .toList();
  }

  @override
  String toString() {
    return 'Student($id, $fullName, вік: $age, GPA: ${gpa.toStringAsFixed(1)})';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'enrolledCourses': enrolledCourses,
      'grades': grades,
      'skills': skills,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    Map<String, double> grades = {};
    if (json['grades'] != null) {
      (json['grades'] as Map<String, dynamic>).forEach((key, value) {
        grades[key] = (value as num).toDouble();
      });
    }
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: DateTime.parse(json['birthDate']),
      enrolledCourses: List<String>.from(json['enrolledCourses'] ?? []),
      grades: grades,
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}
