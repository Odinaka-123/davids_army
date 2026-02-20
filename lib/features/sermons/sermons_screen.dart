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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureSermons = YouTubeService().fetchSermons();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F9FB),
      child: SafeArea(
        child: Column(
          children: [
            /// 🔴 Title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                "Sermons",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),

            /// 🔍 Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: "Search sermons...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            /// Section title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Latest Sermons",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            /// Sermons list
            Expanded(
              child: FutureBuilder<List<Sermon>>(
                future: _futureSermons,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final sermons = snapshot.data!
                      .where(
                        (s) => s.title.toLowerCase().contains(_searchQuery),
                      )
                      .toList();

                  if (sermons.isEmpty) {
                    return const Center(child: Text("No sermons found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: sermons.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SermonsVideoCard(sermon: sermons[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
