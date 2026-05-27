import 'package:anastagram/core/services/media_download_service.dart';
import 'package:anastagram/data/instagram_api.dart';
import 'package:anastagram/data/userdata.dart';
import 'package:anastagram/features/profile/data/saved_profiles_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final instagramApiProvider = Provider<InstagramApi>((ref) {
  return InstagramApi(client: ref.watch(httpClientProvider));
});

final savedProfilesRepositoryProvider = Provider<SavedProfilesRepository>((ref) {
  return SavedProfilesRepository(Hive.box<UserData>('userData'));
});

final dioProvider = Provider<Dio>((ref) => Dio());

final mediaDownloadServiceProvider = Provider<MediaDownloadService>((ref) {
  return MediaDownloadService(ref.watch(dioProvider));
});

