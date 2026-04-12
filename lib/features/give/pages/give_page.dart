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

  int _selectedCategory = 0;

  static const _categories = [
    _GiveCategory(
      label: "Tithe",
      subtitle: "10% of income",
      icon: Icons.volunteer_activism_outlined,
    ),
    _GiveCategory(
      label: "Offering",
      subtitle: "Freewill gift",
      icon: Icons.card_giftcard_outlined,
    ),
    _GiveCategory(
      label: "Camp David",
      subtitle: "Special project",
      icon: Icons.house_outlined,
    ),
    _GiveCategory(
      label: "Seed",
      subtitle: "Faith giving",
      icon: Icons.eco_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bottomPad =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: colors.surfaceVariant.withOpacity(0.3),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 20, 16, bottomPad + 24),
          children: [
            _TopBar(),
            const SizedBox(height: 28),

            // ── Animated bank card ──────────────────────────────────
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: const _BankCard(),
              ),
            ),

            const SizedBox(height: 28),

            // ── Verse ───────────────────────────────────────────────
            _VerseCard(colors: colors),

            const SizedBox(height: 28),

            // ── Giving type ─────────────────────────────────────────
            _SectionLabel(label: "Giving type"),
            const SizedBox(height: 10),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.55,
              ),
              itemBuilder: (context, i) => _CategoryChip(
                category: _categories[i],
                selected: _selectedCategory == i,
                onTap: () => setState(() => _selectedCategory = i),
              ),
            ),

            const SizedBox(height: 28),

            // ── Give button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7A00), Color(0xFFFF5500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A00).withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outline, size: 18),
                  label: Text(
                    "Give — ${_categories[_selectedCategory].label}",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canGoBack = context.canPop();

    return Row(
      children: [
        if (canGoBack) ...[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colors.onSurface,
              size: 20,
            ),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          'Give',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: colors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ── Bank card ─────────────────────────────────────────────────────────────────

class _BankCard extends StatelessWidget {
  const _BankCard();

  static const _accountNumber = "0246487286";
  static const _bankName = "Guaranty Trust Bank";
  static const _accountName = "Davids Church · Davids Army";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7A00), Color(0xFFFF5500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A00).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: 10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BANK",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          _bankName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        const ClipboardData(text: _accountNumber),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Account number copied"),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.inverseSurface,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.copy_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Copy",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // SIM chip
              Container(
                width: 36,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD580), Color(0xFFF0A500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Account number
              Text(
                _accountNumber.replaceAllMapped(
                  RegExp(r'.{4}'),
                  (m) => '${m[0]} ',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ACCOUNT NAME",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          _accountName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "GT",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Verse card ────────────────────────────────────────────────────────────────

class _VerseCard extends StatelessWidget {
  const _VerseCard({required this.colors});
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A00), Color(0xFFFF5500)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"Give, and it will be given to you — good measure, pressed down, shaken together and running over."',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                    color: colors.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Luke 6:38",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF7A00),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
      ),
    );
  }
}

// ── Category chip ─────────────────────────────────────────────────────────────

class _GiveCategory {
  final String label;
  final String subtitle;
  final IconData icon;

  const _GiveCategory({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _GiveCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFFF7A00), Color(0xFFFF5500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : colors.surface,
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFFFF7A00).withOpacity(0.3)
                  : colors.shadow.withOpacity(0.05),
              blurRadius: selected ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 22,
              color: selected ? Colors.white : const Color(0xFFFF7A00),
            ),
            const SizedBox(height: 6),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : colors.onSurface,
              ),
            ),
            Text(
              category.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: selected
                    ? Colors.white.withOpacity(0.7)
                    : colors.onSurface.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
