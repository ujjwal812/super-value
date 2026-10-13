import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';

class CategoriesScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const CategoriesScreen({
    super.key,
    this.onBackPressed,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> categoriesData = const [
    {
      'id': 'cat_fruits_veg',
      'name': 'Fruits & Vegetables',
      'shortName': 'Fruits & Veg',
      'itemCount': '140+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=300&auto=format&fit=crop&q=80',
      'tag': 'UP TO 25% OFF',
      'subcategories': [
        {
          'id': 'sub_fruits_1',
          'name': 'Fresh Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400&auto=format&fit=crop&q=80',
          'count': '45 Items',
          'price': 99.0,
        },
        {
          'id': 'sub_veg_1',
          'name': 'Fresh Vegetables',
          'imageUrl':
              'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&auto=format&fit=crop&q=80',
          'count': '60 Items',
          'price': 49.0,
        },
        {
          'id': 'sub_herbs_1',
          'name': 'Herbs & Seasoning',
          'imageUrl':
              'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&auto=format&fit=crop&q=80',
          'count': '20 Items',
          'price': 29.0,
        },
        {
          'id': 'sub_exotic_1',
          'name': 'Exotic Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&auto=format&fit=crop&q=80',
          'count': '15 Items',
          'price': 149.0,
        },
      ],
    },
    {
      'id': 'cat_dairy',
      'name': 'Dairy & Eggs',
      'shortName': 'Dairy',
      'itemCount': '85+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300&auto=format&fit=crop&q=80',
      'tag': 'FRESH DAILY',
      'subcategories': [
        {
          'id': 'sub_milk_1',
          'name': 'Milk & Cream',
          'imageUrl':
              'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&auto=format&fit=crop&q=80',
          'count': '25 Items',
          'price': 60.0,
        },
        {
          'id': 'sub_butter_1',
          'name': 'Butter & Cheese',
          'imageUrl':
              'https://images.unsplash.com/photo-1589883661923-6476cb0ae9f2?w=400&auto=format&fit=crop&q=80',
          'count': '30 Items',
          'price': 115.0,
        },
        {
          'id': 'sub_eggs_1',
          'name': 'Farm Eggs',
          'imageUrl':
              'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&auto=format&fit=crop&q=80',
          'count': '15 Items',
          'price': 75.0,
        },
        {
          'id': 'sub_curd_1',
          'name': 'Curd & Yogurt',
          'imageUrl':
              'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&auto=format&fit=crop&q=80',
          'count': '15 Items',
          'price': 40.0,
        },
      ],
    },
    {
      'id': 'cat_bakery',
      'name': 'Bakery & Bread',
      'shortName': 'Bakery',
      'itemCount': '60+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&auto=format&fit=crop&q=80',
      'tag': null,
      'subcategories': [
        {
          'id': 'sub_bread_1',
          'name': 'Bread & Buns',
          'imageUrl':
              'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&auto=format&fit=crop&q=80',
          'count': '20 Items',
          'price': 45.0,
        },
        {
          'id': 'sub_cakes_1',
          'name': 'Cakes & Pastries',
          'imageUrl':
              'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&auto=format&fit=crop&q=80',
          'count': '25 Items',
          'price': 199.0,
        },
        {
          'id': 'sub_cookies_1',
          'name': 'Cookies & Rusk',
          'imageUrl':
              'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&auto=format&fit=crop&q=80',
          'count': '15 Items',
          'price': 80.0,
        },
      ],
    },
    {
      'id': 'cat_beverages',
      'name': 'Beverages & Juices',
      'shortName': 'Beverages',
      'itemCount': '95+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=300&auto=format&fit=crop&q=80',
      'tag': 'HOT DEALS',
      'subcategories': [
        {
          'id': 'sub_juices_1',
          'name': 'Fruit Juices',
          'imageUrl':
              'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400&auto=format&fit=crop&q=80',
          'count': '35 Items',
          'price': 99.0,
        },
        {
          'id': 'sub_softdrinks_1',
          'name': 'Soft Drinks',
          'imageUrl':
              'https://images.unsplash.com/photo-1581006852262-e4307cf6283a?w=400&auto=format&fit=crop&q=80',
          'count': '30 Items',
          'price': 50.0,
        },
        {
          'id': 'sub_tea_1',
          'name': 'Tea & Coffee',
          'imageUrl':
              'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&auto=format&fit=crop&q=80',
          'count': '30 Items',
          'price': 120.0,
        },
      ],
    },
    {
      'id': 'cat_snacks',
      'name': 'Snacks & Munchies',
      'shortName': 'Snacks',
      'itemCount': '110+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=300&auto=format&fit=crop&q=80',
      'tag': null,
      'subcategories': [
        {
          'id': 'sub_chips_1',
          'name': 'Chips & Crisps',
          'imageUrl':
              'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&auto=format&fit=crop&q=80',
          'count': '40 Items',
          'price': 30.0,
        },
        {
          'id': 'sub_nuts_1',
          'name': 'Nuts & Dry Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=400&auto=format&fit=crop&q=80',
          'count': '35 Items',
          'price': 250.0,
        },
        {
          'id': 'sub_chocolates_1',
          'name': 'Chocolates',
          'imageUrl':
              'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400&auto=format&fit=crop&q=80',
          'count': '35 Items',
          'price': 85.0,
        },
      ],
    },
    {
      'id': 'cat_pantry',
      'name': 'Pantry & Staples',
      'shortName': 'Pantry',
      'itemCount': '200+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1584473457406-6240486418e9?w=300&auto=format&fit=crop&q=80',
      'tag': 'BEST VALUE',
      'subcategories': [
        {
          'id': 'sub_flour_1',
          'name': 'Atta & Flours',
          'imageUrl':
              'https://images.unsplash.com/photo-1584473457406-6240486418e9?w=400&auto=format&fit=crop&q=80',
          'count': '50 Items',
          'price': 280.0,
        },
        {
          'id': 'sub_rice_1',
          'name': 'Rice & Grains',
          'imageUrl':
              'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&auto=format&fit=crop&q=80',
          'count': '60 Items',
          'price': 180.0,
        },
        {
          'id': 'sub_oil_1',
          'name': 'Edible Oils',
          'imageUrl':
              'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&auto=format&fit=crop&q=80',
          'count': '40 Items',
          'price': 160.0,
        },
      ],
    },
    {
      'id': 'cat_personal',
      'name': 'Personal Care',
      'shortName': 'Personal',
      'itemCount': '130+ Products',
      'imageUrl':
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&auto=format&fit=crop&q=80',
      'tag': null,
      'subcategories': [
        {
          'id': 'sub_soaps_1',
          'name': 'Soaps & Body Wash',
          'imageUrl':
              'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?w=400&auto=format&fit=crop&q=80',
          'count': '45 Items',
          'price': 65.0,
        },
        {
          'id': 'sub_hair_1',
          'name': 'Hair Care',
          'imageUrl':
              'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=400&auto=format&fit=crop&q=80',
          'count': '40 Items',
          'price': 140.0,
        },
        {
          'id': 'sub_skin_1',
          'name': 'Skin Care',
          'imageUrl':
              'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400&auto=format&fit=crop&q=80',
          'count': '45 Items',
          'price': 199.0,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    CartService.instance.cartCountNotifier.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    CartService.instance.cartCountNotifier.removeListener(_onCartChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = categoriesData[selectedCategoryIndex];
    final List<Map<String, dynamic>> subcategories =
        currentCategory['subcategories'] as List<Map<String, dynamic>>;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 600;
    final double sidebarWidth = isWideScreen ? 115.0 : 98.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF172033),
          ),
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
        title: const Text(
          'Categories Catalog',
          style: TextStyle(
            color: Color(0xFF172033),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Modular Left Sidebar Selector
          SizedBox(
            width: sidebarWidth,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 120, top: 10),
                itemCount: categoriesData.length,
                itemBuilder: (context, index) {
                  final category = categoriesData[index];
                  final isSelected = selectedCategoryIndex == index;

                  return GestureDetector(
                    onTap: () {
                      if (selectedCategoryIndex != index) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF0F0)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: isSelected
                                ? const Color(0xFFB32424)
                                : Colors.transparent,
                            width: 3.5,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.08 : 1.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFB32424)
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFB32424)
                                              .withValues(alpha: 0.15),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  category['imageUrl'] as String,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Container(
                                    color: const Color(0xFFFFF7E0),
                                    child: const Icon(
                                      Icons.category_rounded,
                                      color: Color(0xFFB32424),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category['shortName'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFB32424)
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const VerticalDivider(width: 1, color: Color(0xFFEBECEF)),

          // Modular Right Content Area
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.03, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: RefreshIndicator(
                key: ValueKey<int>(selectedCategoryIndex),
                color: const Color(0xFFB32424),
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 600));
                  if (mounted) setState(() {});
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentCategory['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172033),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  currentCategory['itemCount'] as String,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (currentCategory['tag'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F0),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFB32424)
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                currentCategory['tag'] as String,
                                style: const TextStyle(
                                  color: Color(0xFFB32424),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 14),

                      // Cards Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double availableWidth = constraints.maxWidth;
                          int crossAxisCount = 2;
                          if (availableWidth > 800) {
                            crossAxisCount = 5;
                          } else if (availableWidth > 580) {
                            crossAxisCount = 4;
                          } else if (availableWidth > 360) {
                            crossAxisCount = 3;
                          } else {
                            crossAxisCount = 2;
                          }

                          double childAspectRatio = 0.62;
                          if (availableWidth > 600) {
                            childAspectRatio = 0.78;
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subcategories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 12,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final sub = subcategories[index];

                              return _ModularSubcategoryCard(
                                id: sub['id'] as String,
                                name: sub['name'] as String,
                                imageUrl: sub['imageUrl'] as String,
                                count: sub['count'] as String,
                                price: (sub['price'] as num).toDouble(),
                              );
                            },
                          );
                        },
                      ),
                    ],
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

// ----------------------------------------------------------
// MODULAR SUBCATEGORY CARD WIDGET WITH ANIMATED + BUTTON
// ----------------------------------------------------------

class _ModularSubcategoryCard extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String count;
  final double price;

  const _ModularSubcategoryCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.count,
    required this.price,
  });

  @override
  State<_ModularSubcategoryCard> createState() =>
      _ModularSubcategoryCardState();
}

class _ModularSubcategoryCardState extends State<_ModularSubcategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _floatController;
  late Animation<Offset> _floatSlideAnimation;
  late Animation<double> _floatFadeAnimation;

  bool _showPlusOne = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.72), weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.72, end: 1.3), weight: 40),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.3, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _floatSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1.8),
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeOutCubic,
    ));
    _floatFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
    ));

    _floatController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _showPlusOne = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _showWeightSelectionBottomSheet() {
    _scaleController.forward(from: 0.0);
    setState(() {
      _showPlusOne = true;
    });
    _floatController.forward(from: 0.0);

    final List<Map<String, dynamic>> variantsList = [
      {'weight': '250 g', 'price': '₹${(widget.price * 0.35).toInt()}', 'oldPrice': '₹${(widget.price * 0.45).toInt()}'},
      {'weight': '500 g', 'price': '₹${(widget.price * 0.65).toInt()}', 'oldPrice': '₹${(widget.price * 0.85).toInt()}'},
      {'weight': '1 pack', 'price': '₹${widget.price.toInt()}', 'oldPrice': '₹${(widget.price * 1.25).toInt()}', 'isPopular': true},
      {'weight': '2 pack', 'price': '₹${(widget.price * 1.8).toInt()}', 'oldPrice': '₹${(widget.price * 2.3).toInt()}'},
    ];

    int selectedIndex = 2; // Default to popular pack

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final selectedVariantObj = variantsList[selectedIndex];

            return ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 30,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Drag Indicator
                      Center(
                        child: Container(
                          width: 42,
                          height: 4.5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),

                      // Product Header Brief
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 60,
                                height: 60,
                                color: const Color(0xFFFFF7E0),
                                child: const Icon(
                                  Icons.shopping_bag,
                                  color: Color(0xFFB32424),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172033),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Select Quantity / Pack Size',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Available Variants:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Variant Cards List
                      Column(
                        children: List.generate(variantsList.length, (idx) {
                          final item = variantsList[idx];
                          final isSelected = selectedIndex == idx;
                          final isPopular = item['isPopular'] == true;

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedIndex = idx;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFB32424).withValues(alpha: 0.12)
                                    : Colors.white.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFB32424)
                                      : Colors.white.withValues(alpha: 0.8),
                                  width: isSelected ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: isSelected
                                        ? const Color(0xFFB32424)
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          item['weight'] as String,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: const Color(0xFF20213A),
                                          ),
                                        ),
                                        if (isPopular) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFBB616),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'POPULAR',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF20213A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        item['price'] as String,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB32424),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['oldPrice'] as String,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 18),

                      // Actions: ADD TO CART and GO TO CART
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  final chosenVariant =
                                      selectedVariantObj['weight'] as String;
                                  final priceStr = (selectedVariantObj['price'] as String).replaceAll('₹', '').trim();
                                  final double priceVal = double.tryParse(priceStr) ?? widget.price;

                                  CartService.instance.addItem(
                                    id: widget.id,
                                    name: widget.name,
                                    unit: chosenVariant,
                                    price: priceVal,
                                    imageUrl: widget.imageUrl,
                                  );

                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFB32424),
                                  side: const BorderSide(
                                      color: Color(0xFFB32424), width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'ADD TO CART',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  final chosenVariant =
                                      selectedVariantObj['weight'] as String;
                                  final priceStr = (selectedVariantObj['price'] as String).replaceAll('₹', '').trim();
                                  final double priceVal = double.tryParse(priceStr) ?? widget.price;

                                  CartService.instance.addItem(
                                    id: widget.id,
                                    name: widget.name,
                                    unit: chosenVariant,
                                    price: priceVal,
                                    imageUrl: widget.imageUrl,
                                  );

                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, AppRoutes.cart);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB32424),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'GO TO CART',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemQty = CartService.instance.getQuantityForProduct(widget.id);

    return GestureDetector(
      onTap: _showWeightSelectionBottomSheet,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Cover Image
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      color: const Color(0xFFFFF8F0),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFFFF7E0),
                          child: const Icon(
                            Icons.category,
                            color: Color(0xFFB32424),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Details Below Image
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172033),
                            height: 1.12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: _showWeightSelectionBottomSheet,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₹${widget.price.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB32424),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF0F0),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.count,
                                          style: const TextStyle(
                                            fontSize: 8.0,
                                            color: Color(0xFFB32424),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 10,
                                          color: Color(0xFFB32424),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Animated Plus (+) Button
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: GestureDetector(
                                onTap: _showWeightSelectionBottomSheet,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: itemQty > 0
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFB32424),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (itemQty > 0
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFFB32424))
                                            .withValues(alpha: 0.45),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        itemQty > 0
                                            ? Icons.check_rounded
                                            : Icons.add_rounded,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      if (itemQty > 0)
                                        Positioned(
                                          top: -5,
                                          right: -5,
                                          child: Container(
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFBB616),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$itemQty',
                                              style: const TextStyle(
                                                color: Color(0xFF172033),
                                                fontSize: 7.5,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating "+1" Pop Particle Animation
            if (_showPlusOne)
              Positioned(
                bottom: 32,
                right: 8,
                child: SlideTransition(
                  position: _floatSlideAnimation,
                  child: FadeTransition(
                    opacity: _floatFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        '+1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
