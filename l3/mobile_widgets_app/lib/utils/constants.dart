import 'package:material_ui/material_ui.dart';

import '../models/product.dart';
import '../models/user.dart';

const Color kPrimaryColor = Colors.indigo;
const double kPadding = 16;

// замість API поки що просто тестові дані
// фото з Wikimedia Commons (ліцензії CC, список в README)
const User kUser = User(id: '1', name: 'Юрій Рукавіцин', email: 'yura@example.com');

const List<Product> kProducts = [
  Product(id: '1', title: 'Навушники', price: 2499, imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/0/0a/Bose_QuietComfort_25_Acoustic_Noise_Cancelling_Headphones_with_Carry_Case.jpg/500px-Bose_QuietComfort_25_Acoustic_Noise_Cancelling_Headphones_with_Carry_Case.jpg'),
  Product(id: '2', title: 'Рюкзак', price: 1299, imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a1/Plecak_Hiker_50_L_HiMountain.jpg/500px-Plecak_Hiker_50_L_HiMountain.jpg'),
  Product(id: '3', title: 'Кросівки', price: 3199, imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4a/Nike_Free%2B_3_running_shoe.jpg'),
  Product(id: '4', title: 'Чашка', price: 249, imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c6/Used_coffee_mug_%284356081928%29.jpg/500px-Used_coffee_mug_%284356081928%29.jpg'),
  Product(id: '5', title: 'Годинник', price: 4599, imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6c/PineTime_smartwatch.jpg/500px-PineTime_smartwatch.jpg'),
  Product(id: '6', title: 'Блокнот', price: 119, imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a5/Red_Spiral-Bound_Notebook.jpg/500px-Red_Spiral-Bound_Notebook.jpg'),
];
