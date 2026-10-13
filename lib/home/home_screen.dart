import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:learning_project/home/cart_screen.dart';
import 'package:learning_project/home/categories_screen.dart';
import 'package:learning_project/home/notification_screen.dart';
import 'package:learning_project/profile/profile_screen.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';
import 'package:learning_project/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedBottomIndex = 0;
  final Map<String, int> cartQuantities = {};
  final Map<String, String> selectedVariants = {};

  late PageController _bannerController;
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  final List<Map<String, dynamic>> heroBanners = const [
    {
      'tag': 'SUPER VALUE DEALS',
      'title': 'Fresh Fruits & Veggies\nUp To 50% OFF',
      'buttonText': 'SHOP NOW',
      'imageUrl':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&auto=format&fit=crop&q=80',
      'gradient': [Color(0xFFB32424), Color(0xFFE53935)],
    },
    {
      'tag': 'DAILY FRESH DAIRY',
      'title': 'Organic Milk, Butter & Cheese\nFlat 30% OFF',
      'buttonText': 'EXPLORE DAIRY',
      'imageUrl':
          'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=800&auto=format&fit=crop&q=80',
      'gradient': [Color(0xFF1E3C72), Color(0xFF2A5298)],
    },
    {
      'tag': 'EXPRESS BAKERY',
      'title': 'Artisanal Breads & Cakes\nBuy 1 Get 1 Free',
      'buttonText': 'ORDER SNACKS',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&auto=format&fit=crop&q=80',
      'gradient': [Color(0xFFD35400), Color(0xFFF39C12)],
    },
    {
      'tag': 'SUPERFAST 12-MIN DELIVERY',
      'title': 'Instant Grocery At Doorstep\nZero Delivery Fee',
      'buttonText': 'ORDER NOW',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
      'gradient': [Color(0xFF00897B), Color(0xFF4CAF50)],
    },
  ];

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Fruits',
      'imageUrl':
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=300&auto=format&fit=crop&q=80',
      'color': Color(0xFFFFEBEB),
    },
    {
      'name': 'Vegetables',
      'imageUrl':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&auto=format&fit=crop&q=80',
      'color': Color(0xFFEAF8EA),
    },
    {
      'name': 'Dairy',
      'imageUrl':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300&auto=format&fit=crop&q=80',
      'color': Color(0xFFEBF3FF),
    },
    {
      'name': 'Bakery',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&auto=format&fit=crop&q=80',
      'color': Color(0xFFFFF5E6),
    },
    {
      'name': 'Beverages',
      'imageUrl':
          'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=300&auto=format&fit=crop&q=80',
      'color': Color(0xFFFFEEF7),
    },
    {
      'name': 'Snacks',
      'imageUrl':
          'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=300&auto=format&fit=crop&q=80',
      'color': Color(0xFFFFF8E1),
    },
  ];

  final List<Map<String, dynamic>> products = const [
    {
      'id': 'p1',
      'name': 'Royal Gala Apples (Himachal)',
      'brand': 'Farm Fresh',
      'rating': 4.8,
      'reviewsCount': '1.2k',
      'deliveryTime': '12 MINS',
      'tag': 'BESTSELLER',
      'price': '₹120',
      'oldPrice': '₹160',
      'discount': '25% OFF',
      'unit': '1 kg',
      'description':
          'Crisp, juicy & naturally sweet apples direct from Kinnaur orchards. Packed with vitamin C and essential dietary fibers.',
      'imageUrl':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '250 g', 'price': '₹35', 'oldPrice': '₹45'},
        {'weight': '500 g', 'price': '₹65', 'oldPrice': '₹85'},
        {'weight': '1 kg', 'price': '₹120', 'oldPrice': '₹160', 'isPopular': true},
        {'weight': '2 kg', 'price': '₹230', 'oldPrice': '₹300'},
      ],
    },
    {
      'id': 'p2',
      'name': 'Pure Organic Full Cream Milk',
      'brand': 'Amul / Mother Dairy',
      'rating': 4.9,
      'reviewsCount': '3.4k',
      'deliveryTime': '10 MINS',
      'tag': 'DAILY ESSENTIAL',
      'price': '₹60',
      'oldPrice': '₹70',
      'discount': '14% OFF',
      'unit': '1 litre',
      'description':
          'Pasteurized, homogenized & nutrient-rich full cream cow milk. Ideal for tea, coffee, desserts, and daily health.',
      'imageUrl':
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '500 ml', 'price': '₹32', 'oldPrice': '₹36'},
        {'weight': '1 litre', 'price': '₹60', 'oldPrice': '₹70', 'isPopular': true},
        {'weight': '2 litre', 'price': '₹115', 'oldPrice': '₹135'},
      ],
    },
    {
      'id': 'p3',
      'name': 'Artisanal Multigrain Whole Wheat Bread',
      'brand': 'Modern Bakery',
      'rating': 4.7,
      'reviewsCount': '850',
      'deliveryTime': '15 MINS',
      'tag': 'FRESHLY BAKED',
      'price': '₹45',
      'oldPrice': '₹55',
      'discount': '18% OFF',
      'unit': '1 pack (400g)',
      'description':
          'Freshly baked daily using 100% whole wheat flour, oats, flax seeds and zero maida or preservatives.',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '250 g', 'price': '₹28', 'oldPrice': '₹35'},
        {'weight': '1 pack (400g)', 'price': '₹45', 'oldPrice': '₹55', 'isPopular': true},
        {'weight': 'Twin Pack (800g)', 'price': '₹85', 'oldPrice': '₹105'},
      ],
    },
    {
      'id': 'p4',
      'name': 'Fresh Organic Potatoes (Aloo)',
      'brand': 'Local Farmers',
      'rating': 4.6,
      'reviewsCount': '2.1k',
      'deliveryTime': '12 MINS',
      'tag': 'ORGANIC',
      'price': '₹40',
      'oldPrice': '₹50',
      'discount': '20% OFF',
      'unit': '1 kg',
      'description':
          'Clean, washed & chemical-free fresh farm potatoes. Perfect for fries, curries, sabzi, and baking.',
      'imageUrl':
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '500 g', 'price': '₹22', 'oldPrice': '₹28'},
        {'weight': '1 kg', 'price': '₹40', 'oldPrice': '₹50', 'isPopular': true},
        {'weight': '2 kg', 'price': '₹75', 'oldPrice': '₹95'},
        {'weight': '5 kg', 'price': '₹180', 'oldPrice': '₹230'},
      ],
    },
    {
      'id': 'p5',
      'name': 'Fresh Exotic Strawberries',
      'brand': 'Mahabaleshwar Fresh',
      'rating': 4.9,
      'reviewsCount': '980',
      'deliveryTime': '10 MINS',
      'tag': 'SEASONAL SPECIAL',
      'price': '₹180',
      'oldPrice': '₹240',
      'discount': '25% OFF',
      'unit': '200g Box',
      'description':
          'Handpicked, bright red, sweet & juicy premium grade strawberries directly shipped in temperature-controlled boxes.',
      'imageUrl':
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '200 g Box', 'price': '₹180', 'oldPrice': '₹240', 'isPopular': true},
        {'weight': '400 g Pack', 'price': '₹340', 'oldPrice': '₹450'},
      ],
    },
    {
      'id': 'p6',
      'name': 'Farm Fresh Organic Tomatoes (Hybrid)',
      'brand': 'Organic Agro',
      'rating': 4.8,
      'reviewsCount': '1.5k',
      'deliveryTime': '12 MINS',
      'tag': 'FARM FRESH',
      'price': '₹38',
      'oldPrice': '₹50',
      'discount': '24% OFF',
      'unit': '1 kg',
      'description':
          'Ripe, bright red & plump organic tomatoes. Rich in lycopene, vitamin C and perfect for salads, curries, and sauces.',
      'imageUrl':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '500 g', 'price': '₹20', 'oldPrice': '₹26'},
        {'weight': '1 kg', 'price': '₹38', 'oldPrice': '₹50', 'isPopular': true},
        {'weight': '2 kg', 'price': '₹72', 'oldPrice': '₹95'},
      ],
    },
    {
      'id': 'p7',
      'name': 'Fresh Cold-Pressed Valencia Orange Juice',
      'brand': 'Tropicana / Raw Pressery',
      'rating': 4.9,
      'reviewsCount': '720',
      'deliveryTime': '10 MINS',
      'tag': '100% PURE JUICE',
      'price': '₹99',
      'oldPrice': '₹130',
      'discount': '23% OFF',
      'unit': '1 litre',
      'description':
          '100% pure cold pressed orange juice with no added sugar, preservatives or artificial flavors. Rich in natural Vitamin C.',
      'imageUrl':
          'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=800&auto=format&fit=crop&q=80',
      'variants': [
        {'weight': '500 ml', 'price': '₹55', 'oldPrice': '₹70'},
        {'weight': '1 litre', 'price': '₹99', 'oldPrice': '₹130', 'isPopular': true},
      ],
    },
  ];

  UserLocation currentAddress = UserLocation(
    area: 'Lalpur, Main Road',
    city: 'Ranchi',
    state: 'Jharkhand',
    pinCode: '834001',
  );

  int get totalCartItems => CartService.instance.totalItemCount;

  double get totalCartPrice => CartService.instance.subtotal;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(initialPage: 0);
    _startBannerAutoScroll();
    CartService.instance.cartCountNotifier.addListener(_onCartServiceChanged);
  }

  void _onCartServiceChanged() {
    if (mounted) setState(() {});
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        _currentBannerPage = (_currentBannerPage + 1) % heroBanners.length;
        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    CartService.instance.cartCountNotifier.removeListener(_onCartServiceChanged);
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildModularDrawer(),
      backgroundColor: const Color(0xFFF9FAFC),
      extendBody: true,
      body: Stack(
        children: [
          // Subtle Light Background Aesthetics
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB32424).withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFBB616).withValues(alpha: 0.06),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: _buildBody(),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((selectedBottomIndex == 0 || selectedBottomIndex == 1) && totalCartItems > 0)
            _buildCartBottomPopup(),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    Widget activePage;
    switch (selectedBottomIndex) {
      case 1:
        activePage = CategoriesScreen(
          key: const ValueKey(1),
          onBackPressed: () {
            setState(() {
              selectedBottomIndex = 0;
            });
          },
        );
        break;
      case 2:
        activePage = CartScreen(
          key: const ValueKey(2),
          onBackPressed: () {
            setState(() {
              selectedBottomIndex = 0;
            });
          },
        );
        break;
      case 3:
        activePage = const ProfileScreen(key: ValueKey(3));
        break;
      case 0:
      default:
        activePage = RefreshIndicator(
          color: const Color(0xFFB32424),
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 800));
            if (mounted) setState(() {});
          },
          child: CustomScrollView(
            key: const ValueKey(0),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Top Modern App Bar Header
              SliverToBoxAdapter(
                child: _buildTopHeader(),
              ),

              // Sticky Pinned Search Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickySearchBarDelegate(
                  child: _buildSearchBarWithVoice(),
                ),
              ),

              // Full Top Hero Promotional Auto-Scrolling Banner
              SliverToBoxAdapter(
                child: _buildAutoScrollingBanner(),
              ),

              // Categories Section Header
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  title: 'Categories',
                  subtitle: 'Explore fresh groceries by type',
                  onSeeAll: () {
                    setState(() {
                      selectedBottomIndex = 1;
                    });
                  },
                ),
              ),

              // Categories Horizontal List
              SliverToBoxAdapter(
                child: _buildCategoriesList(),
              ),

              // Food/Grocery Feed Section Header
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  title: 'Fresh Feed & Popular Deals',
                  subtitle: 'Top quality groceries delivered in mins',
                  onSeeAll: () {},
                ),
              ),

              // ZOMATO-STYLE VERTICAL STACKED CARDS FEED
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = products[index];
                      final String id = item['id'] as String;
                      final int qty = CartService.instance.getQuantityForProduct(id);

                      return _buildZomatoStyleProductCard(
                        product: item,
                        quantity: qty,
                        onAddTap: () => _showWeightSelectionBottomSheet(item),
                        onIncrement: () {
                          final currentVar = selectedVariants[id] ?? (item['unit'] as String);
                          final priceStr = (item['price'] as String).replaceAll('₹', '').trim();
                          final double priceVal = double.tryParse(priceStr) ?? 99.0;

                          CartService.instance.addItem(
                            id: id,
                            name: item['name'] as String,
                            unit: currentVar,
                            price: priceVal,
                            imageUrl: item['imageUrl'] as String,
                          );
                          setState(() {
                            cartQuantities[id] = CartService.instance.getQuantityForProduct(id);
                          });
                        },
                        onDecrement: () {
                          final itemsList = CartService.instance.items;
                          final idx = itemsList.indexWhere((it) => it.id == id);
                          if (idx != -1) {
                            CartService.instance.updateQuantity(idx, -1);
                          }
                          setState(() {
                            cartQuantities[id] = CartService.instance.getQuantityForProduct(id);
                          });
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          ),
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: activePage,
    );
  }

  // ----------------------------------------------------------
  // TOP HEADER
  // ----------------------------------------------------------

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Drawer Button
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEBECEF)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_rounded,
                  color: Color(0xFFB32424),
                  size: 24,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Express Delivery & Address Selector
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => LocationPickerSheet(
                    currentLocation: currentAddress,
                    onLocationSelected: (newLocation) {
                      setState(() {
                        currentAddress = newLocation;
                      });
                    },
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFB32424).withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt,
                              size: 13,
                              color: Color(0xFFB32424),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '12 MINS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB32424),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Deliver to',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFFB32424),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          currentAddress.fullAddress,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Notification Bell
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFFB32424),
                      size: 24,
                    ),
                  ),
                  Positioned(
                    top: 9,
                    right: 9,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBB616),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // User Profile Avatar
          GestureDetector(
            onTap: () {
              setState(() {
                selectedBottomIndex = 3;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFBB616),
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    color: Color(0xFFB32424),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SEARCH BAR WITH VOICE
  // ----------------------------------------------------------

  Widget _buildSearchBarWithVoice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search "apples, milk, bread, strawberries..."',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFFB32424),
              size: 22,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.mic_none_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice search listening...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB32424),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // AUTO-SCROLLING MODULAR HERO BANNER
  // ----------------------------------------------------------

  Widget _buildAutoScrollingBanner() {
    return Column(
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.only(top: 4),
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerPage = index;
              });
            },
            itemCount: heroBanners.length,
            itemBuilder: (context, index) {
              final banner = heroBanners[index];
              final List<Color> gradientColors =
                  banner['gradient'] as List<Color>;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background Decorative Patterns
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Image Banner Container (Fixed Ratio & Verified Unsplash Image)
                      Positioned(
                        right: 12,
                        top: 14,
                        bottom: 14,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 135,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Image.network(
                              banner['imageUrl'] as String,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Banner Text
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 155, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBB616),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                banner['tag'] as String,
                                style: const TextStyle(
                                  color: Color(0xFF20213A),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              banner['title'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                banner['buttonText'] as String,
                                style: TextStyle(
                                  color: gradientColors[0],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
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
            },
          ),
        ),

        const SizedBox(height: 12),

        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            heroBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentBannerPage == index ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _currentBannerPage == index
                    ? const Color(0xFFB32424)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // SECTION HEADER
  // ----------------------------------------------------------

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFFB32424),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFFB32424),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CATEGORIES HORIZONTAL LIST
  // ----------------------------------------------------------

  Widget _buildCategoriesList() {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final imageUrl = category['imageUrl'] as String;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedBottomIndex = 1;
              });
            },
            child: Container(
              width: 82,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: category['color'] as Color,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFFFF7E0),
                          child: const Icon(
                            Icons.category,
                            color: Color(0xFFB32424),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    category['name'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // ZOMATO-STYLE VERTICAL FEED PRODUCT CARD
  // ----------------------------------------------------------

  Widget _buildZomatoStyleProductCard({
    required Map<String, dynamic> product,
    required int quantity,
    required VoidCallback onAddTap,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    final String id = product['id'] as String;
    final String imageUrl = product['imageUrl'] as String;
    final String currentVariant = selectedVariants[id] ?? (product['unit'] as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Header Banner Image Section
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.details,
                arguments: product,
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: const Color(0xFFFFF8F0),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.medium,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return const Center(
                          child: SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFB32424),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 50,
                            color: Color(0xFFB32424),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Top Subtle Dark Gradient Overlay for Badges Contrast
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Delivery Time Pill
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt,
                          size: 14,
                          color: Color(0xFFB32424),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product['deliveryTime'] as String,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB32424),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tag Badge (Bestseller/Organic/etc.)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBB616),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product['tag'] as String,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF20213A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Discount Pill on Image Bottom Left
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB32424),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product['discount'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Quick Add Floating Plus (+) Button on Image
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _QuickAddFloatingPlusButton(
                    quantity: quantity,
                    onTap: () {
                      onIncrement();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFFFBB616), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Added "${product['name']}" to cart',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFFB32424),
                          duration: const Duration(milliseconds: 1400),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: const Color(0xFFFBB616),
                            onPressed: () {
                              setState(() {
                                selectedBottomIndex = 2;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Rich Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating & Brand Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['brand'] as String,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${product['rating']} (${product['reviewsCount']})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Title
                Text(
                  product['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 6),

                // Rich Description Text
                Text(
                  product['description'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 12),

                // Selected Weight Variant Chip Selector
                GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E4E8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.scale_outlined,
                          size: 14,
                          color: Color(0xFFB32424),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Pack: $currentVariant',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF20213A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                const SizedBox(height: 12),

                // Price & ADD Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          product['price'] as String,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB32424),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product['oldPrice'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),

                    // Zomato Style ADD Button / Quantity Counter with Animation
                    _AnimatedAddCartButton(
                      quantity: quantity,
                      onAddTap: onAddTap,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // WEIGHT VARIANT SELECTION POPUP BOTTOM SHEET
  // ----------------------------------------------------------

  void _showWeightSelectionBottomSheet(Map<String, dynamic> product) {
    final String productId = product['id'] as String;
    final List<dynamic> variantsList = (product['variants'] as List<dynamic>?) ??
        [
          {'weight': '250 g', 'price': '₹35', 'oldPrice': '₹45'},
          {'weight': '500 g', 'price': '₹65', 'oldPrice': '₹85'},
          {'weight': '1 kg', 'price': '₹120', 'oldPrice': '₹160', 'isPopular': true},
          {'weight': '2 kg', 'price': '₹230', 'oldPrice': '₹300'},
        ];

    int selectedIndex = 0;
    // Preselect current variant if exists
    final currentVar = selectedVariants[productId];
    if (currentVar != null) {
      final foundIdx = variantsList.indexWhere((v) => v['weight'] == currentVar);
      if (foundIdx != -1) selectedIndex = foundIdx;
    } else {
      final popularIdx = variantsList.indexWhere((v) => v['isPopular'] == true);
      if (popularIdx != -1) selectedIndex = popularIdx;
    }

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
                              product['imageUrl'] as String,
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
                                  product['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172033),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Select Quantity / Pack Size',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
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
                              final double priceVal = double.tryParse(priceStr) ?? 99.0;

                              CartService.instance.addItem(
                                id: productId,
                                name: product['name'] as String,
                                unit: chosenVariant,
                                price: priceVal,
                                imageUrl: product['imageUrl'] as String,
                              );

                              setState(() {
                                selectedVariants[productId] = chosenVariant;
                                cartQuantities[productId] =
                                    CartService.instance.getQuantityForProduct(productId);
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Added ${product['name']} ($chosenVariant) to cart!'),
                                  backgroundColor: const Color(0xFF2E7D32),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
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
                              final double priceVal = double.tryParse(priceStr) ?? 99.0;

                              CartService.instance.addItem(
                                id: productId,
                                name: product['name'] as String,
                                unit: chosenVariant,
                                price: priceVal,
                                imageUrl: product['imageUrl'] as String,
                              );

                              setState(() {
                                selectedVariants[productId] = chosenVariant;
                                cartQuantities[productId] =
                                    CartService.instance.getQuantityForProduct(productId);
                                selectedBottomIndex = 2; // Jump directly to Cart Screen!
                              });

                              Navigator.pop(context);
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

  // ----------------------------------------------------------
  // MODULAR DRAWER
  // ----------------------------------------------------------

  Widget _buildModularDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 20,
              20,
              22,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB32424), Color(0xFFD74632)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: const Color(0xFFFBB616), width: 2),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBB616),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.workspace_premium_rounded,
                              size: 14, color: Color(0xFFB32424)),
                          SizedBox(width: 4),
                          Text(
                            'GOLD VIP',
                            style: TextStyle(
                              color: Color(0xFFB32424),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Ujjwal Kumar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'ujjwal.kumar@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.stars_rounded,
                              color: Color(0xFFFBB616), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'SuperCoins Balance',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                      Text(
                        '250 PTS',
                        style: TextStyle(
                          color: Color(0xFFFBB616),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              children: [
                _buildDrawerSectionTitle('NAVIGATION'),
                _buildDrawerMenuItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  title: 'Home',
                  isSelected: selectedBottomIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => selectedBottomIndex = 0);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.grid_view_outlined,
                  activeIcon: Icons.grid_view_rounded,
                  title: 'Categories',
                  isSelected: selectedBottomIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => selectedBottomIndex = 1);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  title: 'My Cart',
                  badgeCount: totalCartItems > 0 ? '$totalCartItems' : null,
                  isSelected: selectedBottomIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => selectedBottomIndex = 2);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  title: 'My Orders',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.orders);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.favorite_outline_rounded,
                  activeIcon: Icons.favorite_rounded,
                  title: 'Wishlist',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.wishlist);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildDrawerSectionTitle('SERVICES & PAYMENTS'),
                _buildDrawerMenuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  activeIcon: Icons.account_balance_wallet_rounded,
                  title: 'Wallet & Add Money',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.addMoney);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.payment_outlined,
                  activeIcon: Icons.payment_rounded,
                  title: 'Payment Methods',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.paymentMethod);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.notifications_none_rounded,
                  activeIcon: Icons.notifications_rounded,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.headset_mic_outlined,
                  activeIcon: Icons.headset_mic_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.helpSupport);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildDrawerSectionTitle('ACCOUNT'),
                _buildDrawerMenuItem(
                  icon: Icons.location_on_outlined,
                  activeIcon: Icons.location_on_rounded,
                  title: 'Delivery Addresses',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.deliveryAddress);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  title: 'Profile & Address',
                  isSelected: selectedBottomIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => selectedBottomIndex = 3);
                  },
                ),
                _buildDrawerMenuItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  textColor: const Color(0xFFD32F2F),
                  iconColor: const Color(0xFFD32F2F),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Super Value Market',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'v1.0.2',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFB32424),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    IconData? activeIcon,
    required String title,
    bool isSelected = false,
    String? badgeCount,
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final effectiveIcon = isSelected && activeIcon != null ? activeIcon : icon;

    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF0F0) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Icon(
          effectiveIcon,
          size: 21,
          color: iconColor ??
              (isSelected ? const Color(0xFFB32424) : Colors.grey.shade700),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: textColor ??
                (isSelected
                    ? const Color(0xFFB32424)
                    : const Color(0xFF20213A)),
          ),
        ),
        trailing: badgeCount != null
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFB32424),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeCount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Colors.black26,
              ),
        onTap: onTap,
      ),
    );
  }

  // ----------------------------------------------------------
  // FLOATING CART BOTTOM POPUP
  // ----------------------------------------------------------

  Widget _buildCartBottomPopup() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: totalCartItems > 0 ? Offset.zero : const Offset(0, 1.5),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB32424), Color(0xFF8C1313)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB32424).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '$totalCartItems',
                    style: const TextStyle(
                      color: Color(0xFFB32424),
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$totalCartItems ${totalCartItems == 1 ? 'Item' : 'Items'} Added',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total: ₹${totalCartPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedBottomIndex = 2;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Cart',
                      style: TextStyle(
                        color: Color(0xFFB32424),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFFB32424),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // FROSTED GLASS FLOATING BOTTOM NAVIGATION
  // ----------------------------------------------------------

  Widget _buildBottomNavigation() {
    final navItems = const [
      {'label': 'Home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home},
      {
        'label': 'Categories',
        'icon': Icons.category_outlined,
        'activeIcon': Icons.category
      },
      {
        'label': 'Cart',
        'icon': Icons.shopping_cart_outlined,
        'activeIcon': Icons.shopping_cart
      },
      {
        'label': 'Profile',
        'icon': Icons.person_outline,
        'activeIcon': Icons.person
      },
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, bottomPadding > 0 ? bottomPadding : 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final isSelected = selectedBottomIndex == index;
                final item = navItems[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBottomIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16 : 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB32424).withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected
                                ? item['activeIcon'] as IconData
                                : item['icon'] as IconData,
                            color: isSelected
                                ? const Color(0xFFB32424)
                                : Colors.grey.shade700,
                            size: 22,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isSelected ? 1.0 : 0.0,
                            child: Text(
                              item['label'] as String,
                              style: const TextStyle(
                                color: Color(0xFFB32424),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// STICKY SEARCH BAR HEADER DELEGATE
// ----------------------------------------------------------

class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool isPinned = shrinkOffset > 5;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isPinned ? Colors.white : const Color(0xFFF9FAFC),
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  double get maxExtent => 68.0;

  @override
  double get minExtent => 68.0;

  @override
  bool shouldRebuild(covariant _StickySearchBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

// ----------------------------------------------------------
// ANIMATED ADD TO CART BUTTON WITH SPRING & POP EFFECT
// ----------------------------------------------------------

class _AnimatedAddCartButton extends StatefulWidget {
  final int quantity;
  final VoidCallback onAddTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _AnimatedAddCartButton({
    required this.quantity,
    required this.onAddTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<_AnimatedAddCartButton> createState() => _AnimatedAddCartButtonState();
}

class _AnimatedAddCartButtonState extends State<_AnimatedAddCartButton>
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
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.76), weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.76, end: 1.25), weight: 40),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.25, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _floatSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1.6),
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

  void _triggerAddAnimation(VoidCallback callback) {
    _scaleController.forward(from: 0.0);
    setState(() {
      _showPlusOne = true;
    });
    _floatController.forward(from: 0.0);
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            height: 40,
            width: 110,
            child: widget.quantity == 0
                ? ElevatedButton(
                    onPressed: () => _triggerAddAnimation(widget.onAddTap),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF0F0),
                      foregroundColor: const Color(0xFFB32424),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xFFB32424),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ADD',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.add_rounded, size: 17),
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFB32424),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFFB32424).withValues(alpha: 0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: widget.onDecrement,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Icon(
                              Icons.remove_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Text(
                            '${widget.quantity}',
                            key: ValueKey<int>(widget.quantity),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _triggerAddAnimation(widget.onIncrement),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),

        // Floating "+1" Pop Particle Animation
        if (_showPlusOne)
          Positioned(
            top: -14,
            right: 18,
            child: SlideTransition(
              position: _floatSlideAnimation,
              child: FadeTransition(
                opacity: _floatFadeAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
    );
  }
}

// ----------------------------------------------------------
// QUICK ADD FLOATING PLUS (+) BUTTON ON PRODUCT BANNER IMAGE
// ----------------------------------------------------------

class _QuickAddFloatingPlusButton extends StatefulWidget {
  final int quantity;
  final VoidCallback onTap;

  const _QuickAddFloatingPlusButton({
    required this.quantity,
    required this.onTap,
  });

  @override
  State<_QuickAddFloatingPlusButton> createState() =>
      _QuickAddFloatingPlusButtonState();
}

class _QuickAddFloatingPlusButtonState
    extends State<_QuickAddFloatingPlusButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.75), weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.75, end: 1.3), weight: 40),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.3, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.quantity > 0
                ? const Color(0xFF2E7D32)
                : const Color(0xFFB32424),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (widget.quantity > 0
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFB32424))
                    .withValues(alpha: 0.45),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.quantity > 0
                    ? Icons.check_rounded
                    : Icons.add_rounded,
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                widget.quantity > 0
                    ? '${widget.quantity} IN CART'
                    : 'QUICK ADD',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

