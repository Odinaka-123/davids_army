import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _country = TextEditingController();

  final _user = FirebaseAuth.instance.currentUser!;
  final _picker = ImagePicker();

  File? _imageFile;
  String? _existingBase64;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _city.dispose();
    _state.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .get();

    final data = doc.data() ?? {};

    _firstName.text = data["firstName"] ?? "";
    _lastName.text = data["lastName"] ?? "";
    _phone.text = data["phone"] ?? "";
    _city.text = data["city"] ?? "";
    _state.text = data["state"] ?? "";
    _country.text = data["country"] ?? "";
    _existingBase64 = data["photoBase64"];

    setState(() => _loading = false);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      String? base64Image;
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .update({
            "firstName": _firstName.text.trim(),
            "lastName": _lastName.text.trim(),
            "phone": _phone.text.trim(),
            "city": _city.text.trim(),
            "state": _state.text.trim(),
            "country": _country.text.trim(),
            if (base64Image != null) "photoBase64": base64Image,
          });

      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save: $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceVariant.withOpacity(0.3),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: colors.primary))
          : CustomScrollView(
              slivers: [
                // ── App bar + avatar picker ──────────────────────────
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: colors.primary,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    _saving
                        ? const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TextButton(
                              onPressed: _saveProfile,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Gradient cover
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [colors.primary, colors.tertiary],
                            ),
                          ),
                        ),
                        // Dot pattern
                        Opacity(
                          opacity: 0.08,
                          child: CustomPaint(painter: _DotPatternPainter()),
                        ),
                        // Avatar + hint
                        Align(
                          alignment: const Alignment(0, 0.7),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _AvatarPicker(
                                imageFile: _imageFile,
                                existingBase64: _existingBase64,
                                initials:
                                    (_firstName.text.isNotEmpty
                                        ? _firstName.text[0]
                                        : "") +
                                    (_lastName.text.isNotEmpty
                                        ? _lastName.text[0]
                                        : ""),
                                onTap: _pickImage,
                                colors: colors,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap to change photo",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Form body ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      24,
                      16,
                      40 +
                          MediaQuery.of(context).padding.bottom +
                          kBottomNavigationBarHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: "Personal info"),
                        _FormCard(
                          children: [
                            _FormField(
                              controller: _firstName,
                              icon: Icons.person_outline,
                              label: "First name",
                              hint: "Enter first name",
                              colors: colors,
                            ),
                            _FormField(
                              controller: _lastName,
                              icon: Icons.person_outline,
                              label: "Last name",
                              hint: "Enter last name",
                              colors: colors,
                            ),
                            _FormField(
                              controller: _phone,
                              icon: Icons.phone_outlined,
                              label: "Phone",
                              hint: "Enter phone number",
                              keyboard: TextInputType.phone,
                              colors: colors,
                              isLast: true,
                            ),
                          ],
                          colors: colors,
                        ),

                        const SizedBox(height: 16),

                        _SectionLabel(label: "Location"),
                        _FormCard(
                          children: [
                            _FormField(
                              controller: _city,
                              icon: Icons.location_city_outlined,
                              label: "City",
                              hint: "Enter city",
                              colors: colors,
                            ),
                            _FormField(
                              controller: _state,
                              icon: Icons.map_outlined,
                              label: "State",
                              hint: "Enter state",
                              colors: colors,
                            ),
                            _FormField(
                              controller: _country,
                              icon: Icons.public_outlined,
                              label: "Country",
                              hint: "Enter country",
                              colors: colors,
                              isLast: true,
                            ),
                          ],
                          colors: colors,
                        ),

                        const SizedBox(height: 24),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _saveProfile,
                            icon: _saving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined, size: 18),
                            label: Text(_saving ? "Saving…" : "Save changes"),
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
            ),
    );
  }
}

// ── Avatar picker ─────────────────────────────────────────────────────────────

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.imageFile,
    required this.existingBase64,
    required this.initials,
    required this.onTap,
    required this.colors,
  });

  final File? imageFile;
  final String? existingBase64;
  final String initials;
  final VoidCallback onTap;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (imageFile != null) {
      image = FileImage(imageFile!);
    } else if (existingBase64 != null) {
      image = MemoryImage(base64Decode(existingBase64!));
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: colors.primaryContainer,
              backgroundImage: image,
              child: image == null
                  ? Text(
                      initials,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: colors.onPrimaryContainer,
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 14,
                color: Colors.grey[700],
              ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
        ),
      ),
    );
  }
}

// ── Form card ─────────────────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  const _FormCard({required this.children, required this.colors});
  final List<Widget> children;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// ── Form field ────────────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.icon,
    required this.label,
    required this.hint,
    required this.colors,
    this.keyboard = TextInputType.text,
    this.isLast = false,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;
  final String hint;
  final ColorScheme colors;
  final TextInputType keyboard;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: TextField(
                  controller: controller,
                  keyboardType: keyboard,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hint,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withOpacity(0.5),
                    ),
                    hintStyle: TextStyle(
                      color: colors.onSurface.withOpacity(0.3),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
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
