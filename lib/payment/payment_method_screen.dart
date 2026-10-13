import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';

class PaymentMethodScreen extends StatefulWidget {
  final dynamic checkoutData;

  const PaymentMethodScreen({
    super.key,
    this.checkoutData,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with SingleTickerProviderStateMixin {
  String selectedMethod = 'UPI';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color primaryColor = const Color(0xFFB32424);
  final Color backgroundColor = const Color(0xFFF6F7FB);

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

  void _selectMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
  }

  void _payNow({
    required double subtotal,
    required double discountAmount,
    required double deliveryFee,
    required double totalAmount,
    required String deliveryAddress,
    required String recipientName,
    required String recipientPhone,
    dynamic items,
  }) {
    Navigator.pushNamed(
      context,
      AppRoutes.paymentConfirm,
      arguments: {
        'subtotal': subtotal,
        'discountAmount': discountAmount,
        'deliveryFee': deliveryFee,
        'totalAmount': totalAmount,
        'paymentMethod': selectedMethod,
        'deliveryAddress': deliveryAddress,
        'recipientName': recipientName,
        'recipientPhone': recipientPhone,
        'items': items,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs =
        widget.checkoutData ?? ModalRoute.of(context)?.settings.arguments;

    double subtotal = 499.0;
    double discountAmount = 0.0;
    double deliveryFee = 30.0;
    double totalAmount = 529.0;
    String deliveryAddress = 'House No. 12, Main Road, Lalpur, Ranchi, Jharkhand - 834001';
    String recipientName = 'Ujjwal Kumar';
    String recipientPhone = '+91 98765 43210';
    dynamic items;

    if (rawArgs is Map<String, dynamic>) {
      subtotal = (rawArgs['subtotal'] as num?)?.toDouble() ?? subtotal;
      discountAmount =
          (rawArgs['discountAmount'] as num?)?.toDouble() ?? discountAmount;
      deliveryFee =
          (rawArgs['deliveryFee'] as num?)?.toDouble() ?? deliveryFee;
      totalAmount = (rawArgs['totalAmount'] as num?)?.toDouble() ??
          (rawArgs['total'] as num?)?.toDouble() ??
          (subtotal - discountAmount + deliveryFee);
      deliveryAddress =
          rawArgs['deliveryAddress'] as String? ?? deliveryAddress;
      recipientName = rawArgs['recipientName'] as String? ?? recipientName;
      recipientPhone = rawArgs['recipientPhone'] as String? ?? recipientPhone;
      items = rawArgs['items'];
    } else if (rawArgs is double) {
      totalAmount = rawArgs;
      subtotal = totalAmount > 30 ? totalAmount - 30 : totalAmount;
      deliveryFee = totalAmount > 200 ? 0.0 : 30.0;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Total Amount Header Card
                      _buildAmountCard(totalAmount: totalAmount),

                      const SizedBox(height: 16),

                      // Selected Address Summary Card
                      _buildAddressPreviewCard(
                        recipientName: recipientName,
                        recipientPhone: recipientPhone,
                        deliveryAddress: deliveryAddress,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Choose Payment Method',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF20213A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Select your preferred payment option to confirm order',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 18),

                      _buildSectionTitle('POPULAR METHODS'),
                      const SizedBox(height: 12),

                      _buildPaymentOption(
                        title: 'UPI',
                        subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
                        icon: Icons.account_balance_wallet_rounded,
                        color: const Color(0xFF5B5FEF),
                      ),
                      _buildPaymentOption(
                        title: 'Credit / Debit Card',
                        subtitle: 'Visa, Mastercard, RuPay',
                        icon: Icons.credit_card_rounded,
                        color: const Color(0xFF00897B),
                      ),
                      _buildPaymentOption(
                        title: 'Net Banking',
                        subtitle: 'All major Indian banks supported',
                        icon: Icons.account_balance_rounded,
                        color: const Color(0xFFEF6C00),
                      ),
                      _buildPaymentOption(
                        title: 'Wallet',
                        subtitle: 'Pay using Super Value balance',
                        icon: Icons.wallet_rounded,
                        color: const Color(0xFF8E44AD),
                      ),
                      _buildPaymentOption(
                        title: 'Cash on Delivery',
                        subtitle: 'Pay cash or UPI at delivery',
                        icon: Icons.payments_rounded,
                        color: const Color(0xFF2E7D32),
                      ),

                      const SizedBox(height: 20),
                      _buildSecurityInfo(),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(
                subtotal: subtotal,
                discountAmount: discountAmount,
                deliveryFee: deliveryFee,
                totalAmount: totalAmount,
                deliveryAddress: deliveryAddress,
                recipientName: recipientName,
                recipientPhone: recipientPhone,
                items: items,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 20, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(46, 46),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20213A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Step 3 of 3: Final Payment',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF2E7D32),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard({required double totalAmount}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            color: primaryColor.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Grand Total Payable',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: 13,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '100% Secure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressPreviewCard({
    required String recipientName,
    required String recipientPhone,
    required String deliveryAddress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EAF2)),
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
                    Icons.location_on_rounded,
                    color: Color(0xFFB32424),
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Delivering To:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF20213A),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'CHANGE',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB32424),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$recipientName • $recipientPhone',
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF20213A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            deliveryAddress,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final bool isSelected = selectedMethod == title;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? primaryColor
              : const Color(0xFFE9EAF2),
          width: isSelected ? 1.6 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _selectMethod(title),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF25263D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: Color(0xFF24834A),
            size: 22,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% Encrypted & Safe Payment',
                  style: TextStyle(
                    color: Color(0xFF216C40),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'All transactions are processed through end-to-end encrypted gateways. Never share OTP or PIN.',
                  style: TextStyle(
                    color: Color(0xFF47785A),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar({
    required double subtotal,
    required double discountAmount,
    required double deliveryFee,
    required double totalAmount,
    required String deliveryAddress,
    required String recipientName,
    required String recipientPhone,
    dynamic items,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PAYABLE',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
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
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _payNow(
                    subtotal: subtotal,
                    discountAmount: discountAmount,
                    deliveryFee: deliveryFee,
                    totalAmount: totalAmount,
                    deliveryAddress: deliveryAddress,
                    recipientName: recipientName,
                    recipientPhone: recipientPhone,
                    items: items,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                    ],
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
