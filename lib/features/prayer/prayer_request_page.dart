import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerRequestPage extends StatefulWidget {
  const PrayerRequestPage({super.key});

  @override
  State<PrayerRequestPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestPage> {
  final TextEditingController _prayerController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isAnonymous = false;
  bool isLoading = false;

  void _submit() async {
    final text = _prayerController.text.trim();
    final name = _nameController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write your prayer request")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('prayers').add({
        "text": text,
        "name": isAnonymous ? null : name,
        "anonymous": isAnonymous,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _prayerController.clear();
      _nameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your prayer has been received ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            _topBar(context),
            const SizedBox(height: 24),

            // ── Hero card ──────────────────────────────────────────────
            _heroCard(context),
            const SizedBox(height: 32),

            // ── Prayer text field ──────────────────────────────────────
            _sectionLabel(context, "Your request"),
            const SizedBox(height: 8),
            TextField(
              controller: _prayerController,
              maxLines: 7,
              style: textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "Write what's on your heart...",
                hintStyle: TextStyle(
                  color: colors.onSurfaceVariant.withOpacity(0.55),
                  fontWeight: FontWeight.w300,
                ),
                filled: true,
                fillColor: colors.surfaceContainerHighest,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: colors.primary, width: 1.5),
                ),
              ),
            ),

            // ── Name field (hidden when anonymous) ────────────────────
            if (!isAnonymous) ...[
              const SizedBox(height: 20),
              _sectionLabel(context, "Your name"),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "How should we address you? (optional)",
                  hintStyle: TextStyle(
                    color: colors.onSurfaceVariant.withOpacity(0.55),
                    fontWeight: FontWeight.w300,
                  ),
                  filled: true,
                  fillColor: colors.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ── Anonymous toggle card ──────────────────────────────────
            _sectionLabel(context, "Privacy"),
            const SizedBox(height: 8),
            _anonymousToggleCard(context, colors),

            const SizedBox(height: 32),

            // ── Submit button ─────────────────────────────────────────
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  disabledBackgroundColor: colors.primary.withOpacity(0.55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_rounded, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            "Submit Prayer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Privacy note ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: colors.onSurfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(width: 5),
                Text(
                  "Your request is private and handled with care",
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero card ────────────────────────────────────────────────────────────
  Widget _heroCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primary.withOpacity(0.12), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "WE HEAR YOU",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "We're here to pray\nwith you.",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Share your heart and our team will\nstand in faith alongside you.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: colors.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // ── Anonymous toggle card ────────────────────────────────────────────────
  Widget _anonymousToggleCard(BuildContext context, ColorScheme colors) {
    return GestureDetector(
      onTap: () => setState(() => isAnonymous = !isAnonymous),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAnonymous
                ? colors.primary.withOpacity(0.35)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.group_outlined,
                size: 20,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Submit anonymously",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Your name won't be shared",
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isAnonymous,
              onChanged: (val) => setState(() => isAnonymous = val),
              activeColor: colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────────────────
  Widget _sectionLabel(BuildContext context, String label) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: colors.onSurfaceVariant,
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────────────
  Widget _topBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceContainerHighest,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: colors.onSurface,
            ),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Prayer Request",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
