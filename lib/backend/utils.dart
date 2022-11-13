import 'dart:io';

import 'package:files/backend/path_parts.dart';
import 'package:files/backend/providers.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mime/mime.dart';

class Utils {
  Utils._();

  static Map<String, IconData> get iconsPerMime => {
        "application/java-archive": MdiIcons.languageJava,
        "application/json": MdiIcons.codeBraces,
        "application/msword": MdiIcons.fileWordOutline,
        "application/octet-stream": MdiIcons.fileDocumentOutline,
        "application/pdf": MdiIcons.fileDocumentOutline,
        "application/vnd.microsoft.portable-executable":
            MdiIcons.microsoftWindows,
        "application/vnd.ms-excel": MdiIcons.fileExcelOutline,
        "application/vnd.ms-powerpoint": MdiIcons.filePowerpointOutline,
        "application/vnd.openxmlformats-officedocument.presentationml.presentation":
            MdiIcons.filePowerpointOutline,
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
            MdiIcons.fileExcelOutline,
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
            MdiIcons.fileWordOutline,
        "application/vnd.rar": MdiIcons.zipBoxOutline,
        "application/x-7z-compressed": MdiIcons.zipBoxOutline,
        "application/x-iso9660-image": MdiIcons.disc,
        "application/x-msdownload": MdiIcons.microsoftWindows,
        "application/x-rar-compressed": MdiIcons.zipBoxOutline,
        "application/x-sql": MdiIcons.databaseOutline,
        "application/zip": MdiIcons.zipBoxOutline,
        "audio/mpeg": MdiIcons.fileMusicOutline,
        "audio/ogg": MdiIcons.fileMusicOutline,
        "image/gif": Icons.animation,
        "image/jpeg": MdiIcons.fileImageOutline,
        "image/png": MdiIcons.fileImageOutline,
        "image/svg+xml": MdiIcons.svg,
        "text/css": MdiIcons.fileCodeOutline,
        "text/csv": MdiIcons.fileDocumentOutline,
        "text/javascript": MdiIcons.languageJavascript,
        "text/html": MdiIcons.languageHtml5,
        "text/plain": MdiIcons.fileDocumentOutline,
        "video/mp4": MdiIcons.fileVideoOutline,
        "video/ogg": MdiIcons.fileVideoOutline,
      };

  static IconData iconForPath(String path) {
    final String? mime = lookupMimeType(path);

    if (mime != null) {
      return iconsPerMime[mime] ?? Icons.insert_drive_file_outlined;
    }

    return Icons.insert_drive_file_outlined;
  }

  static IconData iconForFolder(String path) {
    final IconData? builtinFolderIcon = folderProvider.directories[path];

    return builtinFolderIcon ?? Icons.folder;
  }

  static String getEntityName(String path) {
    final PathParts pathParts = PathParts.parse(path);
    return pathParts.parts.isNotEmpty ? pathParts.parts.last : pathParts.root;
  }

  static void moveFileToDest(FileSystemEntity origin, String dest) {
    final originParts = PathParts.parse(origin.path);
    final directoryParts = PathParts.parse(dest);
    final destinationParts = PathParts(
      originParts.root,
      directoryParts.parts..add(originParts.parts.last),
      originParts.separator,
    );
    origin.rename(destinationParts.toPath());
  }
}
