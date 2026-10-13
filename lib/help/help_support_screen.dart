import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Color primaryColor = const Color(0xFFB32424);
  final Color backgroundColor = const Color(0xFFF8F8F8);

  final List<Map<String, dynamic>> _supportCategories = const [
    {
      'title': 'Orders & Delivery',
      'icon': Icons.local_shipping_outlined,
      'color': Color(0xFFFFF0F0),
    },
    {
      'title': 'Payments & Refund',
      'icon': Icons.payment_outlined,
      'color': Color(0xFFEBF3FF),
    },
    {
      'title': 'Returns & Exchange',
      'icon': Icons.assignment_return_outlined,
      'color': Color(0xFFEAF8EA),
    },
    {
      'title': 'Account & Profile',
      'icon': Icons.person_outline,
      'color': Color(0xFFFFF5E6),
    },
  ];

  final List<Map<String, String>> _faqList = const [
    {
      'question': 'How do I track my Super Value order?',
      'answer':
          'You can track your live order by going to "My Profile" > "My Orders" and selecting your active order to see real-time updates.',
      'category': 'Orders & Delivery',
    },
    {
      'question': 'What payment options are available?',
      'answer':
          'We accept UPI (GPay, PhonePe, Paytm), Credit & Debit cards (Visa, MasterCard, RuPay), Net Banking, Wallets, and Cash on Delivery (COD).',
      'category': 'Payments & Refund',
    },
    {
      'question': 'How long does a refund take to process?',
      'answer':
          'Refunds for canceled or returned orders are processed immediately to your original payment method and take 2-5 business days to reflect.',
      'category': 'Payments & Refund',
    },
    {
      'question': 'What if my order items are damaged or missing?',
      'answer':
          'If an item is damaged or missing, please contact customer support within 24 hours of delivery. We will issue an instant replacement or refund.',
      'category': 'Returns & Exchange',
    },
    {
      'question': 'How can I change my delivery address?',
      'answer':
          'You can update your address before placing an order on the checkout screen or under "Delivery Addresses" in your profile.',
      'category': 'Orders & Delivery',
    },
    {
      'question': 'How do I apply a promo code?',
      'answer':
          'Enter your valid coupon code (e.g., "SUPER20") in the "Promo Code" box inside your Shopping Cart before proceeding to checkout.',
      'category': 'Account & Profile',
    },
  ];

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
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredFaqs {
    if (_searchQuery.trim().isEmpty) {
      return _faqList;
    }
    return _faqList.where((faq) {
      final q = faq['question']!.toLowerCase();
      final a = faq['answer']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return q.contains(query) || a.contains(query);
    }).toList();
  }

  void _showLiveChatBottomSheet() {
    final chatInputController = TextEditingController();
    final List<Map<String, dynamic>> messages = [
      {
        'text': 'Hello Ujjwal! 👋 Welcome to Super Value Live Support.',
        'isAgent': true,
        'time': 'Just now',
      },
      {
        'text': 'I am Riya from the support team. How can I help you today?',
        'isAgent': true,
        'time': 'Just now',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setChatState) {
            void sendMessage(String text) {
              if (text.trim().isEmpty) return;

              setChatState(() {
                messages.add({
                  'text': text,
                  'isAgent': false,
                  'time': 'Just now',
                });
              });

              chatInputController.clear();

              // Auto agent response after delay
              Future.delayed(const Duration(milliseconds: 900), () {
                if (!context.mounted) return;
                setChatState(() {
                  String reply =
                      'Thanks for reaching out! Our team is checking your account details for "$text". An agent will respond in under 1 minute.';
                  if (text.toLowerCase().contains('order')) {
                    reply =
                        'Your active order #SV1002 is currently packed and on the way! Estimated delivery time: 15-20 mins.';
                  } else if (text.toLowerCase().contains('refund')) {
                    reply =
                        'Refunds are processed instantly to your original payment method within 24 hours of cancellation.';
                  }

                  messages.add({
                    'text': reply,
                    'isAgent': true,
                    'time': 'Just now',
                  });
                });
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.82,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Chat Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB32424),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.support_agent,
                                  color: Color(0xFFB32424), size: 28),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Super Value Support Team',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Riya • Online (Replies in < 1 min)',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Quick Action Chips
                  Container(
                    color: const Color(0xFFFFF0F0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _quickChip('📦 Track Order', () {
                            sendMessage('Track my active order');
                          }),
                          const SizedBox(width: 8),
                          _quickChip('💳 Refund Status', () {
                            sendMessage('Check my refund status');
                          }),
                          const SizedBox(width: 8),
                          _quickChip('🍎 Damaged Item', () {
                            sendMessage('I received a damaged item');
                          }),
                          const SizedBox(width: 8),
                          _quickChip('👤 Talk to Human Agent', () {
                            sendMessage('Connect me with a human support agent');
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Chat Messages List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isAgent = msg['isAgent'] as bool;

                        return Align(
                          alignment: isAgent
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isAgent
                                  ? const Color(0xFFF0F1F5)
                                  : const Color(0xFFB32424),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isAgent ? 4 : 16),
                                bottomRight: Radius.circular(isAgent ? 16 : 4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['text'] as String,
                                  style: TextStyle(
                                    color:
                                        isAgent ? Colors.black87 : Colors.white,
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg['time'] as String,
                                  style: TextStyle(
                                    color: isAgent
                                        ? Colors.grey
                                        : Colors.white70,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Chat Input Bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatInputController,
                            decoration: InputDecoration(
                              hintText: 'Type your issue or query...',
                              hintStyle: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              filled: true,
                              fillColor: const Color(0xFFF6F7F9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (val) => sendMessage(val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => sendMessage(chatInputController.text),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB32424),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
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

  Widget _quickChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xFFB32424)),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFB32424), width: 0.8),
      onPressed: onTap,
    );
  }

  void _showRaiseTicketBottomSheet() {
    final nameController = TextEditingController(text: 'Ujjwal Kumar');
    final emailController = TextEditingController(text: 'ujjwal@example.com');
    final messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedCategory = 'Orders & Delivery';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Submit Support Ticket',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Issue Category',
                          prefixIcon: const Icon(Icons.category_outlined,
                              color: Color(0xFFB32424)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Orders & Delivery',
                            child: Text('Orders & Delivery'),
                          ),
                          DropdownMenuItem(
                            value: 'Payments & Refund',
                            child: Text('Payments & Refund'),
                          ),
                          DropdownMenuItem(
                            value: 'Returns & Exchange',
                            child: Text('Returns & Exchange'),
                          ),
                          DropdownMenuItem(
                            value: 'Account & Profile',
                            child: Text('Account & Profile'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedCategory = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline,
                              color: Color(0xFFB32424)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFFB32424)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v == null || !v.contains('@')
                            ? 'Enter valid email'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Describe your issue...',
                          alignLabelWithHint: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Icon(Icons.edit_note,
                                color: Color(0xFFB32424)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v == null || v.trim().length < 10
                            ? 'Please describe issue (min 10 chars)'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              _showTicketCreatedDialog();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB32424),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'SUBMIT TICKET',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  void _showTicketCreatedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F7E8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 45,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Ticket Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ticket ID: #SV-98124\nOur 24x7 support team will review your query and respond via email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB32424),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OKAY'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Support Banner Card
                      _buildHeroBanner(),

                      const SizedBox(height: 20),

                      // Search Input
                      _buildSearchBar(),

                      const SizedBox(height: 20),

                      // Contact Options Grid
                      _buildContactOptionsRow(),

                      const SizedBox(height: 24),

                      // Quick Categories
                      _buildSectionTitle('Browse Help Categories'),
                      const SizedBox(height: 10),
                      _buildCategoryGrid(),

                      const SizedBox(height: 24),

                      // FAQ Section
                      _buildSectionTitle('Frequently Asked Questions'),
                      const SizedBox(height: 10),
                      _buildFaqList(),

                      const SizedBox(height: 24),

                      // Submit Ticket Card
                      _buildRaiseTicketCard(),

                      const SizedBox(height: 20),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(44, 44),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help & Support',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20213A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '24x7 Customer Service',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showLiveChatBottomSheet,
            child: Container(
              padding: const EdgeInsets.all(10),
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
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFFB32424),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD32F2F),
            Color(0xFFB32424),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBB616),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '24x7 LIVE HELP',
                    style: TextStyle(
                      color: Color(0xFFB32424),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'How can we help\nyou today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showLiveChatBottomSheet,
                  icon: const Icon(Icons.forum, size: 16),
                  label: const Text(
                    'START CHAT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB32424),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _showLiveChatBottomSheet,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search help topics, FAQs, orders...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search_rounded,
              color: Color(0xFFB32424), size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildContactOptionsRow() {
    return Row(
      children: [
        Expanded(
          child: _contactCard(
            title: 'Live Chat',
            subtitle: 'Instant Response',
            icon: Icons.chat_bubble_outline_rounded,
            color: const Color(0xFFE8F7E8),
            iconColor: Colors.green,
            onTap: _showLiveChatBottomSheet,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _contactCard(
            title: 'Call Support',
            subtitle: '1800-123-4567',
            icon: Icons.phone_in_talk_outlined,
            color: const Color(0xFFEBF3FF),
            iconColor: const Color(0xFF1976D2),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling Support Helpline: 1800-123-4567'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _contactCard(
            title: 'Email Us',
            subtitle: 'Submit Ticket',
            icon: Icons.mark_email_read_outlined,
            color: const Color(0xFFFFF0F0),
            iconColor: primaryColor,
            onTap: _showRaiseTicketBottomSheet,
          ),
        ),
      ],
    );
  }

  Widget _contactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _supportCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final cat = _supportCategories[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cat['color'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cat['title'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFaqList() {
    final faqs = filteredFaqs;

    if (faqs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'No matching FAQs found. Try searching another term or submit a support ticket.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return Container(
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
      child: Column(
        children: faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          final isLast = index == faqs.length - 1;

          return Column(
            children: [
              ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                childrenPadding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 14),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq['answer']!,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRaiseTicketCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFBB616).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.headset_mic_outlined,
            color: Color(0xFFB32424),
            size: 32,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still need help?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chat live with our support agent or submit a ticket.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _showLiveChatBottomSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB32424),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Text(
              'CHAT NOW',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
