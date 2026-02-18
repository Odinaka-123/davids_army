import 'package:flutter/material.dart';
import 'package:davids_army/models/sermon.dart';
import 'package:url_launcher/url_launcher.dart';

class SermonsVideoCard extends StatelessWidget {
  final Sermon sermon;

  const SermonsVideoCard({super.key, required this.sermon});

  Future<void> _openVideo() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=${sermon.videoId}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openVideo,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(sermon.thumbnail, fit: BoxFit.cover),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            const Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.play_arrow, color: Colors.black, size: 32),
              ),
            ),

            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sermon.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sermon.date,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//videoId: 'dQw4w9WgXcQ',