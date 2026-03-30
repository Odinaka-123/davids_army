import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class GivePage extends StatefulWidget {
  const GivePage({super.key});

  @override
  State<GivePage> createState() => _GivePageState();
}

class _GivePageState extends State<GivePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          children: [
            _topBar(context),

            const SizedBox(height: 30),

            /// 💳 Animated Bank Card
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: _bankCard(context),
              ),
            ),

            const SizedBox(height: 30),

            /// ✨ Inspiration
            _inspirationCard(context),

            const SizedBox(height: 30),

            /// 🙏 Chips
            _categoryChips(context),
          ],
        ),
      ),
    );
  }

  /// 🔙 Top bar
  Widget _topBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canGoBack = context.canPop();

    return Row(
      children: [
        if (canGoBack)
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: colors.onSurface),
            onPressed: () => context.pop(),
          ),
        if (canGoBack) const SizedBox(width: 4),
        Text(
          'Give',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }

  /// 💳 Bank Card (IMPROVED)
  Widget _bankCard(BuildContext context) {
    const accountNumber = "0246487286";
    const bankName = "Guaranty Trust Bank (GTBank)";
    const accountName = "Davids C. CHURCH DAVIDS ARMY";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7A00), Color(0xFFFFA040)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🏦 TOP ROW (Bank + Copy)
          Row(
            children: [
              Expanded(
                child: Text(
                  "Bank: $bankName",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// 📋 COPY ICON (TOP RIGHT)
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: accountNumber));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied account number")),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.copy, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// 💳 ACCOUNT NUMBER
          Text(
            accountNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 20),

          /// 👤 ACCOUNT NAME
          Text(
            accountName,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// ✨ Inspiration
  Widget _inspirationCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Give, and it will be given to you. — Luke 6:38",
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  /// 🙏 Chips
  Widget _categoryChips(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final items = ["Tithe", "Offering", "Camp David", "Seed"];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item,
            style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
          ),
        );
      }).toList(),
    );
  }
}
