import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_widgets_app/main.dart';
import 'package:mobile_widgets_app/utils/app_state.dart';
import 'package:provider/provider.dart';

// сценарій: головна -> товари -> в кошик -> профіль
void main() {
  testWidgets('додати товар в кошик і в обрані', (tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => AppState()..loadProducts(delay: Duration.zero),
      child: const MyApp(),
    ));
    await tester.pump();

    await tester.ensureVisible(find.text('Товари'));
    await tester.pump();
    await tester.tap(find.text('Товари'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cart_button')).first);
    await tester.tap(find.byKey(const Key('fav_button')).first);
    await tester.pumpAndSettle();
    expect(find.text('Кошик: 1'), findsOneWidget);

    // назад і в профіль
    await tester.pageBack();
    // чекаємо поки сховається снекбар, бо він закриває кнопку
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Профіль'));
    await tester.pump();
    await tester.tap(find.text('Профіль'));
    await tester.pumpAndSettle();
    expect(find.text('Обрані (1):'), findsOneWidget);
    expect(find.text('Навушники'), findsOneWidget);
  });
}
