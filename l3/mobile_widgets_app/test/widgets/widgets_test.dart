import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_widgets_app/models/user.dart';
import 'package:mobile_widgets_app/utils/constants.dart';
import 'package:mobile_widgets_app/widgets/animated_counter.dart';
import 'package:mobile_widgets_app/widgets/product_card.dart';
import 'package:mobile_widgets_app/widgets/profile_widget.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  const user = User(id: '1', name: 'Іван Петренко', email: 'ivan@test.com');

  testWidgets('ProfileWidget показує імʼя, email і ініціали', (tester) async {
    await tester.pumpWidget(wrap(const ProfileWidget(user: user)));
    expect(find.text('Іван Петренко'), findsOneWidget);
    expect(find.text('ivan@test.com'), findsOneWidget);
    expect(find.text('ІП'), findsOneWidget);
  });

  testWidgets('ProfileWidget compact + кнопка редагування', (tester) async {
    bool edited = false;
    await tester.pumpWidget(wrap(ProfileWidget(user: user, isCompact: true, onEditPressed: () => edited = true)));
    expect(find.byType(ListTile), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    expect(edited, true);
  });

  testWidgets('AnimatedCounter + і - та не більше max', (tester) async {
    await tester.pumpWidget(wrap(const AnimatedCounter(maxValue: 2)));
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('counter_dec')));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget); // в мінус не йде

    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('counter_inc')));
      await tester.pumpAndSettle();
    }
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('ProductCard кнопки і свайп', (tester) async {
    int fav = 0;
    int cart = 0;
    await tester.pumpWidget(wrap(SizedBox(
      width: 200,
      height: 300,
      child: ProductCard(
        product: kProducts.first,
        onFavoriteToggle: () => fav++,
        onAddToCart: () => cart++,
      ),
    )));
    await tester.pump();
    expect(find.text('Навушники'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.tap(find.byKey(const Key('fav_button')));
    await tester.fling(find.byType(ProductCard), const Offset(150, 0), 1000);
    await tester.pump();
    expect(cart, 1);
    expect(fav, 2);
  });
}
