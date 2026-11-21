import 'package:material_ui/material_ui.dart';

enum CustomButtonStyle {
  primary,
  secondary,
  danger,
  outline,
}

// приклад: CustomButton(text: 'OK', style: CustomButtonStyle.danger, onPressed: () {})
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonStyle style;
  final Widget? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = CustomButtonStyle.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Color bg = colors.primary;
    Color fg = colors.onPrimary;
    if (style == CustomButtonStyle.secondary) {
      bg = colors.secondaryContainer;
      fg = colors.onSecondaryContainer;
    } else if (style == CustomButtonStyle.danger) {
      bg = Colors.red;
      fg = Colors.white;
    } else if (style == CustomButtonStyle.outline) {
      bg = Colors.transparent;
      fg = colors.primary;
    }

    return ElevatedButton(
      // поки вантажиться кнопку не можна натиснути
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: style == CustomButtonStyle.outline ? 0 : 2,
        side: style == CustomButtonStyle.outline ? BorderSide(color: colors.primary) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          else if (icon != null)
            icon!,
          if (isLoading || icon != null) const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
