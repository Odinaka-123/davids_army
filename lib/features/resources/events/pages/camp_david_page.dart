import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CampDavidPage extends StatelessWidget {
  const CampDavidPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Camp David",
          style: TextStyle(
            color: colors.onBackground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HERO IMAGE
            Image.asset(
              "assets/images/campdavid.jpg",
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    "Camp David",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: colors.onBackground,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// DATE
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 20,
                        color: colors.onBackground,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "29th July – 2nd August",
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// TIME
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 20,
                        color: colors.onBackground,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Full Camp Experience",
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 10),

                  /// SUPPORT CONTACT
                  Row(
                    children: [
                      Icon(Icons.phone, size: 20, color: colors.onBackground),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.parse("tel:08172147524");
                          await launchUrl(url);
                        },
                        child: Text(
                          "Support: 08172147524",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  Text(
                    "Camp David is a summer camp designed especially for teenagers. "
                    "It is a safe and inspiring environment where young people are encouraged "
                    "to discover who they truly are, build meaningful friendships, and develop "
                    "a stronger spiritual connection with God.\n\n"
                    "Through engaging activities, guided discussions, worship, and moments of reflection, "
                    "Camp David helps teenagers grow in confidence, character, and faith. "
                    "It is more than just a camp — it’s a life-shaping experience that empowers teens "
                    "to live with purpose and stand strong in their identity.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: colors.onBackground.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () async {
                        final url = Uri.parse("https://campdavid.com.ng/");

                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
