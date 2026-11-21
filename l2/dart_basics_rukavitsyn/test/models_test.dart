import 'package:dart_basics_rukavitsyn/models/course.dart';
import 'package:dart_basics_rukavitsyn/models/student.dart';
import 'package:dart_basics_rukavitsyn/models/university.dart';
import 'package:test/test.dart';

Student makeStudent(String id) =>
    Student(id: id, firstName: 'Іван', lastName: 'Петренко', birthDate: DateTime(2005, 1, 1));

void main() {
  group('Student', () {
    test('fullName', () {
      expect(makeStudent('S1').fullName, 'Іван Петренко');
    });

    test('gpa рахується як середнє', () {
      final s = makeStudent('S1');
      expect(s.gpa, 0);
      s.addGrade('A', 90);
      s.addGrade('B', 70);
      expect(s.gpa, 80);
    });

    test('addGrade не приймає оцінку > 100', () {
      expect(() => makeStudent('S1').addGrade('A', 150), throwsArgumentError);
    });

    test('getPassedCourses тільки >= 60', () {
      final s = makeStudent('S1');
      s.addGrade('A', 60);
      s.addGrade('B', 59);
      expect(s.getPassedCourses(), ['A']);
    });

    test('enrollInCourse без дублів', () {
      final s = makeStudent('S1');
      s.enrollInCourse('CS101');
      s.enrollInCourse('CS101');
      expect(s.enrolledCourses.length, 1);
    });

    test('toJson / fromJson', () {
      final s = makeStudent('S7');
      s.enrollInCourse('CS101');
      s.addGrade('CS101', 77);
      final copy = Student.fromJson(s.toJson());
      expect(copy.id, 'S7');
      expect(copy.grades['CS101'], 77);
      expect(copy.birthDate, s.birthDate);
    });
  });

  group('Course', () {
    test('canStudentEnroll перевіряє prerequisites', () {
      final c = Course(
          id: 'CS202', name: 'Mobile', description: '', credits: 5, instructor: 'X', prerequisites: ['CS101']);
      final s = makeStudent('S1');
      expect(c.hasPrerequisites(), true);
      expect(c.canStudentEnroll(s), false);
      s.addGrade('CS101', 80);
      expect(c.canStudentEnroll(s), true);
    });
  });

  group('University', () {
    test('add / find / remove', () {
      final u = University(name: 'U');
      u.addStudent(makeStudent('S1'));
      u.addStudent(makeStudent('S1')); // дубль
      u.addStudent(makeStudent('S2'));
      expect(u.students.length, 2);
      expect(u.findStudentById('S2'), isNotNull);
      u.removeStudent('S2');
      expect(u.findStudentById('S2'), isNull);
    });

    test('statistics', () {
      final u = University(name: 'U');
      final a = makeStudent('S1')..addGrade('X', 100);
      final b = makeStudent('S2')..addGrade('X', 50);
      u.addStudent(a);
      u.addStudent(b);
      final stats = u.generateStatistics();
      expect(stats['studentsCount'], 2);
      expect(stats['averageGpa'], 75);
      expect(stats['bestStudent'], a.fullName);
    });

    test('поліморфізм role', () {
      List<Person> people = [
        Professor(id: 'P', firstName: 'A', lastName: 'B', birthDate: DateTime(1980), department: 'CS', salary: 1),
        Staff(id: 'ST', firstName: 'C', lastName: 'D', birthDate: DateTime(1990), position: 'x'),
      ];
      expect(people.map((p) => p.role).toList(), ['Professor', 'Staff']);
    });
  });
}
