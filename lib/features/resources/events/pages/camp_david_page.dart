import 'package:flutter/material.dart';

class CampDavidPage extends StatelessWidget {
  const CampDavidPage({super.key});

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
          "Camp David",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
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
                  const Text(
                    "Camp David",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 16),

                  /// DATE
                  Row(
                    children: const [
                      Icon(Icons.calendar_month, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "We'll let you know soon",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// TIME
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "We'll let you know soon",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// THEME
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.book_outlined, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Theme: We'll let you know soon",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
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
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Registration flow
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "REGISTER",
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
