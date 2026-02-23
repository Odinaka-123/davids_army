import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color primaryColor = Color.fromARGB(255, 1, 65, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap body in SafeArea
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Account Section
            _buildSectionHeader('Account'),
            _buildSettingsTile(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'Update your personal info',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {},
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
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: primaryColor.withOpacity(0.1),
    );
  }
}
