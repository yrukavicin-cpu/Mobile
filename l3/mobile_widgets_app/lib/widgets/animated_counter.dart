import 'package:material_ui/material_ui.dart';

class AnimatedCounter extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final Duration animationDuration;
  final Color? primaryColor;

  const AnimatedCounter({
    super.key,
    this.initialValue = 0,
    this.maxValue = 100,
    this.animationDuration = const Duration(milliseconds: 300),
    this.primaryColor,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _value = 0;
  bool _minusPressed = false;
  bool _plusPressed = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    // коли збільшилось - повертаємо назад
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _change(int delta) {
    int newValue = _value + delta;
    if (newValue < 0 || newValue > widget.maxValue) return;
    setState(() {
      _value = newValue;
    });
    _controller.forward(from: 0);
  }

  // кнопка яка трохи стискається при натисканні (bounce)
  Widget _bounceButton(Key key, IconData icon, bool pressed, ValueChanged<bool> setPressed, VoidCallback onTap) {
    return GestureDetector(
      key: key,
      onTapDown: (_) => setPressed(true),
      onTapUp: (_) {
        setPressed(false);
        onTap();
      },
      onTapCancel: () => setPressed(false),
      child: AnimatedScale(
        scale: pressed ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.elasticOut,
        child: CircleAvatar(radius: 24, child: Icon(icon)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor ?? Theme.of(context).colorScheme.primary;
    final bool isMax = _value == widget.maxValue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _animation,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: isMax ? Colors.red : color),
            duration: widget.animationDuration,
            builder: (context, value, child) {
              return Text(
                '$_value',
                key: const Key('counter_value'),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: value),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // прогрес плавно доїжджає до нового значення
        TweenAnimationBuilder<double>(
          tween: Tween(end: _value / widget.maxValue),
          duration: widget.animationDuration,
          builder: (context, value, child) => LinearProgressIndicator(value: value),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bounceButton(const Key('counter_dec'), Icons.remove, _minusPressed,
                (p) => setState(() => _minusPressed = p), () => _change(-1)),
            const SizedBox(width: 24),
            _bounceButton(const Key('counter_inc'), Icons.add, _plusPressed,
                (p) => setState(() => _plusPressed = p), () => _change(1)),
          ],
        ),
      ],
    );
  }
}
