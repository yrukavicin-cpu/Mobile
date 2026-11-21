# Практична робота 4 - Основи мови Dart

Рукавіцин Юрій, аІк-43

Консольний проект на Dart: змінні і типи, функції, ООП (система університету), колекції + аналіз даних з csv, асинхронність і робота з файлами.

## Встановлення Dart

Потрібен Dart SDK 3.0+. Я ставив разом з Flutter (`brew install --cask flutter`), Dart там вже є. Окремо можна так:

```
brew tap dart-lang/dart
brew install dart
```

Перевірка: `dart --version`

## Запуск

Всі команди з папки проекту (бо програми читають файли з `data/`):

```
dart pub get

dart run bin/task1_variables.dart     # типи даних, null safety, калькулятор
dart run bin/task2_functions.dart     # функції, рекурсія, замикання, аналізатор тексту
dart run bin/task3_classes.dart       # система управління університетом
dart run bin/task4_collections.dart   # колекції, аналіз data/students.csv, performance
dart run bin/task5_async.dart         # Future, Stream, читання/запис json
```

task4 зберігає звіт у `data/report.txt`, task5 зберігає `data/top_students.json`.

## Структура

```
bin/          - 5 програм, по одній на завдання
lib/models/   - Student, Course, University (+ Person, Professor, Staff)
lib/utils/    - Calculator, DataProcessor
test/         - тести моделей і утиліт
data/         - тестові дані (csv, json) і згенеровані звіти
```

## Приклад використання класів

```dart
final uni = University(name: 'Мій університет');

final s = Student(id: 'S1', firstName: 'Юрій', lastName: 'Рукавіцин', birthDate: DateTime(2005, 3, 14));
uni.addStudent(s);

s.enrollInCourse('CS101');
s.addGrade('CS101', 95);
print(s.gpa);                 // 95.0
print(s.getPassedCourses());  // [CS101]

final course = Course(id: 'CS202', name: 'Мобільна розробка', description: 'Flutter',
    credits: 5, instructor: 'Іваненко', prerequisites: ['CS101']);
print(course.canStudentEnroll(s));  // true

print(uni.generateStatistics());
```

## Тести

```
dart test
```

21 тест, всі проходять. Покритя рахував через пакет coverage:

```
dart run coverage:test_with_coverage
```

Вийшло ~71% рядків у `lib/` (student 84%, data_processor 83%, calculator 74%, course 70%, university 44% - для професора і стафа тестів мало).

## Скріншоти

Скріншоти виконання програм і тестів лежать в папці `screenshots/`.

## Що було складно

- В Dart 3 null safety - спочатку analyzer лаявся що код "dead code", бо він сам бачить що змінна null. Довелось брати значення з функції.
- Stream з `listen` не чекає завершення, тому для демо в task5 додав `Completer`, інакше програма йшла далі не дочекавшись.
- Порівняння швидкості: `Future.wait` для 3 запитів ~1 c, а послідовно ~3 c. `Set.contains` в сотні разів швидше ніж `List.contains` на 100000 елементів.
