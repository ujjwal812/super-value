import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();

  final double _walletBalance = 1250.00;
  double _selectedAmount = 0;
  String _selectedPayment = 'UPI';

  final Color primaryColor = const Color(0xFFB32424);
  final Color backgroundColor = const Color(0xFFF7F9FC);

  final List<double> quickAmounts = [100, 500, 1000, 2000];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'UPI',
      'subtitle': 'Google Pay, PhonePe, Paytm',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Debit / Credit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card_outlined,
    },
    {
      'title': 'Net Banking',
      'subtitle': 'Pay using your bank account',
      'icon': Icons.account_balance_outlined,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _onAmountChanged(String value) {
    final amount = double.tryParse(value);

    setState(() {
      _selectedAmount = amount ?? 0;
    });
  }

  void _addMoney() {
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (amount < 10 || amount > 50000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter an amount between ₹10 and ₹50,000'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Amount: ₹${amount.toStringAsFixed(2)} | '
          'Payment: $_selectedPayment. '
          'Wallet money added successfully.',
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF172033),
          ),
        ),
        title: const Text(
          'Add Money',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                      color: primaryColor.withValues(alpha: 0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Super Market Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${_walletBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Secure wallet',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Amount Input
              const Text(
                'Enter Amount',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE7EAF0)),
                ),
                child: Row(
                  children: [
                    Text(
                      '₹',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        onChanged: _onAmountChanged,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _amountController.clear();
                        _onAmountChanged('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Minimum ₹10 • Maximum ₹50,000',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B8494),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Quick Select',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: quickAmounts.map((amount) {
                  final isSelected = _selectedAmount == amount;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectAmount(amount),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : const Color(0xFFE7EAF0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        '₹${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? primaryColor
                              : const Color(0xFF172033),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              const Text(
                'Choose Payment Method',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 16),

              ...paymentMethods.map((method) {
                final isSelected = _selectedPayment == method['title'];

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : const Color(0xFFE7EAF0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        method['icon'] as IconData,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      method['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      method['subtitle'] as String,
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? primaryColor : Colors.grey.shade400,
                          width: isSelected ? 6.5 : 1.8,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPayment = method['title'] as String;
                      });
                    },
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Add Money Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _addMoney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline),
                      const SizedBox(width: 10),
                      Text(
                        'Add ₹${_selectedAmount.toStringAsFixed(0)}',
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
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Secure payments • Your money, your control',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8494),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
