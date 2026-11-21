import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_widgets_app/widgets/custom_button.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('should render text correctly', (tester) async {
      await tester.pumpWidget(wrap(const CustomButton(text: 'Купити')));
      expect(find.text('Купити'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      int taps = 0;
      await tester.pumpWidget(wrap(CustomButton(text: 'OK', onPressed: () => taps++)));
      await tester.tap(find.text('OK'));
      expect(taps, 1);
    });

    testWidgets('should show loading state', (tester) async {
      int taps = 0;
      await tester.pumpWidget(wrap(CustomButton(text: 'OK', isLoading: true, onPressed: () => taps++)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('OK'));
      expect(taps, 0); // під час завантаження не натискається
    });
  });
}
