import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/notification_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(6, (_) => FocusNode());

  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      secondsRemaining = 30;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  void verifyOtp() {
    String otp = otpControllers.map((controller) {
      return controller.text;
    }).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter 6 digit OTP'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP Verified Successfully'),
      ),
    );

    // Show notification after login
    NotificationService.showNotification(
      title: 'Login Successful! 🎉',
      body: 'Welcome back to Super Value Market!',
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  void resendOtp() {
    if (secondsRemaining != 0) return;

    for (var controller in otpControllers) {
      controller.clear();
    }

    focusNodes[0].requestFocus();

    startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP Sent Again'),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var node in focusNodes) {
      node.dispose();
    }

    super.dispose();
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

                // OTP Icon
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
                    Icons.lock_outline,
                    size: 45,
                    color: Color(0xFFB32424),
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB32424),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Enter the 6-digit OTP sent to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                // Phone number
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) {
                      return SizedBox(
                        width: 48,
                        height: 58,
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB32424),
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF8F8F8),
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFFBB616),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              focusNodes[index + 1].requestFocus();
                            }

                            if (value.isEmpty && index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 35),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB32424),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'VERIFY OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive OTP? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: resendOtp,
                      child: Text(
                        secondsRemaining > 0
                            ? 'Resend in ${secondsRemaining}s'
                            : 'Resend OTP',
                        style: TextStyle(
                          color: secondsRemaining > 0
                              ? Colors.grey
                              : const Color(0xFFB32424),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Change Number
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Change Phone Number',
                    style: TextStyle(
                      color: Color(0xFFB32424),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

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
