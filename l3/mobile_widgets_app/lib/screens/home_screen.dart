import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../utils/app_state.dart';
import '../widgets/animated_counter.dart';
import '../widgets/custom_button.dart';
import 'products_screen.dart';
import 'profile_screen.dart';

// головний екран + показ всіх кастомних віджетів
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;
  bool _withIcon = true;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<AppState>().cartItemsCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої віджети'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Кошик: $cart')),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('CustomButton', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // CustomButton(text: 'Primary', style: CustomButtonStyle.primary)
              CustomButton(
                text: 'Primary',
                isLoading: _loading,
                icon: _withIcon ? const Icon(Icons.check) : null,
                onPressed: () {},
              ),
              CustomButton(
                text: 'Secondary',
                style: CustomButtonStyle.secondary,
                isLoading: _loading,
                icon: _withIcon ? const Icon(Icons.star) : null,
                onPressed: () {},
              ),
              CustomButton(
                text: 'Danger',
                style: CustomButtonStyle.danger,
                isLoading: _loading,
                icon: _withIcon ? const Icon(Icons.delete) : null,
                onPressed: () {},
              ),
              CustomButton(
                text: 'Outline',
                style: CustomButtonStyle.outline,
                isLoading: _loading,
                icon: _withIcon ? const Icon(Icons.info) : null,
                onPressed: () {},
              ),
            ],
          ),
          SwitchListTile(
            title: const Text('isLoading'),
            value: _loading,
            onChanged: (v) => setState(() => _loading = v),
          ),
          SwitchListTile(
            title: const Text('з іконкою'),
            value: _withIcon,
            onChanged: (v) => setState(() => _withIcon = v),
          ),
          const Divider(),
          const Text('AnimatedCounter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // AnimatedCounter(maxValue: 10) - на 10 стає червоним
          const AnimatedCounter(maxValue: 10),
          const Divider(height: 32),
          CustomButton(
            text: 'Товари',
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsScreen()));
            },
          ),
          const SizedBox(height: 8),
          CustomButton(
            text: 'Профіль',
            style: CustomButtonStyle.outline,
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
        ],
      ),
    );
  }
}
