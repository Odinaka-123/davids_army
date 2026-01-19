import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/featured_section.dart';
import 'widgets/upcoming_events_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),

            const SizedBox(height: 16),
            const FeaturedSection(),

            const SizedBox(height: 32),
            const UpcomingEventsSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
