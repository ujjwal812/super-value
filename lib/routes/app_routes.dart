import 'package:flutter/material.dart';
import 'package:learning_project/features/create_acount.dart';
import 'package:learning_project/features/forgot_password_screen.dart';
import 'package:learning_project/features/logIn_screen.dart';
import 'package:learning_project/features/otp_screen.dart';
import 'package:learning_project/help/help_support_screen.dart';
import 'package:learning_project/home/cart_screen.dart';
import 'package:learning_project/home/categories_screen.dart';
import 'package:learning_project/home/notification_screen.dart';
import 'package:learning_project/home/products_deatls_screen.dart';
import 'package:learning_project/home/home_screen.dart';
import 'package:learning_project/orders/checkOut_screen.dart';
import 'package:learning_project/orders/order_screen.dart';
import 'package:learning_project/payment/payment_confrom.dart';
import 'package:learning_project/payment/payment_method_screen.dart';
import 'package:learning_project/payment/payment_screen.dart';
import 'package:learning_project/profile/delivery_address_screen.dart';
import 'package:learning_project/profile/edit_screen.dart';
import 'package:learning_project/profile/profile_screen.dart';
import 'package:learning_project/profile/wishlish_screen.dart';
import 'package:learning_project/splash_screen/splash_screen.dart';
import 'package:learning_project/wallet/add_money_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String notification = '/notification';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String deliveryAddress = '/delivery-address';
  static const String wishlist = '/wishlist';
  static const String orders = '/orders';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String paymentMethod = '/payment-method';
  static const String paymentConfirm = '/payment-confirm';
  static const String helpSupport = '/help-support';
  static const String addMoney = '/add-money';
  static const String details = '/details';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        createAccount: (context) => const CreateAccountScreen(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        home: (context) => const HomeScreen(),
        categories: (context) => const CategoriesScreen(),
        notification: (context) => const NotificationScreen(),
        cart: (context) => const CartScreen(),
        profile: (context) => const ProfileScreen(),
        editProfile: (context) => const EditProfileScreen(),
        deliveryAddress: (context) => const DeliveryAddressScreen(),
        wishlist: (context) => const WishlistScreen(),
        orders: (context) => const OrdersScreen(),
        payment: (context) => const PaymentScreen(),
        paymentMethod: (context) => const PaymentMethodScreen(),
        paymentConfirm: (context) => const PaymentConfirmScreen(),
        helpSupport: (context) => const HelpSupportScreen(),
        addMoney: (context) => const AddMoneyScreen(),
        details: (context) => const DetailsScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case splash:
        page = const SplashScreen();
        break;
      case login:
        page = const LoginScreen();
        break;
      case createAccount:
        page = const CreateAccountScreen();
        break;
      case forgotPassword:
        page = const ForgotPasswordScreen();
        break;
      case otp:
        final phoneNumber = settings.arguments as String? ?? '';
        page = OtpScreen(phoneNumber: phoneNumber);
        break;
      case home:
        page = const HomeScreen();
        break;
      case categories:
        page = const CategoriesScreen();
        break;
      case notification:
        page = const NotificationScreen();
        break;
      case cart:
        page = const CartScreen();
        break;
      case profile:
        page = const ProfileScreen();
        break;
      case editProfile:
        page = const EditProfileScreen();
        break;
      case deliveryAddress:
        final checkoutArgs = settings.arguments as Map<String, dynamic>?;
        page = DeliveryAddressScreen(checkoutData: checkoutArgs);
        break;
      case wishlist:
        page = const WishlistScreen();
        break;
      case orders:
        page = const OrdersScreen();
        break;
      case checkout:
        final amount = settings.arguments as double? ?? 290.0;
        page = CheckoutScreen(totalAmount: amount);
        break;
      case payment:
        final amount = settings.arguments as double? ?? 460.0;
        page = PaymentScreen(totalAmount: amount);
        break;
      case paymentMethod:
        final checkoutArgs = settings.arguments;
        page = PaymentMethodScreen(checkoutData: checkoutArgs);
        break;
      case paymentConfirm:
        final args = settings.arguments as Map<String, dynamic>?;
        page = PaymentConfirmScreen(
          subtotal: (args?['subtotal'] as num?)?.toDouble() ?? 499.00,
          deliveryFee: (args?['deliveryFee'] as num?)?.toDouble() ?? 30.00,
          paymentMethod: args?['paymentMethod'] as String? ?? 'UPI',
          deliveryAddress: args?['deliveryAddress'] as String? ??
              'House No. 12, Main Road, Lalpur, Ranchi, Jharkhand - 834001',
        );
        break;
      case helpSupport:
        page = const HelpSupportScreen();
        break;
      case addMoney:
        page = const AddMoneyScreen();
        break;
      case details:
        final product = settings.arguments as Map<String, dynamic>?;
        page = DetailsScreen(productData: product);
        break;
      default:
        page = const SplashScreen();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.04);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 320),
    );
  }
}
