import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({
    super.key,
    this.totalAmount = 460.0,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  String selectedMethod = 'UPI';
  bool isProcessing = false;

  late AnimationController _animationController;

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

  void processPayment(double totalAmount) {
    setState(() {
      isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
      });

      // Clear Cart after successful order
      CartService.instance.clearCart();

      _showSuccessDialog(totalAmount);
    });
  }

  void _showSuccessDialog(double totalAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F7E8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 55,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order of ₹${totalAmount.toStringAsFixed(2)} has been placed successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB32424),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BACK TO HOME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedItem(int index, Widget child) {
    final Animation<double> animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (index * 0.12).clamp(0.0, 0.7),
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
    final dynamic rawArgs = ModalRoute.of(context)?.settings.arguments;

    double activeTotal = widget.totalAmount;
    String activeAddress = 'House No. 12, Main Road, Lalpur, Ranchi - 834001';
    String recipientName = 'Ujjwal Kumar';

    if (rawArgs is Map<String, dynamic>) {
      activeTotal = (rawArgs['totalAmount'] as num?)?.toDouble() ??
          (rawArgs['total'] as num?)?.toDouble() ??
          activeTotal;
      activeAddress = rawArgs['deliveryAddress'] as String? ?? activeAddress;
      recipientName = rawArgs['recipientName'] as String? ?? recipientName;
    } else if (rawArgs is double) {
      activeTotal = rawArgs;
    }

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
          'Checkout & Payment',
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
              // Order Summary Card
              _animatedItem(
                0,
                _buildOrderSummaryCard(
                  totalAmount: activeTotal,
                  address: activeAddress,
                  name: recipientName,
                ),
              ),

              const SizedBox(height: 20),

              // Payment Method Options Header
              _animatedItem(
                1,
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // UPI Option
              _animatedItem(
                2,
                _buildPaymentOptionCard(
                  title: 'UPI Payment',
                  subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
                  icon: Icons.account_balance_wallet_outlined,
                  value: 'UPI',
                ),
              ),

              const SizedBox(height: 12),

              // Card Option
              _animatedItem(
                3,
                _buildPaymentOptionCard(
                  title: 'Credit / Debit Card',
                  subtitle: 'Visa, MasterCard, RuPay',
                  icon: Icons.credit_card,
                  value: 'CARD',
                ),
              ),

              const SizedBox(height: 12),

              // Net Banking
              _animatedItem(
                4,
                _buildPaymentOptionCard(
                  title: 'Net Banking',
                  subtitle: 'SBI, HDFC, ICICI, Axis & All Banks',
                  icon: Icons.account_balance,
                  value: 'NET_BANKING',
                ),
              ),

              const SizedBox(height: 12),

              // Cash on Delivery
              _animatedItem(
                5,
                _buildPaymentOptionCard(
                  title: 'Cash on Delivery',
                  subtitle: 'Pay cash or UPI at delivery',
                  icon: Icons.payments_outlined,
                  value: 'COD',
                ),
              ),

              const SizedBox(height: 30),

              // Pay Button
              _animatedItem(
                6,
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : () => processPayment(activeTotal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB32424),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'PAY ₹${activeTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard({
    required double totalAmount,
    required String address,
    required String name,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFFB32424),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$name • $address',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable Amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB32424),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFB32424) : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFF0F0)
                    : const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFB32424),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
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
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB32424)
                      : Colors.grey.shade400,
                  width: isSelected ? 6.5 : 1.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
