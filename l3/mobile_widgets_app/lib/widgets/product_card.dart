import 'package:material_ui/material_ui.dart';

import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _cartPressed = false;

  // по тапу на картинку відкриваємо її більшою, можна зумити пальцями
  void _openImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          maxScale: 4,
          child: Image.network(
            widget.product.imageUrl,
            errorBuilder: (context, error, stackTrace) => const Padding(
              padding: EdgeInsets.all(32),
              child: Icon(Icons.image_not_supported, size: 64),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // свайп вліво або вправо - додати/прибрати з обраних
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v.abs() > 300) {
          widget.onFavoriteToggle?.call();
        }
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                key: const Key('product_image'),
                onTap: _openImage,
                child: Image.network(
                  widget.product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const ShimmerBox();
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Text(widget.product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('${widget.product.price.toStringAsFixed(0)} грн'),
            ),
            Row(
              children: [
                IconButton(
                  key: const Key('fav_button'),
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: widget.onFavoriteToggle,
                ),
                const Spacer(),
                // Listener щоб зробити анімацію натискання
                Listener(
                  onPointerDown: (_) => setState(() => _cartPressed = true),
                  onPointerUp: (_) => setState(() => _cartPressed = false),
                  child: AnimatedScale(
                    scale: _cartPressed ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: IconButton(
                      key: const Key('cart_button'),
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: widget.onAddToCart,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// сірий блок який "мерехтить" поки щось вантажиться
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(color: Colors.grey[300]),
    );
  }
}
