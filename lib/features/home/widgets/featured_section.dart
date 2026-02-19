import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'featured_card.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Featured",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: FeaturedCard(
                  title: "Sermons",
                  subtitle: "Watch Here",
                  imagePath: "assets/images/sermons.jpg",
                  height: 260,
                  onTap: () => context.push('/sermons'),
                  bottomWidget: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  children: [
                    FeaturedCard(
                      title: "Prayer Request",
                      subtitle: "Let's Pray Together",
                      imagePath: "assets/images/prayer.jpg",
                      height: 124,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    FeaturedCard(
                      title: "Get Connected",
                      subtitle: "Join Us",
                      imagePath: "assets/images/community.jpg",
                      height: 124,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
