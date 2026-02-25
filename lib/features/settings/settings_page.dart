import 'package:flutter/material.dart';
import '../../features/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color primaryColor = Color.fromARGB(255, 1, 65, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Settings content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Account Section
                _buildSectionHeader('Account'),
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Update your personal info',
                  onTap: () => context.push('/profile'),
                ),
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: Colors.red,
                  onTap: () => _confirmLogout(context),
                ),
                const Divider(),

                // Preferences Section
                _buildSectionHeader('Preferences'),
                _buildSettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  trailing: Switch(
                    activeColor: primaryColor,
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  trailing: Switch(
                    activeColor: primaryColor,
                    value: false,
                    onChanged: (val) {},
                  ),
                ),
                const Divider(),

                // About Section
                _buildSectionHeader('About'),
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'App Version',
                  subtitle: 'v1.0.0',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {},
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? primaryColor),
        title: Text(title, style: TextStyle(color: titleColor ?? Colors.black)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
