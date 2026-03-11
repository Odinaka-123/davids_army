import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryColor = Color(0xFF01410A);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final first = data["firstName"] ?? "";
          final last = data["lastName"] ?? "";
          final email = data["email"] ?? "";
          final photoUrl = data["photoUrl"];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            children: [
              _topBar(context),
              const SizedBox(height: 20),

              _profileHeader(context, first, last, email, photoUrl),

              const SizedBox(height: 28),

              _sectionTitle('Personal info'),
              _infoCard([
                _infoRow(Icons.badge_outlined, 'First name', first),
                _infoRow(Icons.badge, 'Last name', last),
              ]),

              const SizedBox(height: 20),

              _sectionTitle('Contact'),
              _infoCard([
                _infoRow(Icons.email_outlined, 'Email', email),
                _infoRow(Icons.phone_outlined, 'Phone', data["phone"] ?? ""),
              ]),

              const SizedBox(height: 20),

              _sectionTitle('Address'),
              _infoCard([
                _infoRow(
                  Icons.location_city_outlined,
                  'City',
                  data["city"] ?? "",
                ),
                _infoRow(Icons.map_outlined, 'State', data["state"] ?? ""),
                _infoRow(
                  Icons.public_outlined,
                  'Country',
                  data["country"] ?? "",
                ),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        const SizedBox(width: 12),
        const Text(
          'Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _profileHeader(
    BuildContext context,
    String first,
    String last,
    String email,
    String? photoUrl,
  ) {
    return Row(
      children: [
        _avatar(first, last, photoUrl),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$first $last",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: () => context.push('/edit-profile'),
                child: const Text('Edit profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(String first, String last, String? photoUrl) {
    String initials = "";

    if (first.isNotEmpty) {
      initials += first[0];
    }

    if (last.isNotEmpty) {
      initials += last[0];
    }

    initials = initials.toUpperCase();

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(radius: 36, backgroundImage: NetworkImage(photoUrl));
    }

    if (initials.isNotEmpty) {
      return CircleAvatar(
        radius: 36,
        backgroundColor: const Color(0xFFE8F5E9),
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      );
    }

    return const CircleAvatar(
      radius: 36,
      backgroundColor: Color(0xFFE8F5E9),
      child: Icon(Icons.person, size: 36),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
