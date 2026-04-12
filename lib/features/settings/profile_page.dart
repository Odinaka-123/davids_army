import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceVariant.withOpacity(0.3),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          final first = data["firstName"] ?? "";
          final last = data["lastName"] ?? "";
          final email = data["email"] ?? "";
          final phone = data["phone"] ?? "";
          final city = data["city"] ?? "";
          final state = data["state"] ?? "";
          final country = data["country"] ?? "";
          final photoBase64 = data["photoBase64"];

          final initials =
              (first.isNotEmpty ? first[0] : "") +
              (last.isNotEmpty ? last[0] : "");

          final location = [
            city,
            state,
            country,
          ].where((s) => s.isNotEmpty).join(", ");

          return CustomScrollView(
            slivers: [
              // ── Collapsible header with cover gradient ──────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: colors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [colors.primary, colors.tertiary],
                          ),
                        ),
                      ),
                      // Subtle pattern overlay
                      Opacity(
                        opacity: 0.08,
                        child: CustomPaint(painter: _DotPatternPainter()),
                      ),
                      // Avatar centred in the lower half
                      Align(
                        alignment: const Alignment(0, 0.85),
                        child: _Avatar(
                          photoBase64: photoBase64,
                          initials: initials,
                          colors: colors,
                          radius: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => context.push('/edit-profile'),
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: "Edit profile",
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                  ),
                  const SizedBox(width: 4),
                ],
              ),

              // ── Body ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    32 +
                        MediaQuery.of(context).padding.bottom +
                        kBottomNavigationBarHeight,
                  ),
                  child: Column(
                    children: [
                      // Name + email + location pill
                      Text(
                        "$first $last",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withOpacity(0.55),
                        ),
                      ),
                      if (location.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _LocationChip(location: location, colors: colors),
                      ],

                      const SizedBox(height: 28),

                      // ── Info card ──────────────────────────────────
                      _InfoCard(
                        title: "Personal info",
                        children: [
                          _InfoRow(
                            icon: Icons.person_outline,
                            label: "First name",
                            value: first,
                            colors: colors,
                          ),
                          _InfoRow(
                            icon: Icons.person_outline,
                            label: "Last name",
                            value: last,
                            colors: colors,
                          ),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: "Email",
                            value: email,
                            colors: colors,
                          ),
                          _InfoRow(
                            icon: Icons.phone_outlined,
                            label: "Phone",
                            value: phone,
                            colors: colors,
                            isLast: true,
                          ),
                        ],
                        colors: colors,
                      ),

                      const SizedBox(height: 16),

                      _InfoCard(
                        title: "Location",
                        children: [
                          _InfoRow(
                            icon: Icons.location_city_outlined,
                            label: "City",
                            value: city,
                            colors: colors,
                          ),
                          _InfoRow(
                            icon: Icons.map_outlined,
                            label: "State",
                            value: state,
                            colors: colors,
                          ),
                          _InfoRow(
                            icon: Icons.public_outlined,
                            label: "Country",
                            value: country,
                            colors: colors,
                            isLast: true,
                          ),
                        ],
                        colors: colors,
                      ),

                      const SizedBox(height: 24),

                      // ── Edit button ────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => context.push('/edit-profile'),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text("Edit profile"),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.photoBase64,
    required this.initials,
    required this.colors,
    required this.radius,
  });

  final String? photoBase64;
  final String initials;
  final ColorScheme colors;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: colors.primaryContainer,
        backgroundImage: photoBase64 != null
            ? MemoryImage(base64Decode(photoBase64!))
            : null,
        child: photoBase64 == null
            ? Text(
                initials,
                style: TextStyle(
                  fontSize: radius * 0.5,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimaryContainer,
                ),
              )
            : null,
      ),
    );
  }
}

// ── Location chip ─────────────────────────────────────────────────────────────

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.location, required this.colors});

  final String location;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined, size: 14, color: colors.primary),
          const SizedBox(width: 4),
          Text(
            location,
            style: TextStyle(
              fontSize: 13,
              color: colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
    required this.colors,
  });

  final String title;
  final List<Widget> children;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: colors.onSurface.withOpacity(0.45),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colors;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface.withOpacity(0.45),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      isEmpty ? "—" : value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isEmpty
                            ? colors.onSurface.withOpacity(0.3)
                            : colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 62,
            endIndent: 16,
            color: colors.outlineVariant.withOpacity(0.5),
          ),
      ],
    );
  }
}

// ── Dot pattern painter ───────────────────────────────────────────────────────

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const radius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter oldDelegate) => false;
}
