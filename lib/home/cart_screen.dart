import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const CartScreen({
    super.key,
    this.onBackPressed,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController promoController = TextEditingController();
  bool isPromoApplied = false;
  double discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    CartService.instance.cartCountNotifier.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    CartService.instance.cartCountNotifier.removeListener(_onCartChanged);
    promoController.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {
        if (isPromoApplied) {
          discountAmount = CartService.instance.subtotal * 0.20;
        }
      });
    }
  }

  double get subtotal => CartService.instance.subtotal;

  double get deliveryFee {
    if (subtotal == 0) return 0.0;
    return subtotal > 200 ? 0.0 : 30.0;
  }

  double get total => (subtotal - discountAmount + deliveryFee).clamp(0.0, double.infinity);

  void applyPromo() {
    final code = promoController.text.trim().toUpperCase();
    if (subtotal == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add items to cart to apply promo code')),
      );
      return;
    }

    if (code == 'SUPER20' || code == 'FRESH20') {
      setState(() {
        isPromoApplied = true;
        discountAmount = subtotal * 0.20; // 20% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo code applied successfully! (20% OFF)'),
          backgroundColor: Color(0xFFB32424),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code. Try "SUPER20"'),
        ),
      );
    }
  }

  void updateQuantity(int index, int delta) {
    CartService.instance.updateQuantity(index, delta);
  }

  void removeItem(int index) {
    final items = CartService.instance.items;
    if (index >= 0 && index < items.length) {
      final removedName = items[index].name;
      CartService.instance.removeItem(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$removedName removed from cart'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void clearAllCart() {
    CartService.instance.clearCart();
    setState(() {
      isPromoApplied = false;
      discountAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.instance.items;

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
          'My Cart',
          style: TextStyle(
            color: Color(0xFF172033),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Color(0xFFB32424),
              ),
              onPressed: clearAllCart,
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF9FAFC),
        width: double.infinity,
        height: double.infinity,
        child: items.isEmpty ? _buildEmptyCart() : _buildCartContent(items),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 65,
                color: Color(0xFFB32424),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore fresh groceries and add items to your cart.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onBackPressed != null) {
                    widget.onBackPressed!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB32424),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'START SHOPPING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(List<CartItem> items) {
    return RefreshIndicator(
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildCartItemCard(item, index);
              },
            ),

            const SizedBox(height: 20),

            // Promo Code Box
            _buildPromoCard(),

            const SizedBox(height: 20),

            // Payment Summary
            _buildPaymentSummaryCard(),

            const SizedBox(height: 20),

            // Checkout Action Card
            _buildCheckoutCard(),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, int index) {
    final double itemTotal = item.price * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Container
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
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

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pack: ${item.unit}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${itemTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB32424),
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Row(
            children: [
              _buildQtyButton(
                icon: Icons.remove,
                onTap: () => updateQuantity(index, -1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildQtyButton(
                icon: Icons.add,
                onTap: () => updateQuantity(index, 1),
              ),
            ],
          ),

          const SizedBox(width: 6),

          // Delete button
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: () => removeItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFB32424).withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFFB32424),
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promo Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: promoController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter SUPER20',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    prefixIcon: const Icon(
                      Icons.local_offer_outlined,
                      color: Color(0xFFB32424),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: applyPromo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB32424),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                child: Text(
                  isPromoApplied ? 'APPLIED' : 'APPLY',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Item Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Promo Discount (20%)',
              '-₹${discountAmount.toStringAsFixed(2)}',
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 8),
          _summaryRow(
            'Delivery Charge',
            deliveryFee == 0 ? 'FREE' : '₹${deliveryFee.toStringAsFixed(2)}',
            isHighlight: deliveryFee == 0,
          ),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _summaryRow(
            'Grand Total',
            '₹${total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
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
            fontSize: isBold ? 15 : 12.5,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF172033) : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16.5 : 12.5,
            fontWeight: isBold || isDiscount ? FontWeight.bold : FontWeight.w600,
            color: isDiscount
                ? const Color(0xFF2E7D32)
                : isHighlight
                    ? const Color(0xFF2E7D32)
                    : isBold
                        ? const Color(0xFFB32424)
                        : const Color(0xFF172033),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${total.toStringAsFixed(2)}',
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
                AppRoutes.deliveryAddress,
                arguments: {
                  'subtotal': subtotal,
                  'discountAmount': discountAmount,
                  'deliveryFee': deliveryFee,
                  'total': total,
                  'items': CartService.instance.items,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB32424),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'SELECT ADDRESS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
