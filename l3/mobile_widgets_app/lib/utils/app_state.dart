import 'package:material_ui/material_ui.dart';

import '../models/product.dart';
import '../models/user.dart';
import 'constants.dart';

class AppState extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _favoriteProducts = [];
  User? _currentUser = kUser;
  int _cartItemsCount = 0;
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get favoriteProducts => _favoriteProducts;
  User? get currentUser => _currentUser;
  int get cartItemsCount => _cartItemsCount;
  bool get isLoading => _isLoading;

  // ніби завантаження з сервера
  Future<void> loadProducts({Duration delay = const Duration(seconds: 2)}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(delay);
    _products = kProducts;
    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteProducts.any((p) => p.id == product.id);
  }

  void toggleFavorite(Product product) {
    // створюю новий список, старий не чіпаю
    if (isFavorite(product)) {
      _favoriteProducts = _favoriteProducts.where((p) => p.id != product.id).toList();
    } else {
      _favoriteProducts = [..._favoriteProducts, product];
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    _cartItemsCount++;
    notifyListeners();
  }

  // false якщо ім'я некоректне
  bool updateUserName(String name) {
    if (name.trim().length < 2) {
      return false;
    }
    _currentUser = _currentUser?.copyWith(name: name.trim());
    notifyListeners();
    return true;
  }
}
