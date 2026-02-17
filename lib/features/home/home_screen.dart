import 'package:flutter/material.dart';
import 'widgets/featured_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FeaturedSection(
          title: 'Featured Mission',
          subtitle: 'Join today and make impact',
          onTap: () {
            debugPrint('Featured section tapped');
          },
        ),
      ),
    );
  }
}
