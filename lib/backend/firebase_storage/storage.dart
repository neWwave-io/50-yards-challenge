import 'dart:typed_data';

import 'package:mime_type/mime_type.dart';

import 'package:supabase_flutter/supabase_flutter.dart' show FileOptions;
import '/core/supabase/supabase_config.dart';

/// Uploads to Supabase Storage. Keeps the v1 signature — `uploadData` is
/// called 129 times across the screens.
///
/// v1 paths looked like `users/{uid}/uploads/file.jpg`. The first segment is
/// mapped to a bucket; anything unrecognized goes to `lawn-photos`.
Future<String?> uploadData(String path, Uint8List data) async {
  try {
    final bucket = _bucketFor(path);
    final objectPath = _objectPath(path);
    await supabase.storage.from(bucket).uploadBinary(
          objectPath,
          data,
          fileOptions: FileOptions(
            contentType: mime(path) ?? 'application/octet-stream',
            upsert: true,
          ),
        );
    return supabase.storage.from(bucket).getPublicUrl(objectPath);
  } catch (e) {
    // ignore: avoid_print
    print('Upload failed for $path: $e');
    return null;
  }
}

String _bucketFor(String path) {
  if (path.contains('/avatar') || path.contains('profile')) return 'avatars';
  if (path.contains('announcement') || path.contains('news')) {
    return 'announcements';
  }
  return 'lawn-photos';
}

String _objectPath(String path) {
  final cleaned = path.startsWith('/') ? path.substring(1) : path;
  return cleaned.isEmpty ? 'file' : cleaned;
}
