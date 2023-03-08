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

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:files/backend/utils.dart';
import 'package:flutter/material.dart';
import 'package:windows_path_provider/windows_path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart';

class FolderProvider {
  final List<BuiltinFolder> _folders;
  final List<SideDestination> _destinations;

  List<BuiltinFolder> get folders => List.from(_folders);
  List<SideDestination> get destinations => List.from(_destinations);

  static Future<FolderProvider> init() async {
    final List<BuiltinFolder> folders = [];

    if (Platform.isWindows) {
      for (final WindowsFolder folder in WindowsFolder.values) {
        final String? path = await WindowsPathProvider.getPath(folder);

        if (path == null) continue;

        final FolderType? type = folder.toFolderType();
        if (type == null) continue;

        folders.add(BuiltinFolder(type, Directory(path)));
      }
    } else if (Platform.isLinux) {
      final Set<String> dirNames = getUserDirectoryNames();

      final List<String> backDir = getUserDirectory(dirNames.first)!
          .path
          .split(Platform.pathSeparator)
        ..removeLast();
      folders.add(
        BuiltinFolder(
          FolderType.home,
          Directory(backDir.join(Platform.pathSeparator)),
        ),
      );

      for (final String element in dirNames) {
        final FolderType? type = FolderType.fromString(element);
        if (type == null) continue;

        folders.add(
          BuiltinFolder(
            type,
            Directory(getUserDirectory(element)!.path),
          ),
        );
      }
    } else {
      throw Exception("Platform not supported");
    }

    final List<SideDestination> destinations = [
      for (final BuiltinFolder element in folders)
        SideDestination(
          _icons[element.type]!,
          Utils.getEntityName(element.directory.path),
          element.directory.path,
        ),
    ];

    return FolderProvider._(folders, destinations);
  }

  const FolderProvider._(this._folders, this._destinations);

  IconData getIconForType(FolderType type) {
    return _icons[type]!;
  }

  BuiltinFolder? isBuiltinFolder(String path) {
    return _folders.firstWhereOrNull((v) => v.directory.path == path);
  }
}

enum FolderType {
  home,
  desktop,
  documents,
  pictures,
  download,
  videos,
  music,
  publicShare,
  templates;

  static FolderType? fromString(String value) {
    return FolderType.values
        .asNameMap()
        .map((k, v) => MapEntry(k.toUpperCase(), v))[value.toUpperCase()];
  }
}

class BuiltinFolder {
  final FolderType type;
  final Directory directory;

  const BuiltinFolder(this.type, this.directory);
}

class SideDestination {
  final IconData icon;
  final String label;
  final String path;

  const SideDestination(this.icon, this.label, this.path);
}

const Map<FolderType, IconData> _icons = {
  FolderType.home: Icons.home_filled,
  FolderType.desktop: Icons.desktop_windows,
  FolderType.documents: Icons.note_outlined,
  FolderType.pictures: Icons.photo_library_outlined,
  FolderType.download: Icons.file_download,
  FolderType.videos: Icons.videocam_outlined,
  FolderType.music: Icons.music_note_outlined,
  FolderType.publicShare: Icons.public_outlined,
  FolderType.templates: Icons.file_copy_outlined,
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

extension on WindowsFolder {
  FolderType? toFolderType() {
    switch (this) {
      case WindowsFolder.profile:
        return FolderType.home;
      case WindowsFolder.public:
        return FolderType.publicShare;
      default:
        return FolderType.fromString(name);
    }
  }
}
