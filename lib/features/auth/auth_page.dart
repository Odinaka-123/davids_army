import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../features/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final auth = AuthService();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLogin = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Logo top right ────────────────────────────────────
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/icons/shield_icon.png',
                  height: 48,
                  width: 48,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                isLogin ? "Hi There! 👋" : "Register",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                isLogin
                    ? "Welcome back, Sign in to your account"
                    : "Create a new account",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              if (!isLogin) ...[
                TextField(
                  controller: firstNameController,
                  decoration: _input("First Name"),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: lastNameController,
                  decoration: _input("Last Name"),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: phoneController,
                  decoration: _input("Phone Number"),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: emailController,
                decoration: _input("Email", icon: Icons.email_outlined),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: _input(
                  "Password",
                  suffix: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (!isLogin)
                TextField(
                  controller: confirmPasswordController,
                  obscureText: hideConfirmPassword,
                  decoration: _input(
                    "Confirm Password",
                    suffix: IconButton(
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => hideConfirmPassword = !hideConfirmPassword,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : _handleEmailAuth,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isLogin ? "Sign In" : "Sign Up"),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: const FaIcon(FontAwesomeIcons.google),
                      label: const Text("Google"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Login",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String hint, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _handleEmailAuth() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    setState(() => loading = true);

    try {
      if (isLogin) {
        final user = await auth.signInEmail(email, pass);

        if (!mounted) return;
        setState(() => loading = false);

        if (user != null) context.go('/');
      } else {
        final confirm = confirmPasswordController.text.trim();

        if (pass != confirm) {
          setState(() => loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")),
          );
          return;
        }

        final user = await auth.signUpEmail(
          email: email,
          password: pass,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
        );

        if (!mounted) return;
        setState(() => loading = false);

        if (user != null) {
          context.go('/verify-code');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _handleGoogleSignIn() async {
    try {
      final user = await auth.signInWithGoogle();

      if (!mounted) return;

      if (user != null) context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }
}
