import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryColor = Color(0xFF01410A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        children: [
          _topBar(context),
          const SizedBox(height: 20),
          _profileHeader(context),
          const SizedBox(height: 28),

          _sectionTitle('Personal info'),
          _infoCard([
            _infoRow(Icons.badge_outlined, 'First name', 'Ikenna'),
            _infoRow(Icons.badge, 'Last name', 'Ibeneme'),
            _infoRow(Icons.person_outline, 'Middle name', 'Benjamin'),
          ]),

          const SizedBox(height: 20),
          _sectionTitle('Contact'),
          _infoCard([
            _infoRow(
              Icons.email_outlined,
              'Email',
              'ibenemeikenna96@gmail.com',
            ),
            _infoRow(Icons.phone_outlined, 'Phone', '08120710198'),
          ]),

          const SizedBox(height: 20),
          _sectionTitle('Address'),
          _infoCard([
            _infoRow(Icons.home_outlined, 'Street', 'No 12 Ada George Road'),
            _infoRow(Icons.location_city_outlined, 'City', 'Port Harcourt'),
            _infoRow(Icons.map_outlined, 'State', 'Rivers State'),
            _infoRow(Icons.public_outlined, 'Country', 'Nigeria'),
          ]),
        ],
      ),
    );
  }

  // TOP BAR
  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // HEADER
  Widget _profileHeader(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 36,
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.person, size: 36, color: Colors.black54),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ibeneme Ikenna',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                'ibenemeikenna96@gmail.com',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.push('/edit-profile'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                ),
                child: const Text('Edit profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // CARD
  Widget _infoCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: rows),
    );
  }

  // ROW
  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool last = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.black54),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last)
          const Divider(height: 1, indent: 48, endIndent: 12, thickness: 0.6),
      ],
    );
  }
}
