import 'package:flutter/material.dart';

class BibleStudyPage extends StatelessWidget {
  const BibleStudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bible Study",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // 👈 ADD THIS
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
                  const Text(
                    "Bible Study",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 16),

                  /// DATE
                  Row(
                    children: const [
                      Icon(Icons.calendar_month, size: 20),
                      SizedBox(width: 8),
                      Text("Every Wednesday", style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// TIME
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 8),
                      Text("6:00 PM", style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// LOCATION / FORMAT
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.location_on_outlined, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Church Auditorium & Online",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
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
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// JOIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Add join link / Zoom / directions
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "JOIN SESSION",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
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
