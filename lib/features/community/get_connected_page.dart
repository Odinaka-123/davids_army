import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconsax/iconsax.dart';

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

            const SizedBox(height: 24),

            /// 💬 COMMUNITY
            _sectionTitle("Join the Community"),
            const SizedBox(height: 12),
            _whatsappCard(context),

            const SizedBox(height: 30),

            /// 🫂 COUNSELLING
            _sectionTitle("Talk to a Leader"),
            const SizedBox(height: 12),
            _counsellingCard(context),

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
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () async {
        final url = Uri.parse("https://chat.whatsapp.com/YOUR_LINK");

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
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
              backgroundColor: Colors.green,
              child: Icon(Icons.chat, color: Colors.white),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                "Join our WhatsApp Community",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colors.primary),
          ],
        ),
      ),
    );
  }

  /// 🫂 Counselling Card
  Widget _counsellingCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        _openCounsellingModal(context);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primary,
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                "Request Counseling / Talk to a Leader",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colors.primary),
          ],
        ),
      ),
    );
  }

  /// 🌐 SOCIALS (UPDATED 🔥)
  Widget _socials(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _socialIcon(
          icon: Iconsax.instagram,
          label: "Instagram",
          color: Colors.purple,
          link: "https://instagram.com/YOUR_PAGE",
        ),
        _socialIcon(
          icon: Icons.ondemand_video, // ✅ YouTube fallback
          label: "YouTube",
          color: Colors.red,
          link: "https://youtube.com/YOUR_CHANNEL",
        ),
        _socialIcon(
          icon: Icons.music_note, // ✅ Spotify fallback
          label: "Spotify",
          color: Colors.green,
          link: "https://spotify.com/YOUR_PROFILE",
        ),
      ],
    );
  }

  Widget _socialIcon({
    required IconData icon,
    required String label,
    required String link,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// 🧾 COUNSELLING MODAL
  void _openCounsellingModal(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            20,
            16,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Talk to a Leader",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Briefly tell us what you'd like to talk about...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Request sent. We'll reach out 🙏"),
                      ),
                    );
                  },
                  child: const Text("Submit Request"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
