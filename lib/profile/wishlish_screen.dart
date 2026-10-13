import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color primaryColor = const Color(0xFFB32424);
  final Color backgroundColor = const Color(0xFFF7F8FC);

  final List<Map<String, dynamic>> wishlistItems = [
    {
      'id': 1,
      'name': 'Premium Travel Backpack',
      'category': 'Travel Accessories',
      'price': 1499.0,
      'oldPrice': 1999.0,
      'rating': 4.8,
      'reviews': 128,
      'imageUrl':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop&q=80',
      'icon': Icons.backpack_rounded,
      'color': const Color(0xFFE8E9FF),
      'iconColor': const Color(0xFFB32424),
    },
    {
      'id': 2,
      'name': 'Smart Travel Bottle',
      'category': 'Daily Essentials',
      'price': 699.0,
      'oldPrice': 999.0,
      'rating': 4.6,
      'reviews': 86,
      'imageUrl':
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&auto=format&fit=crop&q=80',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFFE1F6F2),
      'iconColor': const Color(0xFF009688),
    },
    {
      'id': 3,
      'name': 'Travel Organizer Kit',
      'category': 'Travel Accessories',
      'price': 899.0,
      'oldPrice': 1299.0,
      'rating': 4.7,
      'reviews': 94,
      'imageUrl':
          'https://images.unsplash.com/photo-1544816155-12df9643f363?w=400&auto=format&fit=crop&q=80',
      'icon': Icons.luggage_rounded,
      'color': const Color(0xFFFFEBD9),
      'iconColor': const Color(0xFFEF7D32),
    },
    {
      'id': 4,
      'name': 'Wireless Headphones',
      'category': 'Electronics',
      'price': 2199.0,
      'oldPrice': 2799.0,
      'rating': 4.9,
      'reviews': 216,
      'imageUrl':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop&q=80',
      'icon': Icons.headphones_rounded,
      'color': const Color(0xFFF4E5FF),
      'iconColor': const Color(0xFF9638C9),
    },
  ];

  final Set<int> cartItems = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _removeItem(int id) {
    setState(() {
      wishlistItems.removeWhere((item) => item['id'] == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from wishlist'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    final int id = item['id'] as int;
    final String name = item['name'] as String;

    setState(() {
      cartItems.add(id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: const Color(0xFFFBB616),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return '₹${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 800));
                    if (mounted) setState(() {});
                  },
                  child: wishlistItems.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: _buildEmptyWishlist(),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            10,
                            20,
                            25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderCard(),
                              const SizedBox(height: 25),
                              _buildListHeading(),
                              const SizedBox(height: 16),
                              ...wishlistItems.map(
                                (item) => _buildWishlistCard(item),
                              ),
                              const SizedBox(height: 10),
                              _buildContinueShopping(),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Wishlist',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20213A),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your favorite items in one place',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            icon: Icons.shopping_bag_outlined,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: const Color(0xFF25263D),
            size: 21,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD32F2F),
            Color(0xFFB32424),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Favorites ❤️',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  '${wishlistItems.length} items saved for later',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.17),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Made for you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeading() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Saved Items',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF20213A),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${wishlistItems.length} items',
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistCard(Map<String, dynamic> item) {
    final int id = item['id'] as int;
    final bool isInCart = cartItems.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEDEEF4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.details,
                  arguments: {
                    'name': item['name'],
                    'imageUrl': item['imageUrl'],
                    'category': item['category'],
                    'price': '₹${(item['price'] as double).toStringAsFixed(0)}',
                    'oldPrice': '₹${(item['oldPrice'] as double).toStringAsFixed(0)}',
                    'unit': '1 item',
                    'discount': '25% OFF',
                  },
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 105,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Image.network(
                        item['imageUrl'] as String,
                        width: 105,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            item['icon'] as IconData,
                            color: item['iconColor'] as Color,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['category'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      _favoriteButton(id),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['name'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25263D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: Color(0xFFFFB300),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${item['rating']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item['reviews']})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        _formatPrice(item['price'] as double),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF20213A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatPrice(item['oldPrice'] as double),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: isInCart ? null : () => _addToCart(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor: const Color(0xFFFFF0F0),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isInCart
                                ? Icons.check_circle_outline_rounded
                                : Icons.shopping_cart_outlined,
                            size: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isInCart ? 'Added to Cart' : 'Add to Cart',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteButton(int id) {
    return Material(
      color: const Color(0xFFFFEDF0),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _removeItem(id),
        child: const Padding(
          padding: EdgeInsets.all(7),
          child: Icon(
            Icons.favorite_rounded,
            color: Color(0xFFFF4D6D),
            size: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueShopping() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushNamed(context, AppRoutes.home);
          }
        },
        icon: const Icon(Icons.arrow_back_rounded, size: 18),
        label: const Text(
          'Continue Shopping',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(
            color: primaryColor.withValues(alpha: 0.35),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 145,
              height: 145,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 76,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 27),
            const Text(
              'Your Wishlist is Empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20213A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Save your favorite products here and find them easily whenever you need them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamed(context, AppRoutes.home);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Explore Products'),
            ),
          ],
        ),
      ),
    );
  }
}
