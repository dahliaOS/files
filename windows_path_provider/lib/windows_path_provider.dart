import 'dart:async';

import 'package:flutter/services.dart';

class WindowsPathProvider {
  static const MethodChannel _channel = MethodChannel('windows_path_provider');

  static Future<String?> getPath(WindowsFolder folder) async {
    final String? path = await _channel.invokeMethod('getPath', {
      'path_index': folder.index,
    });

    return path;
  }
}

enum WindowsFolder {
  profile,
  desktop,
  documents,
  pictures,
  downloads,
  music,
  videos,
  public,
  templates,
}
