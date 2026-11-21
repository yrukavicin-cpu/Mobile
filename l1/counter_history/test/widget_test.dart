import 'package:flutter_test/flutter_test.dart';

import 'package:counter_history/main.dart';

void main() {
  testWidgets('Лічильник збільшується і не йде в мінус', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('+'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // 1 -> 0, а потім спроба піти в мінус
    await tester.tap(find.text('-'));
    await tester.pump();
    await tester.tap(find.text('-'));
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('Лічильник не може бути менше нуля!'), findsOneWidget);
  });
}
