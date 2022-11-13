import 'dart:io';

import 'package:files/backend/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

export 'package:isar/isar.dart';

part 'model.g.dart';

@Collection()
class EntityStat with ChangeNotifier {
  Id? id;

  @Index(unique: true, type: IndexType.hash)
  late String path;

  late DateTime changed;
  late DateTime modified;
  late DateTime accessed;

  @enumerated
  late EntityType type;
  late int mode;
  late int size;

  EntityStat();

  EntityStat.fastInit({
    required this.path,
    required this.changed,
    required this.modified,
    required this.accessed,
    required this.type,
    required this.mode,
    required this.size,
  });

  EntityStat.fromStat(String path, FileStat stat)
      : this.fastInit(
          path: path,
          changed: stat.changed,
          modified: stat.modified,
          accessed: stat.accessed,
          type: EntityType.fromDartIo(stat.type),
          mode: stat.mode,
          size: stat.size,
        );

  Future<void> fetchUpdate() async {
    final FileStat ioStat = await FileStat.stat(path);

    if (!_statIdentical(ioStat)) {
      changed = ioStat.changed;
      modified = ioStat.modified;
      accessed = ioStat.accessed;
      type = EntityType.fromDartIo(ioStat.type);
      mode = ioStat.mode;
      size = ioStat.size;
      await helper.set(this);
      notifyListeners();
    }
  }

  bool _statIdentical(FileStat other) {
    return changed == other.changed &&
        modified == other.modified &&
        accessed == other.accessed &&
        type == EntityType.fromDartIo(other.type) &&
        mode == other.mode &&
        size == other.size;
  }
}

enum EntityType {
  file,
  directory,
  link,
  notFound;

  static EntityType fromDartIo(FileSystemEntityType type) {
    switch (type) {
      case FileSystemEntityType.file:
        return EntityType.file;
      case FileSystemEntityType.directory:
        return EntityType.directory;
      case FileSystemEntityType.link:
        return EntityType.link;
      case FileSystemEntityType.notFound:
      default:
        return EntityType.notFound;
    }
  }

  FileSystemEntityType get toDartIo {
    switch (this) {
      case EntityType.file:
        return FileSystemEntityType.file;
      case EntityType.directory:
        return FileSystemEntityType.directory;
      case EntityType.link:
        return FileSystemEntityType.link;
      case EntityType.notFound:
        return FileSystemEntityType.notFound;
    }
  }
}
