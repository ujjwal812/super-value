import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    this.totalAmount = 290.0,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  int selectedDeliverySlot = 0; // 0 = Instant, 1 = Evening
  String selectedPayment = 'UPI';

  late AnimationController _animationController;

  final List<Map<String, dynamic>> orderItems = [
    {
      'name': 'Fresh Apples',
      'qty': '2 kg',
      'price': '₹240',
      'imageUrl':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Fresh Milk',
      'qty': '1 L',
      'price': '₹60',
      'imageUrl':
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&auto=format&fit=crop&q=80',
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

  Widget _animatedItem(int index, Widget child) {
    final Animation<double> animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (index * 0.10).clamp(0.0, 0.6),
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
            offset: Offset(0, 24 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Card
              _animatedItem(0, _buildAddressCard()),

              const SizedBox(height: 18),

              // Delivery Slot Selector
              _animatedItem(1, _buildDeliverySlotCard()),

              const SizedBox(height: 18),

              // Items Summary
              _animatedItem(2, _buildOrderItemsCard()),

              const SizedBox(height: 18),

              // Bill Breakdown
              _animatedItem(3, _buildBillCard()),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFFB32424),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Change Address clicked')),
                  );
                },
                child: const Text(
                  'CHANGE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB32424),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          const Text(
            'Ujjwal Kumar • +91 98765 43210',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'House No. 12, Main Road, Lalpur, Ranchi, Jharkhand - 834001',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySlotCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Delivery Time',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _slotOptionTile(
                  index: 0,
                  title: 'Instant Delivery',
                  subtitle: '15 - 25 Mins',
                  icon: Icons.bolt,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _slotOptionTile(
                  index: 1,
                  title: 'Evening Slot',
                  subtitle: '6 PM - 8 PM',
                  icon: Icons.schedule,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slotOptionTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedDeliverySlot == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDeliverySlot = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFF0F0)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFB32424) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFFB32424),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary (2 Items)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: orderItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['imageUrl'] as String,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['qty'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item['price'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB32424),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _billRow('Items Total', '₹300.00'),
          const SizedBox(height: 6),
          _billRow('Delivery Fee', 'FREE', isHighlight: true),
          const SizedBox(height: 6),
          _billRow('Discount', '-₹10.00', isDiscount: true),
          const Divider(height: 20),
          _billRow('To Pay', '₹${widget.totalAmount.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _billRow(
    String label,
    String value, {
    bool isBold = false,
    bool isDiscount = false,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold || isDiscount ? FontWeight.bold : FontWeight.w600,
            color: isDiscount || isHighlight
                ? Colors.green
                : isBold
                    ? const Color(0xFFB32424)
                    : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                '₹${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB32424),
                ),
              ),
            ],
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.payment,
                arguments: widget.totalAmount,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB32424),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'PROCEED TO PAY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
