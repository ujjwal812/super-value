import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';

class PaymentConfirmScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final String paymentMethod;
  final String deliveryAddress;

  const PaymentConfirmScreen({
    super.key,
    this.subtotal = 499.00,
    this.deliveryFee = 40.00,
    this.paymentMethod = 'UPI',
    this.deliveryAddress = 'Lalpur, Ranchi, Jharkhand',
  });

  @override
  State<PaymentConfirmScreen> createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  static const Color primaryColor = Color(0xFFB32424);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryColor = Color(0xFF7B8494);
  static const Color borderColor = Color(0xFFE7EAF0);

  bool _isProcessing = false;
  late String _selectedPayment;

  @override
  void initState() {
    super.initState();
    _selectedPayment = widget.paymentMethod;
  }

  String _currency(double amount) => '₹${amount.toStringAsFixed(2)}';

  void _confirmPayment(double grandTotal) {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      // Clear cart upon successful order placement
      CartService.instance.clearCart();

      _showSuccessDialog(grandTotal);
    });
  }

  void _showSuccessDialog(double grandTotal) {
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
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2E7D32),
                size: 52,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Placed!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order of ${_currency(grandTotal)} has been successfully confirmed.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 24),
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
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BACK TO HOME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)?.settings.arguments;

    double activeSubtotal = widget.subtotal;
    double activeDeliveryFee = widget.deliveryFee;
    double activeTotal = activeSubtotal + activeDeliveryFee;
    String activeAddress = widget.deliveryAddress;
    String activePayment = _selectedPayment;

    if (rawArgs is Map<String, dynamic>) {
      activeSubtotal = (rawArgs['subtotal'] as num?)?.toDouble() ?? activeSubtotal;
      activeDeliveryFee = (rawArgs['deliveryFee'] as num?)?.toDouble() ?? activeDeliveryFee;
      activeTotal = (rawArgs['totalAmount'] as num?)?.toDouble() ??
          (rawArgs['total'] as num?)?.toDouble() ??
          (activeSubtotal + activeDeliveryFee);
      activeAddress = rawArgs['deliveryAddress'] as String? ?? activeAddress;
      activePayment = rawArgs['paymentMethod'] as String? ?? activePayment;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textColor,
          ),
        ),
        title: const Text(
          'Confirm Payment',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecureBanner(),
              const SizedBox(height: 24),
              _buildOrderCard(subtotal: activeSubtotal, deliveryFee: activeDeliveryFee),
              const SizedBox(height: 20),
              _buildAddressCard(address: activeAddress),
              const SizedBox(height: 24),
              _buildPriceSummary(
                subtotal: activeSubtotal,
                deliveryFee: activeDeliveryFee,
                total: activeTotal,
                paymentMethod: activePayment,
              ),
              const SizedBox(height: 24),
              _buildConfirmButton(grandTotal: activeTotal),
              const SizedBox(height: 14),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                      color: secondaryColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Your payment details are protected',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecureBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: primaryColor,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Almost there!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Review your order before placing it.',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({required double subtotal, required double deliveryFee}) {
    return _sectionCard(
      title: 'Order Summary',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 29,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Super Market Cart Items',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Your selected grocery items',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _currency(subtotal),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: borderColor),
          const SizedBox(height: 12),
          _infoRow('Items subtotal', _currency(subtotal)),
          const SizedBox(height: 12),
          _infoRow(
            'Delivery fee',
            deliveryFee == 0 ? 'FREE' : _currency(deliveryFee),
            valueColor: deliveryFee == 0 ? const Color(0xFF2E7D32) : textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({required String address}) {
    return _sectionCard(
      title: 'Delivery Address',
      icon: Icons.location_on_outlined,
      trailing: const Icon(
        Icons.check_circle,
        color: Color(0xFF2E7D32),
        size: 21,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary({
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
  }) {
    return _sectionCard(
      title: 'Payment Details',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          _infoRow('Payment Method', paymentMethod.toUpperCase(), valueColor: primaryColor),
          const SizedBox(height: 12),
          _infoRow('Subtotal', _currency(subtotal)),
          const SizedBox(height: 12),
          _infoRow(
            'Delivery Fee',
            deliveryFee == 0 ? 'FREE' : _currency(deliveryFee),
            valueColor: deliveryFee == 0 ? const Color(0xFF2E7D32) : textColor,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: borderColor),
          ),
          _infoRow(
            'Total Amount',
            _currency(total),
            bold: true,
            valueColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton({required double grandTotal}) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : () => _confirmPayment(grandTotal),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded),
                  const SizedBox(width: 10),
                  Text(
                    'Confirm ${_currency(grandTotal)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (trailing != null) ...[trailing],
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    bool bold = false,
    Color valueColor = textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: bold ? textColor : secondaryColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 17 : 13,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
