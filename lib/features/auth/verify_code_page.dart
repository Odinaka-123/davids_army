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
  final codeController = TextEditingController();

  bool verifying = false;
  bool sendingCode = false;

  @override
  Widget build(BuildContext context) {
    final email = auth.currentUser?.email ?? "<your email>";

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/auth');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Verify Your Email"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/auth'),
          ),
        ),
        body: Center(
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter the 6-digit verification code sent to",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Enter code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

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

                  ElevatedButton(
                    onPressed: verifying ? null : _verifyCode,
                    child: verifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Verify"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ VERIFY WITH BACKEND
  void _verifyCode() async {
    final email = auth.currentUser?.email;
    if (email == null) return;

    setState(() => verifying = true);

    final success = await BackendService.verifyCode(
      email,
      codeController.text.trim(),
    );

    setState(() => verifying = false);

    if (!mounted) return;

    if (success) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid or expired code")));
    }
  }

  /// ✅ RESEND FROM BACKEND
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
