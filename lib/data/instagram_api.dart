import 'dart:convert';
import 'package:anastagram/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class InstagramApi {
  String? _picURL;
  int? _followers;
  int? _following;
  int? _itemsCount;
  bool? _isPrivate;
  final List<String> _highlightsTitel = [];
  final List<String> _highlightsAvatarUrl = [];
  final List<String> _highlightsId = [];
  final List<Map<String, String>> _storieItems = [];

  Future<void> getApi(String userName) async {
    final infoUrl = Uri.parse(
      'https://mediafy-api.p.rapidapi.com/v1/info?username_or_id_or_url=$userName',
    );
    final storyUrl = Uri.parse(
      'https://mediafy-api.p.rapidapi.com/v1/stories?username_or_id_or_url=$userName',
    );

    final highlightsUrl = Uri.parse(
      'https://mediafy-api.p.rapidapi.com/v1/highlights?username_or_id_or_url=$userName',
    );

    final headers = {
      'x-rapidapi-key': 'bd70071364msh50b9d05e841d400p14042cjsn761745e97e06',
      'x-rapidapi-host': 'mediafy-api.p.rapidapi.com',
    };

    try {
      final infoResponse = await http.get(infoUrl, headers: headers);
      final storyResponse = await http.get(storyUrl, headers: headers);
      final highlightsResponse = await http.get(
        highlightsUrl,
        headers: headers,
      );

      if (infoResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponseInfo = json.decode(
          infoResponse.body,
        );
        _parseInfoData(jsonResponseInfo);
      }

      if (storyResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponseStory = json.decode(
          storyResponse.body,
        );
        _parseStoryData(jsonResponseStory);
      }

      if (highlightsResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponseHighlights = json.decode(
          highlightsResponse.body,
        );
        _parseHighlightsId(jsonResponseHighlights);
        _parseHighlightsTitel(jsonResponseHighlights);
        _parseHighlightsAvatarUrl(jsonResponseHighlights);
      }
    } catch (e) {
      AppLogger.e("Error fetching data: ", e);
    }
  }

  void _parseInfoData(Map<String, dynamic> data) {
    _picURL = "";
    _followers = 0;
    _isPrivate = false;
    _following = 0;
    final info = data['data'];
    if (info != null) {
      _picURL = info['hd_profile_pic_url_info']?['url'];
      _followers = info['follower_count'];
      _isPrivate = info['is_private'];
      _following = info['following_count'];
    }
  }

  void _parseStoryData(Map<String, dynamic> data) {
    _storieItems.clear();
    _itemsCount = 0;
    final items = data['data']?['items'];
    if (items != null) {
      for (var item in items) {
        final String? time = item['taken_at_date'];
        final bool isVideo = item['is_video'] ?? false;

        if (isVideo) {
          _addStoriesItem(item['video_url'], 'video', time);
        } else {
          _addStoriesItem(item['thumbnail_url'], 'image', time);
        }
      }
      _itemsCount = items.length;
    }
  }

  void _parseHighlightsId(Map<String, dynamic> data) {
    _highlightsId.clear();
    final items = data['data']?['items'];
    if (items != null && items is List) {
      for (var highlight in items) {
        final id = highlight['id'];
        if (id != null) {
          final cleanId = id.toString().replaceFirst('highlight:', '');
          _highlightsId.add(cleanId);
        }
      }
    }
  }

  void _parseHighlightsTitel(Map<String, dynamic> data) {
    _highlightsTitel.clear();
    final items = data['data']?['items'];
    if (items != null && items is List) {
      for (var highlight in items) {
        final title = highlight['title'];
        _highlightsTitel.add(title);
      }
    }
  }

  void _parseHighlightsAvatarUrl(Map<String, dynamic> data) {
    _highlightsAvatarUrl.clear();
    final items = data['data']?['items'];
    if (items == null) return;

    for (var highlight in items) {
      final avatarUrl =
          highlight['cover_media']?['cropped_image_version']?['url'];

      if (avatarUrl != null && avatarUrl is String && avatarUrl.isNotEmpty) {
        _highlightsAvatarUrl.add(avatarUrl);
      }
    }
  }

  Future<List<Map<String, String>>> fetchHighlightItems(
    String highlightId,
  ) async {
    List<Map<String, String>> highlightItems = [];
    final headers = {
      'x-rapidapi-key': 'c05c767a00msh453fb621e171c94p1e536ajsn972c2f9806b5',
      'x-rapidapi-host': 'mediafy-api.p.rapidapi.com',
    };
    final url = Uri.parse(
      "https://mediafy-api.p.rapidapi.com/v1/highlight_info?highlight_id=$highlightId",
    );

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      final items = data['data']?['items'];

      if (items != null && items.isNotEmpty) {
        for (var item in items) {
          final String? time = item['taken_at_date'];
          final bool isVideo = item['is_video'] ?? false;

          final String? mediaUrl = isVideo
              ? item['video_url']
              : item['thumbnail_url'];
          highlightItems.add({
            'type': isVideo ? 'video' : 'image',
            'url': ?mediaUrl,
            if (time != null) 'time': time,
          });
        }
      }
    } else {
      AppLogger.e(
        "Fehler beim Abrufen von Highlight $highlightId: ${response.statusCode}",
      );
    }
    return highlightItems;
  }

  void _addStoriesItem(String? url, String type, String? time) {
    if (url != null && url.isNotEmpty) {
      final mediaItem = {
        'type': type,
        'url': url,
        if (time != null) 'time': time,
      };
      if (!_storieItems.any((item) => item['url'] == url)) {
        _storieItems.add(mediaItem);
      }
    }
  }

  String? get picURL => _picURL;
  int? get following => _following;
  int? get followers => _followers;
  int? get itemsCount => _itemsCount;
  bool? get isPrivate => _isPrivate;
  List<Map<String, String>> get storieItems => _storieItems;
  List<String> get highlightsTitel => _highlightsTitel;
  List<String> get highlightsAvatarUrl => _highlightsAvatarUrl;
  List<String> get highlightsId => _highlightsId;
}
