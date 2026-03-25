import 'package:flutter/material.dart';
import 'upcoming_event_card.dart';
import 'package:davids_army/features/resources/events/pages/camp_david_page.dart';
import 'package:davids_army/features/resources/events/pages/bible_study_page.dart';

class UpcomingEventsSection extends StatelessWidget {
  const UpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upcoming Events",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),

          UpcomingEventCard(
            title: "Camp David",
            imagePath: "assets/images/campdavid.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CampDavidPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          UpcomingEventCard(
            title: "Bible Study",
            imagePath: "assets/images/bible_study.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BibleStudyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
