import 'student.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final int credits;
  final String instructor;
  final List<String> prerequisites;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
    required this.instructor,
    List<String>? prerequisites,
  }) : prerequisites = prerequisites ?? [];

  bool hasPrerequisites() {
    return prerequisites.isNotEmpty;
  }

  // студент може записатись якщо здав всі попередні курси
  bool canStudentEnroll(Student student) {
    final passed = student.getPassedCourses();
    for (var p in prerequisites) {
      if (!passed.contains(p)) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    return 'Course($id: $name, $credits кредитів, викладач: $instructor)';
  }
}
