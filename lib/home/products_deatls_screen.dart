import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? productData;

  const DetailsScreen({
    super.key,
    this.productData,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;
  int selectedUnitIndex = 1;
  bool isFavorite = false;

  final Color primaryColor = const Color(0xFFB32424);
  final Color secondaryColor = const Color(0xFFFBB616);
  final Color backgroundColor = const Color(0xFFF7F8FC);

  final List<String> units = ['500 g', '1 kg', '2 kg', '5 kg'];

  final List<Map<String, dynamic>> similarProducts = [
    {
      'id': 'p2',
      'name': 'Fresh Milk',
      'price': '₹60',
      'oldPrice': '₹70',
      'unit': '1 litre',
      'discount': '14% OFF',
      'imageUrl':
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 'p3',
      'name': 'Fresh Bread',
      'price': '₹45',
      'oldPrice': '₹55',
      'unit': '1 pack',
      'discount': '18% OFF',
      'imageUrl':
          'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 'p4',
      'name': 'Organic Potato',
      'price': '₹40',
      'oldPrice': '₹50',
      'unit': '1 kg',
      'discount': '20% OFF',
      'imageUrl':
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&auto=format&fit=crop&q=80',
    },
  ];

  Map<String, dynamic> get product {
    final defaultProduct = {
      'id': 'p1',
      'name': 'Fresh Organic Kashmiri Apples',
      'category': 'Fresh Fruits',
      'price': '₹120',
      'oldPrice': '₹150',
      'unit': '1 kg',
      'discount': '20% OFF',
      'rating': 4.8,
      'reviewsCount': 245,
      'imageUrl':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600&auto=format&fit=crop&q=80',
      'description':
          'Handpicked premium Kashmiri apples known for their crispiness, natural sweetness, and juicy texture. Rich in dietary fiber, antioxidants, and essential vitamins.',
      'nutrition': [
        {'label': 'Calories', 'value': '52 kcal'},
        {'label': 'Fiber', 'value': '2.4 g'},
        {'label': 'Carbs', 'value': '13.8 g'},
        {'label': 'Vitamin C', 'value': '14% DV'},
      ],
    };

    if (widget.productData != null) {
      return {...defaultProduct, ...widget.productData!};
    }
    return defaultProduct;
  }

  double get numericalPrice {
    final priceStr =
        (product['price'] as String).replaceAll('₹', '').trim();
    return double.tryParse(priceStr) ?? 120.0;
  }

  double get totalPrice => numericalPrice * quantity;

  void _showCompactCartNotification({
    required String title,
    required String unit,
    required String imageUrl,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 2),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF172033),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 38,
                    height: 38,
                    color: const Color(0xFFB32424),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Added to Cart!',
                      style: TextStyle(
                        color: Color(0xFFFBB616),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '$title ($unit x $quantity)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB32424),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CART',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    final String chosenUnit = selectedUnitIndex < units.length
        ? units[selectedUnitIndex]
        : (product['unit'] as String? ?? '1 pack');

    CartService.instance.addItem(
      id: product['id'] as String? ?? 'p1',
      name: product['name'] as String? ?? 'Fresh Item',
      unit: chosenUnit,
      price: numericalPrice,
      imageUrl: product['imageUrl'] as String? ?? '',
      quantity: quantity,
    );

    _showCompactCartNotification(
      title: product['name'] as String? ?? 'Fresh Item',
      unit: chosenUnit,
      imageUrl: product['imageUrl'] as String? ?? '',
    );
  }

  void _buyNow() {
    final String chosenUnit = selectedUnitIndex < units.length
        ? units[selectedUnitIndex]
        : (product['unit'] as String? ?? '1 pack');

    CartService.instance.addItem(
      id: product['id'] as String? ?? 'p1',
      name: product['name'] as String? ?? 'Fresh Item',
      unit: chosenUnit,
      price: numericalPrice,
      imageUrl: product['imageUrl'] as String? ?? '',
      quantity: quantity,
    );

    final double subtotalVal = CartService.instance.subtotal > 0
        ? CartService.instance.subtotal
        : totalPrice;
    final double deliveryFeeVal = subtotalVal > 200 ? 0.0 : 30.0;
    final double checkoutTotal = subtotalVal + deliveryFeeVal;

    Navigator.pushNamed(
      context,
      AppRoutes.deliveryAddress,
      arguments: {
        'subtotal': subtotalVal,
        'discountAmount': 0.0,
        'deliveryFee': deliveryFeeVal,
        'total': checkoutTotal,
        'items': CartService.instance.items,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Custom AppBar
            _buildAppBar(),

            // Scrollable Content Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Hero Image Card
                    _buildHeroImageCard(),

                    const SizedBox(height: 16),

                    // Main Product Info Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoryAndRatingRow(),
                          const SizedBox(height: 8),
                          _buildTitleAndPrice(),
                          const SizedBox(height: 18),
                          _buildUnitSelector(),
                          const SizedBox(height: 20),
                          _buildQuantityStepper(),
                          const SizedBox(height: 24),
                          _buildDeliveryBadgeCard(),
                          const SizedBox(height: 24),
                          _buildDescriptionSection(),
                          const SizedBox(height: 20),
                          _buildNutritionSection(),
                          const SizedBox(height: 24),
                          _buildSimilarProductsSection(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(44, 44),
            ),
          ),
          const Text(
            'Product Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF20213A),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite ? 'Saved to Wishlist' : 'Removed from Wishlist',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? const Color(0xFFFF4D6D) : Colors.black87,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(44, 44),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImageCard() {
    final String imageUrl = product['imageUrl'] as String;

    return Container(
      height: 270,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                imageUrl,
                height: 270,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFFFF7E0),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),

          // Discount Badge Pill
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                product['discount'] as String? ?? '20% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAndRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            product['category'] as String? ?? 'Fresh Grocery',
            style: TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
            const SizedBox(width: 4),
            Text(
              '${product['rating'] ?? 4.8}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product['reviewsCount'] ?? 245} reviews)',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleAndPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['name'] as String,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20213A),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              product['price'] as String,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              product['oldPrice'] as String? ?? '₹150',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '(${product['discount'] ?? '20% OFF'})',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Quantity / Size',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20213A),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(units.length, (index) {
            final isSelected = selectedUnitIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedUnitIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFF0F0) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? primaryColor : const Color(0xFFE5E7EB),
                    width: isSelected ? 1.6 : 1.0,
                  ),
                ),
                child: Text(
                  units[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? primaryColor : Colors.black87,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuantityStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Item Quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF20213A),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.remove, size: 18, color: primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryBadgeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.bolt, color: Color(0xFF2E7D32), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Express Delivery in 12 Mins',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'In Stock • Super Value Market Guarantee',
                  style: TextStyle(
                    color: Color(0xFF47785A),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    final String description = product['description'] as String? ??
        'Handpicked premium quality items delivered fresh to your doorstep.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20213A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionSection() {
    final List<dynamic>? nutrition = product['nutrition'] as List<dynamic>?;
    if (nutrition == null || nutrition.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Highlights',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20213A),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: nutrition.map((item) {
            final map = item as Map<String, dynamic>;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Text(
                      map['value'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      map['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSimilarProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Similar Fresh Products',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20213A),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similarProducts.length,
            itemBuilder: (context, index) {
              final item = similarProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.details,
                    arguments: item,
                  );
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['imageUrl'] as String,
                          height: 70,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['price'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL PRICE',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20213A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _addToCart,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  '+ ADD TO CART',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _buyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'BUY NOW',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
