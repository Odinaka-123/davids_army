import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:davids_army/models/sermon.dart';

class YouTubeService {
  static const _apiKey = 'YOUR_YOUTUBE_API_KEY';
  static const _channelId = 'YOUR_CHANNEL_ID';

  Future<List<Sermon>> fetchSermons() async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search'
      '?part=snippet'
      '&channelId=$_channelId'
      '&maxResults=25'
      '&order=date'
      '&type=video'
      '&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load sermons');
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List;

    return items.map((item) {
      final snippet = item['snippet'];
      return Sermon(
        videoId: item['id']['videoId'],
        title: snippet['title'],
        thumbnail: snippet['thumbnails']['high']['url'],
        date: snippet['publishedAt'].substring(0, 10),
      );
    }).toList();
  }
}
