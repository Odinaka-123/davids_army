import 'package:flutter/material.dart';

class BibleStudyPage extends StatelessWidget {
  const BibleStudyPage({super.key});

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
          "Bible Study",
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
            /// 📸 HERO IMAGE
            Image.asset(
              "assets/images/bible_study.png",
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
                    "Bible Study",
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
                        "Every Thursday",
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
                        "8:00 PM WAT",
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// LOCATION
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: colors.onBackground,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Live WhatsApp Call (Link will be shared in the group)",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION (slightly softer)
                  Text(
                    "Join us for a powerful time of studying God’s Word together. "
                    "Our Bible Study sessions are designed to help you grow deeper "
                    "in your understanding of scripture, strengthen your faith, "
                    "and apply biblical principles to your everyday life.\n\n"
                    "Through teaching, discussion, and reflection, you’ll gain clarity, "
                    "wisdom, and spiritual insight in a welcoming and engaging environment. "
                    "Whether you're new to the faith or looking to go deeper, "
                    "there’s something here for you.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: colors.onBackground.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// JOIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Add join link
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "JOIN SESSION",
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
