import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:davids_army/models/sermon.dart';

class YouTubeService {
  static const _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const _channelHandle = 'giantslayertv8239';

  Future<String> _getUploadsPlaylistId() async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'YouTube API key not provided. Use --dart-define=YOUTUBE_API_KEY=YOUR_KEY',
      );
    }

    final channelUrl = Uri.parse(
      'https://www.googleapis.com/youtube/v3/channels'
      '?part=contentDetails'
      '&forHandle=$_channelHandle'
      '&key=$_apiKey',
    );

    final response = await http.get(channelUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch channel details');
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List;

    if (items.isEmpty) {
      throw Exception('Channel not found');
    }

    return items[0]['contentDetails']['relatedPlaylists']['uploads'];
  }

  Future<List<Sermon>> fetchSermons() async {
    final uploadsPlaylistId = await _getUploadsPlaylistId();

    final videosUrl = Uri.parse(
      'https://www.googleapis.com/youtube/v3/playlistItems'
      '?part=snippet'
      '&playlistId=$uploadsPlaylistId'
      '&maxResults=25'
      '&key=$_apiKey',
    );

    final response = await http.get(videosUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to load sermons');
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List;

    return items.map((item) {
      final snippet = item['snippet'];
      return Sermon(
        videoId: snippet['resourceId']['videoId'],
        title: snippet['title'],
        thumbnail: snippet['thumbnails']['high']['url'],
        date: snippet['publishedAt'].substring(0, 10),
      );
    }).toList();
  }
}
