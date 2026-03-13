import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';

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

    return WillPopScope(
      onWillPop: () async {
        // Allow going back to AuthPage
        context.go('/auth');
        return false;
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
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    style: const TextStyle(fontSize: 20),
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
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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

  void _verifyCode() async {
    if (auth.currentUser == null) return;

    setState(() => verifying = true);

    final success = await auth.verifyCode(
      auth.currentUser!.uid,
      codeController.text.trim(),
    );

    setState(() => verifying = false);

    if (success) {
      if (!mounted) return;
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid verification code")),
      );
    }
  }

  void _resendCode() async {
    if (auth.currentUser == null) return;

    setState(() => sendingCode = true);

    await auth.sendVerificationCode(
      auth.currentUser!.uid,
      auth.currentUser!.email ?? "",
    );

    setState(() => sendingCode = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Verification code resent")));
  }
}
