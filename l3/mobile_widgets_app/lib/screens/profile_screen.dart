import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _editName() {
    final state = context.read<AppState>();
    _nameController.text = state.currentUser?.name ?? '';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Змінити імʼя'),
        content: TextField(controller: _nameController),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Скасувати')),
          TextButton(
            onPressed: () {
              final ok = state.updateUserName(_nameController.text);
              Navigator.pop(dialogContext);
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Імʼя занадто коротке')),
                );
              }
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser ?? kUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: ListView(
        padding: const EdgeInsets.all(kPadding),
        children: [
          ProfileWidget(user: user, onEditPressed: _editName),
          const SizedBox(height: 8),
          const Text('Компактний варіант:'),
          ProfileWidget(user: user, isCompact: true),
          const Divider(),
          Text('У кошику: ${state.cartItemsCount}'),
          Text('Обрані (${state.favoriteProducts.length}):'),
          for (var p in state.favoriteProducts)
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: Text(p.title),
            ),
        ],
      ),
    );
  }
}
