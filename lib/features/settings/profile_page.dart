import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryColor = Color(0xFF01410A);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final user = FirebaseAuth.instance.currentUser;

    return PopScope(
      canPop: context.canPop(),
      onPopInvoked: (didPop) {
        if (!didPop && !context.canPop()) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        extendBody: true,
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

            return SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                children: [
                  _topBar(context),
                  const SizedBox(height: 20),

                  _profileHeader(context, first, last, email, photoUrl),

                  const SizedBox(height: 28),

                  _sectionTitle(context, 'Personal info'),
                  _infoCard(context, [
                    _infoRow(
                      context,
                      Icons.badge_outlined,
                      'First name',
                      first,
                    ),
                    _infoRow(context, Icons.badge, 'Last name', last),
                  ]),

                  const SizedBox(height: 20),

                  _sectionTitle(context, 'Contact'),
                  _infoCard(context, [
                    _infoRow(context, Icons.email_outlined, 'Email', email),
                    _infoRow(
                      context,
                      Icons.phone_outlined,
                      'Phone',
                      data["phone"] ?? "",
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _sectionTitle(context, 'Address'),
                  _infoCard(context, [
                    _infoRow(
                      context,
                      Icons.location_city_outlined,
                      'City',
                      data["city"] ?? "",
                    ),
                    _infoRow(
                      context,
                      Icons.map_outlined,
                      'State',
                      data["state"] ?? "",
                    ),
                    _infoRow(
                      context,
                      Icons.public_outlined,
                      'Country',
                      data["country"] ?? "",
                    ),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canGoBack = context.canPop();

    return Row(
      children: [
        if (canGoBack)
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: colors.onBackground),
            onPressed: () => context.pop(),
          ),
        if (canGoBack) const SizedBox(width: 4),
        Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onBackground,
          ),
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
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        _avatar(context, first, last, photoUrl),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$first $last",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.onBackground,
                ),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: colors.primary),
                onPressed: () => context.push('/edit-profile'),
                child: const Text('Edit profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(
    BuildContext context,
    String first,
    String last,
    String? photoUrl,
  ) {
    final colors = Theme.of(context).colorScheme;

    String initials = "";

    if (first.isNotEmpty) initials += first[0];
    if (last.isNotEmpty) initials += last[0];

    initials = initials.toUpperCase();

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(radius: 36, backgroundImage: NetworkImage(photoUrl));
    }

    if (initials.isNotEmpty) {
      return CircleAvatar(
        radius: 36,
        backgroundColor: colors.primaryContainer,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onPrimaryContainer,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 36,
      backgroundColor: colors.primaryContainer,
      child: Icon(Icons.person, size: 36, color: colors.onPrimaryContainer),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, List<Widget> rows) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              Divider(height: 1, color: colors.outlineVariant),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colors.primary),
      title: Text(
        label,
        style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        value.isEmpty ? "-" : value,
        style: TextStyle(color: colors.onSurfaceVariant),
      ),
    );
  }
}
