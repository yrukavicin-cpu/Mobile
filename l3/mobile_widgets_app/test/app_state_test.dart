import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_widgets_app/utils/app_state.dart';
import 'package:mobile_widgets_app/utils/constants.dart';

void main() {
  test('toggleFavorite додає і прибирає', () {
    final state = AppState();
    state.toggleFavorite(kProducts[0]);
    expect(state.isFavorite(kProducts[0]), true);
    state.toggleFavorite(kProducts[0]);
    expect(state.favoriteProducts, isEmpty);
  });

  test('addToCart збільшує лічильник і повідомляє слухачів', () {
    final state = AppState();
    int notified = 0;
    state.addListener(() => notified++);
    state.addToCart(kProducts[1]);
    state.addToCart(kProducts[1]);
    expect(state.cartItemsCount, 2);
    expect(notified, 2);
  });

  test('updateUserName перевіряє імʼя', () {
    final state = AppState();
    expect(state.updateUserName('a'), false);
    expect(state.updateUserName('Олег Іванов'), true);
    expect(state.currentUser!.name, 'Олег Іванов');
  });

  test('loadProducts', () async {
    final state = AppState();
    await state.loadProducts(delay: Duration.zero);
    expect(state.isLoading, false);
    expect(state.products.length, kProducts.length);
  });
}
