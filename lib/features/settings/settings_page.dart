import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../features/auth/auth_service.dart';
import '../../core/theme_controller.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color _primary = Color(0xFF01410A);
  static const Color _primaryLight = Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bottomPad =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: colors.surfaceVariant.withOpacity(0.3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF01410A), Color(0xFF027A14)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => context.pop('/'),
                    ),
                    Text(
                      "Settings",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad + 24),
              children: [
                // ── Account ────────────────────────────────────────
                _SectionLabel(label: "Account"),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline,
                      title: "Profile",
                      subtitle: "Update your personal info",
                      iconBg: _primaryLight,
                      iconColor: _primary,
                      onTap: () => context.push('/profile'),
                    ),
                    _SettingsTile(
                      icon: Icons.logout_outlined,
                      title: "Logout",
                      iconBg: Colors.red.shade50,
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      isLast: true,
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Preferences ────────────────────────────────────
                _SectionLabel(label: "Preferences"),
                _ThemeSelector(primary: _primary, primaryLight: _primaryLight),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _NotificationTile(
                      iconBg: _primaryLight,
                      iconColor: _primary,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── About ──────────────────────────────────────────
                _SectionLabel(label: "About"),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: "App version",
                      iconBg: _primaryLight,
                      iconColor: _primary,
                      trailingWidget: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "v1.0.0",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _primary,
                          ),
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: "Help & support",
                      iconBg: _primaryLight,
                      iconColor: _primary,
                      isLast: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AuthService().signOut();
              if (context.mounted) context.go('/auth');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
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
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
        ),
      ),
    );
  }
}

// ── Settings card (groups tiles) ──────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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

// ── Settings tile ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.iconBg,
    required this.iconColor,
    this.subtitle,
    this.titleColor,
    this.trailingWidget,
    this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final Color iconBg;
  final Color iconColor;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(16),
            bottom: isLast ? const Radius.circular(16) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: titleColor ?? colors.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurface.withOpacity(0.45),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingWidget != null)
                  trailingWidget!
                else if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: colors.onSurface.withOpacity(0.3),
                  ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: colors.outlineVariant.withOpacity(0.5),
          ),
      ],
    );
  }
}

// ── Notification tile (Firebase-backed) ──────────────────────────────────────

class _NotificationTile extends StatefulWidget {
  const _NotificationTile({required this.iconBg, required this.iconColor});

  final Color iconBg;
  final Color iconColor;

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  bool _enabled = false;
  bool _loading = true;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  Future<void> loadPreference() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    final data = doc.data() ?? {};
    setState(() {
      _enabled = data["notificationsEnabled"] ?? false;
      _loading = false;
    });
  }

  Future<void> toggleNotifications(bool value) async {
    setState(() => _enabled = value);
    try {
      if (value) {
        await FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.subscribeToTopic("all");
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic("all");
      }
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "notificationsEnabled": value,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Notification toggle error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 18,
              color: widget.iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  "Push alerts",
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurface.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            onChanged: toggleNotifications,
            activeColor: widget.iconColor,
          ),
        ],
      ),
    );
  }
}

// ── Theme selector ────────────────────────────────────────────────────────────

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.primary, required this.primaryLight});
  final Color primary;
  final Color primaryLight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.palette_outlined,
                      size: 18,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "App theme",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  width: constraints.maxWidth,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text("Light"),
                        icon: Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text("Dark"),
                        icon: Icon(Icons.dark_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text("Auto"),
                        icon: Icon(Icons.phone_android_outlined),
                      ),
                    ],
                    selected: {mode},
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return primary;
                        }
                        return null;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.white;
                        }
                        return null;
                      }),
                    ),
                    onSelectionChanged: (val) =>
                        ThemeController.setTheme(val.first),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
