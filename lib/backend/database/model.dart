import 'dart:io';

import 'package:files/backend/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

export 'package:isar/isar.dart';

part 'model.g.dart';

@Collection()
class EntityStat with ChangeNotifier {
  @Id()
  int? id;

  @Index(unique: true, type: IndexType.hash)
  late String path;

  late DateTime changed;
  late DateTime modified;
  late DateTime accessed;

  @FileSystemEntityTypeConverter()
  late FileSystemEntityType type;
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
          type: stat.type,
          mode: stat.mode,
          size: stat.size,
        );

  Future<void> fetchUpdate() async {
    final FileStat ioStat = await FileStat.stat(path);

    if (!_statIdentical(ioStat)) {
      changed = ioStat.changed;
      modified = ioStat.modified;
      accessed = ioStat.accessed;
      type = ioStat.type;
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
        type == other.type &&
        mode == other.mode &&
        size == other.size;
  }
}

class FileSystemEntityTypeConverter
    extends TypeConverter<FileSystemEntityType, int> {
  const FileSystemEntityTypeConverter();

  @override
  FileSystemEntityType fromIsar(int object) {
    switch (object) {
      case 0:
        return FileSystemEntityType.file;
      case 1:
        return FileSystemEntityType.directory;
      case 2:
        return FileSystemEntityType.link;
      case 3:
      default:
        return FileSystemEntityType.notFound;
    }
  }

  @override
  int toIsar(FileSystemEntityType object) {
    switch (object) {
      case FileSystemEntityType.file:
        return 0;
      case FileSystemEntityType.directory:
        return 1;
      case FileSystemEntityType.link:
        return 2;
      case FileSystemEntityType.notFound:
      default:
        return 3;
    }
  }
}
