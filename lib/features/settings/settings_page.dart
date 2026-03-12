import 'package:flutter/material.dart';
import '../../features/auth/auth_service.dart';
import '../../core/theme_controller.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color primaryColor = Color.fromARGB(255, 1, 65, 10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // PAGE TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Settings",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  // ACCOUNT
                  _buildSectionHeader(context, "Account"),
                  _buildSettingsTile(
                    context,
                    icon: Icons.person,
                    title: "Profile",
                    subtitle: "Update your personal info",
                    onTap: () => context.push('/profile'),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.logout,
                    title: "Logout",
                    titleColor: Colors.red,
                    onTap: () => _confirmLogout(context),
                  ),
                  const SizedBox(height: 10),

                  // PREFERENCES
                  _buildSectionHeader(context, "Preferences"),
                  _buildThemeSelector(context),
                  _buildSettingsTile(
                    context,
                    icon: Icons.notifications,
                    title: "Notifications",
                    trailing: Switch(
                      value: false,
                      onChanged: (val) {},
                      activeColor: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ABOUT
                  _buildSectionHeader(context, "About"),
                  _buildSettingsTile(
                    context,
                    icon: Icons.info,
                    title: "App Version",
                    subtitle: "v1.0.0",
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.help,
                    title: "Help & Support",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // THEME SELECTOR
  Widget _buildThemeSelector(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "App Theme",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              // Ensure the buttons can expand fully
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text("Light"),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text("Dark"),
                          icon: Icon(Icons.dark_mode),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text("Auto"), // shorter text
                          icon: Icon(Icons.phone_android),
                        ),
                      ],
                      selected: {mode},
                      showSelectedIcon: false,
                      onSelectionChanged: (newSelection) {
                        ThemeController.setTheme(newSelection.first);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
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
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ICON COLOR ADAPTIVE
    final iconColor =
        titleColor ??
        (theme.brightness == Brightness.dark ? Colors.white70 : primaryColor);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: titleColor ?? colors.onSurface),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }
}
