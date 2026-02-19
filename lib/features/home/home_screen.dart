import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/featured_section.dart';
import 'widgets/upcoming_events_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeader(),
              SizedBox(height: 16),
              FeaturedSection(),
              SizedBox(height: 32),
              UpcomingEventsSection(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
