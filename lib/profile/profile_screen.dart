import 'package:flutter/material.dart';
import 'package:learning_project/features/logIn_screen.dart';
import 'package:learning_project/home/notification_screen.dart';
import 'package:learning_project/profile/edit_screen.dart';
import 'package:learning_project/profile/wishlish_screen.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/translation_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    TranslationService.instance.currentLanguageNotifier.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService.instance.currentLanguageNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  String tr(String text) {
    return TranslationService.instance.tr(text);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('Logout')),
        content: Text(tr('Are you sure you want to log out?')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              tr('Cancel'),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB32424),
              foregroundColor: Colors.white,
            ),
            child: Text(tr('Logout')),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelectionSheet() {
    final currentLang = TranslationService.instance.currentLanguage;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.g_translate_rounded,
                          color: Color(0xFFB32424),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('Select App Language'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172033),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Powered by Google ML Kit On-Device Translation',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // English Option
                  _buildLanguageOption(
                    title: 'English',
                    subtitle: 'Default language',
                    isSelected: currentLang == AppLanguage.english,
                    onTap: () async {
                      Navigator.pop(context);
                      await TranslationService.instance
                          .changeLanguage(AppLanguage.english);
                      if (mounted) setState(() {});
                    },
                  ),

                  const SizedBox(height: 12),

                  // Hindi Option
                  _buildLanguageOption(
                    title: 'हिंदी (Hindi)',
                    subtitle: 'गूगल एमएल किट ऑन-डिवाइस अनुवाद',
                    isSelected: currentLang == AppLanguage.hindi,
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      Navigator.pop(context);

                      if (TranslationService.instance.isDownloadingModel) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Downloading ML Kit Hindi Translation Model...'),
                            backgroundColor: Color(0xFFB32424),
                          ),
                        );
                      }

                      await TranslationService.instance
                          .changeLanguage(AppLanguage.hindi);
                      if (mounted) setState(() {});

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('भाषा बदलकर हिंदी कर दी गई (Hindi)'),
                          backgroundColor: Color(0xFF2E7D32),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0F0) : const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFB32424) : const Color(0xFFEFEFEF),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
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
                      color: isSelected
                          ? const Color(0xFFB32424)
                          : const Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? const Color(0xFFB32424) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = TranslationService.instance.isHindi;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          tr('My Profile'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: const Color(0xFFB32424),
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              // User Profile Header Card
              _buildProfileHeader(context),

              const SizedBox(height: 20),

              // Orders & Account Section
              _buildSectionHeader(tr('Account & Orders')),
              const SizedBox(height: 8),

              _buildMenuCard([
                _ProfileMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: tr('My Orders'),
                  subtitle: tr('Already 12 orders placed'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.orders);
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.location_on_outlined,
                  title: tr('Delivery Addresses'),
                  subtitle: tr('Ranchi, Jharkhand - 834001'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.deliveryAddress);
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: tr('My Wallet'),
                  subtitle: tr('Balance: ₹1,250.00 • Add Money'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.addMoney);
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.payment_outlined,
                  title: tr('Payment Methods'),
                  subtitle: tr('UPI, Credit/Debit Cards'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.paymentMethod);
                  },
                ),
              ]),

              const SizedBox(height: 20),

              // Settings & Preferences
              _buildSectionHeader(tr('Settings & Preferences')),
              const SizedBox(height: 8),

              _buildMenuCard([
                _ProfileMenuItem(
                  icon: Icons.g_translate_rounded,
                  title: tr('App Language'),
                  subtitle: isHindi
                      ? 'हिंदी (Hindi) • Google ML Kit'
                      : 'English / हिंदी (Google ML Kit)',
                  onTap: _showLanguageSelectionSheet,
                ),
                _ProfileMenuItem(
                  icon: Icons.favorite_border,
                  title: tr('Wishlist'),
                  subtitle: tr('Your saved items'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishlistScreen(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.notifications_none_outlined,
                  title: tr('Notifications'),
                  subtitle: tr('Offers, Order updates'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: tr('Help & Support'),
                  subtitle: tr('24x7 Customer support'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.helpSupport);
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: tr('About Super Value'),
                  subtitle: tr('Terms, Privacy Policy'),
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFB32424),
                  ),
                  label: Text(
                    tr('LOGOUT'),
                    style: const TextStyle(
                      color: Color(0xFFB32424),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFB32424),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                tr('Super Value Market v1.0.0'),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProfileScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Avatar
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFBB616),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFFFF7E0),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFFB32424),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB32424),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('Ujjwal Kumar'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+91 98765 43210',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'ujjwal@example.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<_ProfileMenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.last == item;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: const Color(0xFFB32424),
                    size: 22,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 16,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
