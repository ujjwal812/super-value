import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  // Brand Theme Colors
  final Color primaryRed = const Color(0xFFB32424);
  final Color primaryYellow = const Color(0xFFFBB616);
  final Color backgroundColor = const Color(0xFFF6F7F9);

  late AnimationController _animationController;
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Active', 'Delivered', 'Cancelled'];

  // Active Order State
  Map<String, dynamic> activeOrder = {
    'orderId': '#SV1002',
    'status': 'On the way',
    'estimatedTime': '12-20 mins • Today',
    'deliveryPartner': {
      'name': 'Ramesh Kumar',
      'rating': '4.9 ★',
      'phone': '+91 98765 43210',
    },
    'items': [
      {
        'id': 'a1',
        'name': 'Fresh Apples',
        'unit': '1 kg',
        'price': 120.0,
        'quantity': 1,
        'imageUrl':
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200&auto=format&fit=crop&q=80',
      },
      {
        'id': 'a2',
        'name': 'Fresh Milk',
        'unit': '1 litre',
        'price': 60.0,
        'quantity': 2,
        'imageUrl':
            'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&auto=format&fit=crop&q=80',
      },
      {
        'id': 'a3',
        'name': 'Fresh Bread',
        'unit': '1 pack',
        'price': 45.0,
        'quantity': 1,
        'imageUrl':
            'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=200&auto=format&fit=crop&q=80',
      },
      {
        'id': 'a4',
        'name': 'Organic Potato',
        'unit': '1 kg',
        'price': 40.0,
        'quantity': 1,
        'imageUrl':
            'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200&auto=format&fit=crop&q=80',
      },
    ],
    'paymentMode': 'Cash on Delivery',
  };

  // Past Orders List with Image URLs
  final List<Map<String, dynamic>> pastOrders = [
    {
      'orderId': '#SV1001',
      'date': '08 Oct 2026 • 04:30 PM',
      'status': 'Delivered',
      'imageUrl':
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=200&auto=format&fit=crop&q=80',
      'items': [
        {
          'id': 'p1',
          'name': 'Fresh Apples',
          'unit': '1 kg',
          'price': 120.0,
          'quantity': 2,
          'imageUrl':
              'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200&auto=format&fit=crop&q=80'
        },
        {
          'id': 'p2',
          'name': 'Fresh Milk',
          'unit': '1 litre',
          'price': 60.0,
          'quantity': 1,
          'imageUrl':
              'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&auto=format&fit=crop&q=80'
        },
        {
          'id': 'p3',
          'name': 'Fresh Bread',
          'unit': '1 pack',
          'price': 45.0,
          'quantity': 1,
          'imageUrl':
              'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=200&auto=format&fit=crop&q=80'
        },
      ],
    },
    {
      'orderId': '#SV1000',
      'date': '05 Oct 2026 • 11:15 AM',
      'status': 'Delivered',
      'imageUrl':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&auto=format&fit=crop&q=80',
      'items': [
        {
          'id': 'p4',
          'name': 'Organic Potatoes',
          'unit': '2 kg',
          'price': 80.0,
          'quantity': 2,
          'imageUrl':
              'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200&auto=format&fit=crop&q=80'
        },
        {
          'id': 'p5',
          'name': 'Fresh Vegetables Pack',
          'unit': '1 kg',
          'price': 90.0,
          'quantity': 1,
          'imageUrl':
              'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&auto=format&fit=crop&q=80'
        },
      ],
    },
    {
      'orderId': '#SV0999',
      'date': '02 Oct 2026 • 07:45 PM',
      'status': 'Cancelled',
      'imageUrl':
          'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=200&auto=format&fit=crop&q=80',
      'items': [
        {
          'id': 'p6',
          'name': 'Milk & Bread Combo',
          'unit': '1 pack',
          'price': 105.0,
          'quantity': 1,
          'imageUrl':
              'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=200&auto=format&fit=crop&q=80'
        },
        {
          'id': 'p7',
          'name': 'Evening Snacks',
          'unit': '1 pack',
          'price': 170.0,
          'quantity': 1,
          'imageUrl':
              'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=200&auto=format&fit=crop&q=80'
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateItemsTotal(List<dynamic> items) {
    return items.fold(0.0, (sum, item) => sum + ((item['price'] as double) * (item['quantity'] as int)));
  }

  void _removeItemFromActiveOrder(int index) {
    setState(() {
      final List<dynamic> items = activeOrder['items'] as List<dynamic>;
      final removedItem = items[index];
      items.removeAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${removedItem['name']} removed from active order'),
          backgroundColor: primaryRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _reorder(String orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items from $orderId added to your cart!'),
        backgroundColor: primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> activeItems = activeOrder['items'] as List<dynamic>;
    final bool hasActiveOrder = activeItems.isNotEmpty;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF20213A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'My Orders',
              style: TextStyle(
                color: Color(0xFF20213A),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryRed.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Text(
                hasActiveOrder ? '1 Active' : '0 Active',
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.headset_mic_outlined,
              color: primaryRed,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connecting to Customer Support...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryRed,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 800));
            if (mounted) setState(() {});
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Filter Pills Bar
              SliverToBoxAdapter(
                child: _animatedItem(0, _buildFilterChips()),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: _animatedItem(1, _buildSearchSection()),
              ),

              // Active Order Live Tracking Section
              if ((selectedFilter == 'All' || selectedFilter == 'Active') && hasActiveOrder)
                SliverToBoxAdapter(
                  child: _animatedItem(2, _buildActiveOrderCard()),
                ),

              // Past Orders Section Title
              SliverToBoxAdapter(
                child: _animatedItem(3, _buildSectionTitle('Past Orders')),
              ),

              // Past Orders List
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = pastOrders[index];
                      if (selectedFilter == 'Delivered' && order['status'] != 'Delivered') {
                        return const SizedBox();
                      }
                      if (selectedFilter == 'Cancelled' && order['status'] != 'Cancelled') {
                        return const SizedBox();
                      }

                      return _animatedItem(
                        4 + index,
                        _buildPastOrderCard(order),
                      );
                    },
                    childCount: pastOrders.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FILTER CHIPS BAR
  // ------------------------------------------------------------

  Widget _buildFilterChips() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? primaryRed : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryRed.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // SEARCH SECTION
  // ------------------------------------------------------------

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search order ID or items...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFFB32424),
              size: 22,
            ),
            suffixIcon: Icon(
              Icons.tune_rounded,
              color: primaryRed,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ACTIVE ORDER CARD (LIVE TRACKING)
  // ------------------------------------------------------------

  Widget _buildActiveOrderCard() {
    final List<dynamic> activeItems = activeOrder['items'] as List<dynamic>;
    final double totalAmount = _calculateItemsTotal(activeItems);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB32424),
              Color(0xFFD74632),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryRed.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Row
            Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.delivery_dining_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: Color(0xFFFBB616), size: 14),
                          SizedBox(width: 2),
                          Text(
                            'EXPRESS DELIVERY',
                            style: TextStyle(
                              color: Color(0xFFFBB616),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order ${activeOrder['orderId']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        activeOrder['status'] as String,
                        style: TextStyle(
                          color: primaryRed,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Expected Time Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_filled_rounded,
                    color: Color(0xFFFBB616),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Arriving in ${activeOrder['estimatedTime']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stepper Progress Line
            _buildOrderProgressStepper(),

            const SizedBox(height: 20),

            // Delivery Partner Info Row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_pin_circle_rounded,
                        color: primaryRed,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeOrder['deliveryPartner']['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Delivery Partner • ${activeOrder['deliveryPartner']['rating']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.call_rounded, size: 17, color: primaryRed),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${activeOrder['deliveryPartner']['name']}...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TWO ACTION BUTTONS (TRACK LIVE ORDER & VIEW/REMOVE ITEMS)
            Row(
              children: [
                // Live Tracking Button
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLiveTrackingModal(context),
                      icon: const Icon(Icons.my_location_rounded, size: 16),
                      label: const Text(
                        'Track Live',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBB616),
                        foregroundColor: const Color(0xFFB32424),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // View Items & Remove Button
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: () => _showActiveOrderItemsModal(context),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: Text(
                        'Items (${activeItems.length})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Order Total Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Total',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // STEPPER PROGRESS
  // ------------------------------------------------------------

  Widget _buildOrderProgressStepper() {
    return Row(
      children: [
        _progressStep(icon: Icons.check_rounded, title: 'Placed', active: true),
        _progressLine(active: true),
        _progressStep(icon: Icons.inventory_2_outlined, title: 'Packed', active: true),
        _progressLine(active: true),
        _progressStep(
          icon: Icons.delivery_dining_rounded,
          title: 'On Way',
          active: true,
        ),
        _progressLine(active: false),
        _progressStep(icon: Icons.home_outlined, title: 'Delivered', active: false),
      ],
    );
  }

  Widget _progressStep({
    required IconData icon,
    required String title,
    required bool active,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: active ? primaryYellow : Colors.white.withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: active ? primaryRed : Colors.white54,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.white54,
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _progressLine({required bool active}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18, left: 3, right: 3),
        height: 2.5,
        color: active ? primaryYellow : Colors.white.withValues(alpha: 0.25),
      ),
    );
  }

  // ------------------------------------------------------------
  // MODAL: VIEW & REMOVE ACTIVE ORDER ITEMS (WITH INTERNET IMAGES)
  // ------------------------------------------------------------

  void _showActiveOrderItemsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final List<dynamic> items = activeOrder['items'] as List<dynamic>;
            final double currentTotal = _calculateItemsTotal(items);

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Modal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Order Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF20213A),
                            ),
                          ),
                          Text(
                            'Tap trash icon to remove items',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${items.length} Items',
                          style: TextStyle(
                            color: primaryRed,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Items List with Images
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'All items removed from order.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final itemTotal = (item['price'] as double) * (item['quantity'] as int);
                          final imageUrl = item['imageUrl'] as String?;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                // Item Network Image
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF0F0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Icon(
                                              Icons.shopping_bag_outlined,
                                              color: primaryRed,
                                              size: 20,
                                            ),
                                          )
                                        : Icon(
                                            Icons.shopping_bag_outlined,
                                            color: primaryRed,
                                            size: 20,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      Text(
                                        '${item['unit']} x ${item['quantity']}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${itemTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryRed,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _removeItemFromActiveOrder(index);
                                    setModalState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Total Row & Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payable Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${currentTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryRed,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // MODAL: LIVE ORDER TRACKING
  // ------------------------------------------------------------

  void _showLiveTrackingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Order Tracking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF20213A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7EF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: Color(0xFF2E7D32), size: 14),
                        SizedBox(width: 3),
                        Text(
                          'On Schedule',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Simulated GPS Map Card
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryYellow),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.my_location_rounded,
                        color: primaryRed,
                        size: 36,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Delivery Partner 1.2 km away',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF20213A),
                        ),
                      ),
                      const Text(
                        'Arriving in ~12 mins at Lalpur, Main Road',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Delivery Partner Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8EAEF)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFF0F0),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_pin_circle_rounded,
                          color: primaryRed,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeOrder['deliveryPartner']['name'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Delivery Agent • ${activeOrder['deliveryPartner']['rating']}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${activeOrder['deliveryPartner']['name']}...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.call, size: 14),
                      label: const Text('Call', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF20213A),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close Tracking'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF20213A),
            ),
          ),
          Text(
            '${pastOrders.length} Orders',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PAST ORDER CARD (WITH NETWORK IMAGE THUMBNAIL)
  // ------------------------------------------------------------

  Widget _buildPastOrderCard(Map<String, dynamic> order) {
    final List<dynamic> items = order['items'] as List<dynamic>;
    final double totalAmount = _calculateItemsTotal(items);
    final String? imageUrl = order['imageUrl'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Image Container with Image.network
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.shopping_basket_outlined,
                            color: primaryRed,
                            size: 25,
                          ),
                        )
                      : Icon(
                          Icons.shopping_basket_outlined,
                          color: primaryRed,
                          size: 25,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order['orderId'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF20213A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: order['status'] == 'Delivered'
                                ? const Color(0xFFEAF7EF)
                                : const Color(0xFFFFF0F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order['status'] as String,
                            style: TextStyle(
                              color: order['status'] == 'Delivered'
                                  ? const Color(0xFF2E7D32)
                                  : primaryRed,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items.map((i) => i['name'] as String).join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      order['date'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF0F1F5)),
          ),

          // Bottom Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showPastOrderItemsModal(context, order),
                    icon: const Icon(Icons.list_alt_rounded, size: 14),
                    label: const Text(
                      'View Items',
                      style: TextStyle(fontSize: 11),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF20213A),
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    onPressed: () => _reorder(order['orderId'] as String),
                    icon: const Icon(Icons.refresh_rounded, size: 14),
                    label: const Text(
                      'Re-order',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // MODAL: VIEW PAST ORDER ITEMS (WITH NETWORK IMAGES)
  // ------------------------------------------------------------

  void _showPastOrderItemsModal(BuildContext context, Map<String, dynamic> order) {
    final List<dynamic> items = order['items'] as List<dynamic>;
    final double totalAmount = _calculateItemsTotal(items);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Items (${order['orderId']})',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF20213A),
                    ),
                  ),
                  Text(
                    order['status'] as String,
                    style: TextStyle(
                      color: order['status'] == 'Delivered'
                          ? const Color(0xFF2E7D32)
                          : primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),

              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final itemTotal = (item['price'] as double) * (item['quantity'] as int);
                    final imageUrl = item['imageUrl'] as String?;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.shopping_bag_outlined,
                                        color: primaryRed,
                                        size: 18,
                                      ),
                                    )
                                  : Icon(
                                      Icons.shopping_bag_outlined,
                                      color: primaryRed,
                                      size: 18,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${item['unit']} x ${item['quantity']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${itemTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryRed,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Paid',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryRed,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _reorder(order['orderId'] as String);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Re-order These Items'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // ANIMATIONS
  // ------------------------------------------------------------

  Widget _animatedItem(int index, Widget child) {
    final Animation<double> animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (index * 0.08).clamp(0.0, 0.7),
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}
