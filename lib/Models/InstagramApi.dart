import 'dart:convert';
import 'package:http/http.dart' as http;

class InstagramApi {
  String? _picURL;
  int? _followers;
  int? _following;
  int? _itemsCount;
  bool? _isPrivate;
  final List<Map<String, String>> _mediaItems = [];

  Future<void> getApi(String userName) async {
    final infoUrl = Uri.parse(
      'https://instagram-scraper-api2.p.rapidapi.com/v1/info?username_or_id_or_url=$userName',
    );
    final storyUrl = Uri.parse(
      'https://instagram-scraper-api2.p.rapidapi.com/v1/stories?username_or_id_or_url=$userName',
    );

    final headers = {
      'x-rapidapi-key': 'bd70071364msh50b9d05e841d400p14042cjsn761745e97e06',
      'x-rapidapi-host': 'instagram-scraper-api2.p.rapidapi.com',
    };

    try {
      final infoResponse = await http.get(infoUrl, headers: headers);
      final storyResponse = await http.get(storyUrl, headers: headers);

      if (infoResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponseInfo = json.decode(infoResponse.body);
        _parseInfoData(jsonResponseInfo);
      }

      if (storyResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponseStory = json.decode(storyResponse.body);
        _parseStoryData(jsonResponseStory);
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _parseInfoData(Map<String, dynamic> data) {
    final info = data['data'];
    if (info != null) {
      _picURL = info['hd_profile_pic_url_info']?['url'];
      _followers = info['follower_count'];
      _isPrivate = info['is_private'];
      _following = info['following_count'];
      print("Profile Pic URL: $_picURL");
      print("Followers: $_followers");
      print("Is Private: $_isPrivate");
      print("Following: $_following");
    }
  }

  void _parseStoryData(Map<String, dynamic> data) {
    final items = data['data']?['items'];
    if (items != null) {
      for (var item in items) {
        final String? time = item['taken_at_date'];
        final bool isVideo = item['is_video'] ?? false;

        if (isVideo) {
          _addMediaItem(item['video_url'], 'video', time);
        } else {
          _addMediaItem(item['thumbnail_url'], 'image', time);
        }
      }
      _itemsCount = items.length;
    }
  }

  void _addMediaItem(String? url, String type, String? time) {
    if (url != null && url.isNotEmpty) {
      final mediaItem = {'type': type, 'url': url, if (time != null) 'time': time};
      if (!_mediaItems.any((item) => item['url'] == url)) {
        _mediaItems.add(mediaItem);
        print("$type added: $url at time: ${time ?? 'No time'}");
      } else {
        print("The $type already exists in the list.");
      }
    }
  }

  String? get picURL => _picURL;
  int? get following => _following;
  int? get followers => _followers;
  int? get itemsCount => _itemsCount;
  bool? get isPrivate => _isPrivate;
  List<Map<String, String>> get mediaItems => _mediaItems;

  String extractTime(String datetime) {
    DateTime parsedDateTime = DateTime.parse(datetime);
    String hour = parsedDateTime.hour.toString().padLeft(2, '0');
    String minute = parsedDateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
