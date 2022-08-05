/*
Copyright 2019 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

//credits: @HrX03 for API https://github.com/HrX03/Flux

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_path_provider/windows_path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart';

class FolderProvider {
  final List<MapEntry<String, IconData>> directories;

  static Future<FolderProvider> init() async {
    final List<MapEntry<String, IconData>> directories = [];

    if (Platform.isWindows) {
      for (final WindowsFolder folder in WindowsFolder.values) {
        final String? path = await WindowsPathProvider.getPath(folder);

        if (path != null) {
          directories.add(
            MapEntry(
              path,
              icons[windowsFolderToString(folder)]!,
            ),
          );
        }
      }
    } else if (Platform.isLinux) {
      final dirNames = getUserDirectoryNames();
      for (final String element in dirNames) {
        directories.add(
          MapEntry(
            getUserDirectory(element)!.path,
            icons[element]!,
          ),
        );
      }

      final List<String> backDir =
          directories.first.key.split(Platform.pathSeparator)..removeLast();
      directories.insert(
        0,
        MapEntry(
          backDir.join(Platform.pathSeparator),
          icons["HOME"]!,
        ),
      );
    } else {
      throw Exception("Platform not supported");
    }

    return FolderProvider(directories);
  }

  const FolderProvider(this.directories);
}

const Map<String, IconData> icons = {
  "HOME": Icons.home_filled,
  "DESKTOP": Icons.desktop_windows,
  "DOCUMENTS": Icons.note_outlined,
  "PICTURES": Icons.photo_library_outlined,
  "DOWNLOAD": Icons.file_download,
  "VIDEOS": Icons.videocam_outlined,
  "MUSIC": Icons.music_note_outlined,
  "PUBLICSHARE": Icons.public_outlined,
  "TEMPLATES": Icons.file_copy_outlined,
};

String windowsFolderToString(WindowsFolder folder) {
  switch (folder) {
    case WindowsFolder.profile:
      return "HOME";
    case WindowsFolder.desktop:
      return "DESKTOP";
    case WindowsFolder.documents:
      return "DOCUMENTS";
    case WindowsFolder.pictures:
      return "PICTURES";
    case WindowsFolder.downloads:
      return "DOWNLOAD";
    case WindowsFolder.videos:
      return "VIDEOS";
    case WindowsFolder.music:
      return "MUSIC";
    case WindowsFolder.public:
      return "PUBLICSHARE";
    case WindowsFolder.templates:
      return "TEMPLATES";
  }
}
