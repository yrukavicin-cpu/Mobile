import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../utils/app_state.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    // на широкому екрані 3 колонки
    final columns = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Товари'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Кошик: ${state.cartItemsCount}')),
          ),
        ],
      ),
      body: state.isLoading
          ? GridView.count(
              crossAxisCount: columns,
              padding: const EdgeInsets.all(8),
              children: List.generate(
                4,
                (i) => const Card(clipBehavior: Clip.antiAlias, child: ShimmerBox()),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(
                  product: product,
                  isFavorite: state.isFavorite(product),
                  onFavoriteToggle: () => state.toggleFavorite(product),
                  onAddToCart: () {
                    state.addToCart(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} додано в кошик')),
                    );
                  },
                );
              },
            ),
    );
  }
}
