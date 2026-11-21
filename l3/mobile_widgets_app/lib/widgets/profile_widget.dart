import 'package:material_ui/material_ui.dart';

import '../models/user.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  final VoidCallback? onEditPressed;
  final bool isCompact;

  const ProfileWidget({
    super.key,
    required this.user,
    this.onEditPressed,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isCompact) {
      return ListTile(
        leading: CircleAvatar(child: Text(user.initials)),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: onEditPressed != null
            ? IconButton(icon: const Icon(Icons.edit), onPressed: onEditPressed)
            : null,
      );
    }

    // на планшеті / в браузері робимо аватар більшим
    final bool bigScreen = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: bigScreen ? 60 : 40,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  user.initials,
                  style: TextStyle(fontSize: bigScreen ? 36 : 24, color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 10),
              Text(user.name, style: theme.textTheme.titleLarge),
              Text(user.email),
              if (onEditPressed != null)
                TextButton.icon(
                  onPressed: onEditPressed,
                  icon: const Icon(Icons.edit),
                  label: const Text('Редагувати'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
