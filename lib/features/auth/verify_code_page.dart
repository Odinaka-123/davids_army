import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import '../../core/services/backend_service.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final auth = AuthService();

  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  bool verifying = false;
  bool sendingCode = false;

  String get code => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final email = auth.currentUser?.email ?? "";

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/auth');
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_user, size: 80),
                  const SizedBox(height: 24),

                  const Text(
                    "Verify Your Email",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Enter the 6-digit code sent to",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),

                  // 🔥 OTP INPUT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }

                            // 🔥 AUTO SUBMIT
                            if (code.length == 6) {
                              _verifyCode();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: sendingCode ? null : _resendCode,
                        child: sendingCode
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Resend Code"),
                      ),
                      TextButton(
                        onPressed: () => context.go('/auth'),
                        child: const Text("Change Email"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: verifying ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: verifying
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Verify"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// VERIFY CODE
  void _verifyCode() async {
    final email = auth.currentUser?.email;
    if (email == null) return;

    if (code.length < 6) return;

    setState(() => verifying = true);

    final success = await BackendService.verifyCode(email, code);

    if (!mounted) return;

    if (!success) {
      setState(() => verifying = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid or expired code")));
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final verified = await BackendService.isEmailVerified(email);

    setState(() => verifying = false);

    if (!mounted) return;

    if (verified) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification successful, syncing... try again"),
        ),
      );
    }
  }

  /// RESEND
  void _resendCode() async {
    final email = auth.currentUser?.email;
    if (email == null) return;

    setState(() => sendingCode = true);

    await BackendService.sendVerificationEmail(email);

    setState(() => sendingCode = false);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Verification code resent")));
  }
}
