import 'package:dart_basics_rukavitsyn/models/course.dart';
import 'package:dart_basics_rukavitsyn/models/student.dart';
import 'package:dart_basics_rukavitsyn/models/university.dart';

void main() {
  print('=== University Management System Demo ===');
  runUniversityDemo();
}

void runUniversityDemo() {
  // 1. університет
  final uni = University(name: 'Мій університет');
  print('\n1) Створено університет: ${uni.name}');

  // 2. студенти та професори
  uni.addStudent(Student(
      id: 'S1', firstName: 'Юрій', lastName: 'Рукавіцин', birthDate: DateTime(2005, 3, 14)));
  uni.addStudent(Student(
      id: 'S2', firstName: 'Олена', lastName: 'Коваль', birthDate: DateTime(2004, 11, 2)));
  uni.addStudent(Student(
      id: 'S3', firstName: 'Максим', lastName: 'Бондар', birthDate: DateTime(2005, 7, 21)));
  uni.addStudent(Student(
      id: 'S4', firstName: 'Ірина', lastName: 'Мельник', birthDate: DateTime(2006, 1, 9)));
  uni.addStudent(Student(
      id: 'S1', firstName: 'Дубль', lastName: 'Дубль', birthDate: DateTime(2000))); // не додасться

  final prof1 = Professor(
      id: 'P1',
      firstName: 'Петро',
      lastName: 'Іваненко',
      birthDate: DateTime(1975, 5, 5),
      department: 'Комп\'ютерні науки',
      salary: 30000);
  final prof2 = Professor(
      id: 'P2',
      firstName: 'Наталія',
      lastName: 'Сидоренко',
      birthDate: DateTime(1982, 9, 30),
      department: 'Математика',
      salary: 28000);
  uni.addProfessor(prof1);
  uni.addProfessor(prof2);
  print('2) Студентів: ${uni.students.length}, професорів: ${uni.professors.length}');

  // 3. курси
  uni.addCourse(Course(
      id: 'CS101', name: 'Основи програмування', description: 'Вступ', credits: 5, instructor: prof1.fullName));
  uni.addCourse(Course(
      id: 'MATH201', name: 'Вища математика', description: 'Матан', credits: 4, instructor: prof2.fullName));
  uni.addCourse(Course(
      id: 'CS202',
      name: 'Мобільна розробка',
      description: 'Flutter',
      credits: 5,
      instructor: prof1.fullName,
      prerequisites: ['CS101']));
  prof1.addCourse('CS101');
  prof1.addCourse('CS202');
  prof2.addCourse('MATH201');
  print('3) Курси:');
  for (var c in uni.courses) {
    print('   $c${c.hasPrerequisites() ? ' (потрібно: ${c.prerequisites.join(', ')})' : ''}');
  }

  // 4. запис на курси
  for (var s in uni.students) {
    s.enrollInCourse('CS101');
    s.enrollInCourse('MATH201');
  }
  print('4) Всі записані на CS101 і MATH201');

  // 5. оцінки
  uni.findStudentById('S1')!.addGrade('CS101', 95);
  uni.findStudentById('S1')!.addGrade('MATH201', 82);
  uni.findStudentById('S2')!.addGrade('CS101', 74);
  uni.findStudentById('S2')!.addGrade('MATH201', 91);
  uni.findStudentById('S3')!.addGrade('CS101', 55);
  uni.findStudentById('S3')!.addGrade('MATH201', 61);
  uni.findStudentById('S4')!.addGrade('CS101', 88);
  uni.findStudentById('S4')!.addGrade('MATH201', 45);
  try {
    uni.findStudentById('S4')!.addGrade('CS101', 120);
  } catch (e) {
    print('   помилка: $e');
  }
  print('5) Оцінки поставлено:');
  for (var s in uni.students) {
    print('   $s, здані: ${s.getPassedCourses()}');
  }

  // хто може піти на CS202
  final cs202 = uni.findCourseById('CS202')!;
  for (var s in uni.students) {
    final ok = cs202.canStudentEnroll(s);
    print('   ${s.fullName} -> CS202: ${ok ? 'можна' : 'ні, не здав CS101'}');
    if (ok) s.enrollInCourse('CS202');
  }
  print('   на CS202 записані: ${uni.getStudentsByCourse('CS202').map((s) => s.firstName).toList()}');
  print('   доступні курси для S3: ${uni.getAvailableCoursesForStudent('S3')}');

  // поліморфізм
  print('\nПоліморфізм (List<Person>):');
  List<Person> people = [
    prof1,
    prof2,
    Staff(id: 'ST1', firstName: 'Галина', lastName: 'Петрівна', birthDate: DateTime(1968, 2, 2), position: 'методист'),
  ];
  for (var p in people) {
    print('   ${p.role}: ${p.fullName}, ${p.age} років');
  }
  print('   річна зарплата ${prof1.fullName}: ${prof1.yearSalary}');

  // видалення
  uni.removeStudent('S3');
  print('\nВидалили S3, залишилось студентів: ${uni.students.length}');
  print('findStudentById("S3") = ${uni.findStudentById('S3')}');

  // 6. статистика
  print('\n6) Статистика:');
  uni.generateStatistics().forEach((key, value) {
    print('   $key: ${value is double ? value.toStringAsFixed(2) : value}');
  });

  // print(uni.students.first.toJson());
}
