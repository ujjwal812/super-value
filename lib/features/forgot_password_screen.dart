import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void sendOtp() {
    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit phone number'),
        ),
      );
      return;
    }

    // TODO: Add Send OTP API call here

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent successfully'),
      ),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.otp,
      arguments: phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 25),

                // Icon
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF7E0),
                    border: Border.all(
                      color: const Color(0xFFFBB616),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 45,
                    color: Color(0xFFB32424),
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB32424),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Enter your registered phone number to receive a 6-digit verification code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // Phone Number Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Enter phone number',
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: Color(0xFFB32424),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFFBB616),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Send OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB32424),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SEND OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Remember your password? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFFB32424),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Bottom branding
                const Text(
                  'Super Value Market',
                  style: TextStyle(
                    color: Color(0xFFFBB616),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
