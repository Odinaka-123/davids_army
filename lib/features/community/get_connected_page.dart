import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetConnectedPage extends StatelessWidget {
  const GetConnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          children: [
            _topBar(context),

            const SizedBox(height: 10),

            /// ✨ SUBTEXT
            Text(
              "Stay connected with the family 🤝",
              style: TextStyle(
                fontSize: 14,
                color: colors.onBackground.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 24),

            /// 💬 COMMUNITY
            _sectionTitle("Join the Community"),
            const SizedBox(height: 12),
            _whatsappCard(context),

            const SizedBox(height: 30),

            /// 🌐 SOCIALS
            _sectionTitle("Stay Connected"),
            const SizedBox(height: 16),
            _socials(context),
          ],
        ),
      ),
    );
  }

  /// 🔙 Top Bar
  Widget _topBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.onBackground),
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: 4),
        Text(
          "Get Connected",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onBackground,
          ),
        ),
      ],
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  /// 💬 WhatsApp Card
  Widget _whatsappCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final url = Uri.parse("https://chat.whatsapp.com/REAL_LINK");

          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green,
                child: Icon(Icons.chat, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WhatsApp Community",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Chat, grow, and stay updated daily",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// 🌐 SOCIALS
  Widget _socials(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialIcon(
          icon: FontAwesomeIcons.instagram,
          label: "Instagram",
          color: const Color(0xFFE1306C),
          link: "https://www.instagram.com/davidsarmyalpha/",
        ),
        _socialIcon(
          icon: FontAwesomeIcons.youtube,
          label: "YouTube",
          color: const Color(0xFFFF0000),
          link: "https://www.youtube.com/@giantslayertv8239",
        ),
        _socialIcon(
          icon: FontAwesomeIcons.spotify,
          label: "Spotify",
          color: const Color(0xFF1DB954),
          link:
              "https://open.spotify.com/show/5BmsIEBAwtyrFj2p9TyP1b?si=302e1cf9e4e643fe",
        ),
      ],
    );
  }

  /// 🔘 Social Icon
  Widget _socialIcon({
    required IconData icon,
    required String label,
    required String link,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(link);

        await launchUrl(url, mode: LaunchMode.externalApplication);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FaIcon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
