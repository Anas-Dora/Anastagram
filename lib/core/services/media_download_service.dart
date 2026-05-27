import 'dart:typed_data';

import 'package:anastagram/core/models/action_feedback.dart';
import 'package:anastagram/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaDownloadService {
  MediaDownloadService(this._dio);

  final Dio _dio;

  Future<ActionFeedback> saveImageFromUrl(String imageUrl) async {
    final granted = await _ensurePermission();
    if (!granted) {
      return const ActionFeedback(
        'Speicherberechtigung verweigert.',
        isError: true,
      );
    }

    try {
      final response = await _dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data ?? const []);
      if (bytes.isEmpty) {
        return const ActionFeedback(
          'Bilddaten waren leer.',
          isError: true,
        );
      }

      await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: 'anastagram_profile_${DateTime.now().millisecondsSinceEpoch}',
      );

      return const ActionFeedback('Bild gespeichert.');
    } catch (error, stackTrace) {
      AppLogger.e(
        'Fehler beim Herunterladen des Bildes',
        error,
        stackTrace,
      );

      final message = _getErrorMessage(error);
      return ActionFeedback(
        'Bild konnte nicht gespeichert werden: $message',
        isError: true,
      );
    }
  }

  Future<bool> _ensurePermission() async {
    final photosStatus = await Permission.photos.request();
    if (photosStatus.isGranted || photosStatus.isLimited) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }
}

  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return 'Verbindungs-Timeout.';
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return 'Download-Timeout.';
      } else if (error.type == DioExceptionType.unknown) {
        return 'Netzwerkfehler.';
      }
      return 'HTTP-Fehler ${error.response?.statusCode}.';
    }
    return error.toString();
  }

