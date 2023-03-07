import 'dart:async';
import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/providers.dart';
import 'package:files/backend/utils.dart';
import 'package:flutter/foundation.dart';

enum SortType {
  name,
  modified,
  type,
  size,
}

class CancelableFsFetch {
  final Directory directory;
  final ValueChanged<List<EntityInfo>?> onFetched;
  final VoidCallback? onCancel;
  final ValueChanged<double?>? onProgressChange;
  final ValueChanged<OSError?>? onFileSystemException;
  final bool ascending;
  final SortType sortType;
  final bool showHidden;

  CancelableFsFetch({
    required this.directory,
    required this.onFetched,
    this.onCancel,
    this.onProgressChange,
    this.onFileSystemException,
    this.ascending = false,
    this.sortType = SortType.name,
    this.showHidden = false,
  });

  bool _running = false;
  Completer<void> cancelableCompleter = Completer<void>();
  bool _cancelled = false;
  bool get cancelled => _cancelled;

  Future<void> startFetch() async {
    if (_cancelled) throw CancelledException();

    onProgressChange?.call(0.0);
    late final List<FileSystemEntity> list;
    try {
      list = await directory
          .list()
          .where(
            (element) =>
                !Utils.getEntityName(element.path).startsWith(".") ||
                showHidden,
          )
          .toList();
    } on FileSystemException catch (e) {
      onFileSystemException?.call(e.osError);
      _cancelled = true;
      return;
    }
    final List<EntityInfo> directories = [];
    final List<EntityInfo> files = [];

    _running = true;
    for (int i = 0; i < list.length; i++) {
      if (_cancelled) {
        onCancel?.call();
        cancelableCompleter.complete();
        return;
      }

      late final EntityInfo info;

      if (list[i] is Directory) {
        info = DirectoryEntityInfo(
          entity: list[i] as Directory,
          stat: await cacheProxy.get(list[i].path),
        );
        directories.add(info);
      } else if (list[i] is File) {
        info = FileEntityInfo(
          entity: list[i] as File,
          stat: await cacheProxy.get(list[i].path),
        );
        files.add(info);
      } else if (list[i] is Link) {
        (list[i] as Link).path;
      }

      onProgressChange?.call((i + 1) / list.length);
    }
    _running = false;

    directories.sort((a, b) => _sort(a, b, isDirectory: true)!);
    files.sort((a, b) => _sort(a, b)!);

    onProgressChange?.call(null);

    if (!_cancelled) onFetched.call([...directories, ...files]);
  }

  int? _sort(
    EntityInfo a,
    EntityInfo b, {
    bool isDirectory = false,
  }) {
    EntityInfo item1 = a;
    EntityInfo item2 = b;

    if (!ascending) {
      item2 = a;
      item1 = b;
    }

    switch (sortType.index) {
      case 0:
        return Utils.getEntityName(item1.path.toLowerCase())
            .compareTo(Utils.getEntityName(item2.path.toLowerCase()));
      case 1:
        return item1.stat.modified.compareTo(item2.stat.modified);
      case 2:
        return 0;
      case 3:
        if (isDirectory) {
          return 0;
        } else {
          return item1.stat.size.compareTo(item2.stat.size);
        }
    }

    return null;
  }

  Future<void> cancel() async {
    if (!_running) return;
    _cancelled = true;
    await cancelableCompleter.future;
  }
}

class CancelledException implements Exception {
  @override
  String toString() {
    return "CancelledException: The fetch was cancelled and can't be restored, please create a new instance for fetching.";
  }
}
