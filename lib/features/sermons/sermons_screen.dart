import 'package:flutter/material.dart';
import 'package:davids_army/core/services/youtube_service.dart';
import 'package:davids_army/models/sermon.dart';
import 'widgets/sermons_video_card.dart';

class SermonsScreen extends StatefulWidget {
  const SermonsScreen({super.key});

  @override
  State<SermonsScreen> createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<SermonsScreen> {
  late Future<List<Sermon>> _futureSermons;

  @override
  void initState() {
    super.initState();
    _futureSermons = YouTubeService().fetchSermons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sermons"), centerTitle: true),
      body: FutureBuilder<List<Sermon>>(
        future: _futureSermons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load sermons"));
          }

          final sermons = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sermons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SermonsVideoCard(sermon: sermons[index]),
              );
            },
          );
        },
      ),
    );
  }
}
