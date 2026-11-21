import 'course.dart';
import 'student.dart';

abstract class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  String get fullName;
  int get age;
  String get role; // abstract getter
}

class Professor extends Person {
  final String department;
  final List<String> taughtCourses;
  final double salary;

  Professor({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required this.department,
    required this.salary,
    List<String>? taughtCourses,
  }) : taughtCourses = taughtCourses ?? [];

  @override
  String get role => 'Professor';

  @override
  String get fullName => 'проф. $firstName $lastName';

  @override
  int get age {
    final now = DateTime.now();
    int result = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      result--;
    }
    return result;
  }

  void addCourse(String courseId) {
    if (!taughtCourses.contains(courseId)) {
      taughtCourses.add(courseId);
    }
  }

  double get yearSalary => salary * 12;

  @override
  String toString() => '$fullName ($department), курси: $taughtCourses';
}

// ще один нащадок Person щоб показати поліморфізм
class Staff extends Person {
  final String position;

  Staff({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required this.position,
  });

  @override
  String get role => 'Staff';

  @override
  String get fullName => '$firstName $lastName';

  @override
  int get age => DateTime.now().year - birthDate.year; // приблизно

  @override
  String toString() => '$fullName - $position';
}

class University {
  final String name;
  final List<Student> students;
  final List<Professor> professors;
  final List<Course> courses;

  University({
    required this.name,
    List<Student>? students,
    List<Professor>? professors,
    List<Course>? courses,
  })  : students = students ?? [],
        professors = professors ?? [],
        courses = courses ?? [];

  void addStudent(Student student) {
    if (findStudentById(student.id) != null) {
      print('Студент з id ${student.id} вже є');
      return;
    }
    students.add(student);
  }

  void removeStudent(String studentId) {
    students.removeWhere((s) => s.id == studentId);
  }

  Student? findStudentById(String id) {
    for (var s in students) {
      if (s.id == id) return s;
    }
    return null;
  }

  void addProfessor(Professor professor) {
    professors.add(professor);
  }

  void addCourse(Course course) {
    courses.add(course);
  }

  Course? findCourseById(String id) {
    for (var c in courses) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<Student> getStudentsByCourse(String courseId) {
    return students.where((s) => s.enrolledCourses.contains(courseId)).toList();
  }

  // курси на які студент ще не записаний і може записатись
  List<Course> getAvailableCoursesForStudent(String studentId) {
    final student = findStudentById(studentId);
    if (student == null) return [];
    return courses
        .where((c) =>
            !student.enrolledCourses.contains(c.id) &&
            c.canStudentEnroll(student))
        .toList();
  }

  Map<String, dynamic> generateStatistics() {
    double totalGpa = 0;
    Student? best;
    for (var s in students) {
      totalGpa += s.gpa;
      if (best == null || s.gpa > best.gpa) {
        best = s;
      }
    }
    return {
      'university': name,
      'studentsCount': students.length,
      'professorsCount': professors.length,
      'coursesCount': courses.length,
      'averageGpa': students.isEmpty ? 0 : totalGpa / students.length,
      'bestStudent': best?.fullName,
    };
  }
}
