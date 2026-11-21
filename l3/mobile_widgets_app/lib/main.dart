import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'utils/app_state.dart';
import 'utils/themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..loadProducts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgets App',
      theme: AppThemes.light,
      home: const HomeScreen(),
    );
  }
}
