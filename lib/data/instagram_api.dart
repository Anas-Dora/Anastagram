import 'dart:convert';

import 'package:anastagram/core/config/config.dart';
import 'package:anastagram/core/exceptions/app_exceptions.dart';
import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/features/profile/domain/profile_overview.dart';
import 'package:anastagram/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class InstagramApi {
  InstagramApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  String get _apiKey => Config.instagramApiKey;
  String get _highlightApiKey => Config.instagramHighlightApiKey;

  Future<ProfileOverview> fetchProfile(String username) async {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      throw ValidationException('Profilname ist erforderlich.');
    }

    try {
      // Schritt 1: Profil-Info abrufen
      final infoResponse = await _get(
        'https://${Config.apiHost}/v1/info?username_or_id_or_url=$normalized',
        apiKey: _apiKey,
        host: Config.apiHost,
      );

      final infoJson = _decodeResponse(infoResponse);
      final info = infoJson['data'] as Map<String, dynamic>?;

      if (info == null || info.isEmpty) {
        throw NotFoundException('Profil "$normalized" wurde nicht gefunden.');
      }

      final isPrivate = info['is_private'] == true;

      // Schritt 2: Nur bei öffentlichen Profilen Stories/Highlights laden
      List<MediaItem> stories = [];
      List<HighlightStory> highlights = [];

      if (!isPrivate) {
        try {
          final storiesResponse = await _get(
            'https://${Config.apiHost}/v1/stories?username_or_id_or_url=$normalized',
            apiKey: _apiKey,
            host: Config.apiHost,
          );
          final storiesJson = _decodeResponse(storiesResponse);
          stories = _parseMediaItems(storiesJson['data']?['items']);
        } catch (e) {
          AppLogger.w('Konnte Stories nicht laden (ignoriert): $e');
          // Fehler bei Stories ignorieren, nicht kritisch
        }

        try {
          final highlightsResponse = await _get(
            'https://${Config.apiHost}/v1/highlights?username_or_id_or_url=$normalized',
            apiKey: _apiKey,
            host: Config.apiHost,
          );
          final highlightsJson = _decodeResponse(highlightsResponse);
          highlights = _parseHighlights(highlightsJson['data']?['items']);
        } catch (e) {
          AppLogger.w('Konnte Highlights nicht laden (ignoriert): $e');
          // Fehler bei Highlights ignorieren, nicht kritisch
        }
      }

      return ProfileOverview(
        username: normalized,
        profileImageUrl:
            (info['hd_profile_pic_url_info']?['url'] ?? info['profile_pic_url'])
                ?.toString(),
        followers: _toInt(info['follower_count']),
        following: _toInt(info['following_count']),
        isPrivate: isPrivate,
        stories: stories,
        highlights: highlights,
      );
    } catch (error, stackTrace) {
      AppLogger.e('Fehler beim Abrufen des Profils', error, stackTrace);
      if (error is AppException) {
        rethrow;
      }
      throw NetworkException('Profil konnte nicht geladen werden.');
    }
  }

  Future<List<MediaItem>> fetchHighlightItems(String highlightId) async {
    try {
      final response = await _get(
        'https://${Config.instagramHighlightApiHost}/v1/highlight_info?highlight_id=$highlightId',
        apiKey: _highlightApiKey,
        host: Config.instagramHighlightApiHost,
      );
      final data = _decodeResponse(response);
      return _parseMediaItems(data['data']?['items']);
    } catch (error, stackTrace) {
      AppLogger.e('Fehler beim Abrufen eines Highlights', error, stackTrace);
      rethrow;
    }
  }

  Future<http.Response> _get(
    String url, {
    required String apiKey,
    required String host,
  }) async {
    try {
      var response = await _client
          .get(
            Uri.parse(url),
            headers: {
              'x-rapidapi-key': apiKey,
              'x-rapidapi-host': host,
            },
          )
          .timeout(Config.apiTimeout);

      // Bei Rate-Limit mit dem Primär-Key einmalig auf den Fallback-Key wechseln.
      if (response.statusCode == 429 && apiKey == _apiKey) {
        AppLogger.w('429 mit Primär-Key auf $host, versuche Fallback-Key.');
        response = await _client
            .get(
              Uri.parse(url),
              headers: {
                'x-rapidapi-key': _highlightApiKey,
                'x-rapidapi-host': host,
              },
            )
            .timeout(Config.apiTimeout);
      }

      if (response.statusCode >= 400) {
        throw NetworkException('API-Fehler ${response.statusCode}.');
      }

      return response;
    } on http.ClientException catch (e) {
      throw NetworkException('Verbindungsfehler: $e');
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw ParseException('Ungültige Antwortstruktur.');
      }
      return decoded;
    } catch (e) {
      throw ParseException('Konnte API-Antwort nicht dekodieren: $e');
    }
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
