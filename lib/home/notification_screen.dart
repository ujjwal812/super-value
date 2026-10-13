import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Order Confirmed',
      'message': 'Your Super Value Market order #SV1002 has been confirmed successfully.',
      'time': '2 min ago',
      'icon': Icons.check_circle_outline,
      'color': Colors.green,
      'isRead': false,
    },
    {
      'title': 'Super Value Offer!',
      'message': 'Get up to 25% off on Fresh Fruits & Vegetables today.',
      'time': '1 hour ago',
      'icon': Icons.local_offer_outlined,
      'color': const Color(0xFFFBB616),
      'isRead': false,
    },
    {
      'title': 'Payment Successful',
      'message': 'Your payment of ₹460 was completed successfully.',
      'time': '3 hours ago',
      'icon': Icons.payment_outlined,
      'color': const Color(0xFFB32424),
      'isRead': true,
    },
    {
      'title': 'Delivery Update',
      'message': 'Your grocery delivery is arriving today in 20-30 mins.',
      'time': 'Yesterday',
      'icon': Icons.notifications_active_outlined,
      'color': Colors.purple,
      'isRead': true,
    },
    {
      'title': 'Welcome to Super Value Market',
      'message': 'Thank you for joining us. Enjoy fresh grocery shopping!',
      'time': '2 days ago',
      'icon': Icons.celebration_outlined,
      'color': Colors.pink,
      'isRead': true,
    },
  ];

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: const Text(
              'Read all',
              style: TextStyle(
                color: Color(0xFFB32424),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(
                  notifications[index],
                  index,
                );
              },
            ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notification,
    int index,
  ) {
    final bool isRead = notification['isRead'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead
              ? const Color(0xFFE5E7EB)
              : const Color(0xFFFBB616).withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            notification['isRead'] = true;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: (notification['color'] as Color)
                      .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  color: notification['color'] as Color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 13),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            height: 8,
                            width: 8,
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFB32424),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      notification['message'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF6B7280),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      notification['time'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 45,
                color: Color(0xFFB32424),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'You are all caught up!\nNew notifications will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
