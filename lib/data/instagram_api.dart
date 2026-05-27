import 'dart:convert';

import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/features/profile/domain/profile_overview.dart';
import 'package:anastagram/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class InstagramApi {
  InstagramApi({http.Client? client}) : _client = client ?? http.Client();

  static const _apiHost = 'mediafy-api.p.rapidapi.com';
  static const _defaultApiKey =
      'bd70071364msh50b9d05e841d400p14042cjsn761745e97e06';
  static const _defaultHighlightApiKey =
      'c05c767a00msh453fb621e171c94p1e536ajsn972c2f9806b5';

  final http.Client _client;

  String get _apiKey => const String.fromEnvironment(
    'RAPIDAPI_KEY',
    defaultValue: _defaultApiKey,
  );

  String get _highlightApiKey => const String.fromEnvironment(
    'RAPIDAPI_HIGHLIGHT_KEY',
    defaultValue: _defaultHighlightApiKey,
  );

  Future<ProfileOverview> fetchProfile(String username) async {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      throw Exception('Profilname darf nicht leer sein.');
    }

    try {
      final responses = await Future.wait([
        _get(
          'https://$_apiHost/v1/info?username_or_id_or_url=$normalized',
          apiKey: _apiKey,
        ),
        _get(
          'https://$_apiHost/v1/stories?username_or_id_or_url=$normalized',
          apiKey: _apiKey,
        ),
        _get(
          'https://$_apiHost/v1/highlights?username_or_id_or_url=$normalized',
          apiKey: _apiKey,
        ),
      ]);

      final infoJson = _decodeResponse(responses[0]);
      final storiesJson = _decodeResponse(responses[1]);
      final highlightsJson = _decodeResponse(responses[2]);

      final info = infoJson['data'] as Map<String, dynamic>?;
      if (info == null || info.isEmpty) {
        throw Exception('Profil "$normalized" wurde nicht gefunden.');
      }

      return ProfileOverview(
        username: normalized,
        profileImageUrl:
            (info['hd_profile_pic_url_info']?['url'] ?? info['profile_pic_url'])
                ?.toString(),
        followers: _toInt(info['follower_count']),
        following: _toInt(info['following_count']),
        isPrivate: info['is_private'] == true,
        stories: _parseMediaItems(storiesJson['data']?['items']),
        highlights: _parseHighlights(highlightsJson['data']?['items']),
      );
    } catch (error, stackTrace) {
      AppLogger.e('Fehler beim Abrufen des Profils', error, stackTrace);
      if (error is Exception) {
        rethrow;
      }
      throw Exception('Profil konnte nicht geladen werden.');
    }
  }

  Future<List<MediaItem>> fetchHighlightItems(String highlightId) async {
    try {
      final response = await _get(
        'https://$_apiHost/v1/highlight_info?highlight_id=$highlightId',
        apiKey: _highlightApiKey,
      );
      final data = _decodeResponse(response);
      return _parseMediaItems(data['data']?['items']);
    } catch (error, stackTrace) {
      AppLogger.e('Fehler beim Abrufen eines Highlights', error, stackTrace);
      throw Exception('Highlight konnte nicht geladen werden.');
    }
  }

  Future<http.Response> _get(String url, {required String apiKey}) async {
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': _apiHost,
      },
    );

    if (response.statusCode >= 400) {
      throw Exception('API-Fehler (${response.statusCode}).');
    }

    return response;
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = json.decode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Ungültige API-Antwort.');
    }
    return decoded;
  }

  List<MediaItem> _parseMediaItems(dynamic rawItems) {
    if (rawItems is! List) {
      return const [];
    }

    final items = <MediaItem>[];
    final seenUrls = <String>{};

    for (final rawItem in rawItems) {
      if (rawItem is! Map<String, dynamic>) {
        continue;
      }

      final isVideo = rawItem['is_video'] == true;
      final mediaUrl =
          (isVideo ? rawItem['video_url'] : rawItem['thumbnail_url'])
              ?.toString();

      if (mediaUrl == null || mediaUrl.isEmpty || seenUrls.contains(mediaUrl)) {
        continue;
      }

      seenUrls.add(mediaUrl);
      items.add(
        MediaItem(
          type: isVideo ? MediaType.video : MediaType.image,
          url: mediaUrl,
          takenAt: _parseDate(rawItem['taken_at_date'] ?? rawItem['taken_at']),
        ),
      );
    }

    return items;
  }

  List<HighlightStory> _parseHighlights(dynamic rawItems) {
    if (rawItems is! List) {
      return const [];
    }

    return rawItems
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final id = item['id']?.toString().replaceFirst('highlight:', '') ?? '';
          final avatarUrl =
              item['cover_media']?['cropped_image_version']?['url']?.toString() ??
              '';

          if (id.isEmpty || avatarUrl.isEmpty) {
            return null;
          }

          return HighlightStory(
            title: item['title']?.toString().trim().isNotEmpty == true
                ? item['title'].toString().trim()
                : 'Highlight',
            avatarUrl: avatarUrl,
            id: id,
          );
        })
        .whereType<HighlightStory>()
        .toList(growable: false);
  }

  DateTime? _parseDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value)?.toLocal();
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(
        value * 1000,
        isUtc: true,
      ).toLocal();
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        value.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    }

    return null;
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
