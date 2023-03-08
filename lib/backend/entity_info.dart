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

import 'package:files/backend/database/model.dart';

class EntityInfo {
  final FileSystemEntity _entity;
  final EntityStat stat;
  final EntityType entityType;

  const EntityInfo._(this._entity, this.stat, this.entityType);

  String get path => _entity.path;

  FileSystemEntity get entity => _entity;

  bool _equals(EntityInfo other) {
    return entity.path == other.entity.path &&
        stat.accessed == other.stat.accessed &&
        stat.changed == other.stat.changed &&
        stat.mode == other.stat.mode &&
        stat.modified == other.stat.modified &&
        stat.size == other.stat.size &&
        stat.type == other.stat.type &&
        entityType == other.entityType;
  }

  @override
  bool operator ==(Object? other) {
    if (other is EntityInfo) {
      return _equals(other);
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
        entity.path,
        stat.accessed,
        stat.changed,
        stat.mode,
        stat.modified,
        stat.size,
        stat.type,
        entityType,
      );
}

class FileEntityInfo extends EntityInfo {
  const FileEntityInfo({
    required File entity,
    required EntityStat stat,
  }) : super._(entity, stat, EntityType.file);

  @override
  File get entity => _entity as File;
}

class DirectoryEntityInfo extends EntityInfo {
  const DirectoryEntityInfo({
    required Directory entity,
    required EntityStat stat,
  }) : super._(entity, stat, EntityType.directory);

  @override
  Directory get entity => _entity as Directory;
}

enum EntityType {
  file,
  directory,
}

extension EntityInfoHelpers on EntityInfo {
  FileEntityInfo get asFile => this as FileEntityInfo;
  DirectoryEntityInfo get asDirectory => this as DirectoryEntityInfo;

  bool get isFile => this is FileEntityInfo;
  bool get isDirectory => this is DirectoryEntityInfo;
}

extension EntityInfoListHelpers on List<EntityInfo> {
  List<FileEntityInfo> get files => whereType<FileEntityInfo>().toList();
  List<DirectoryEntityInfo> get directories =>
      whereType<DirectoryEntityInfo>().toList();
}

/* class EntityStat implements Insertable<EntityStat> {
  final String path;
  final DateTime changed;
  final DateTime modified;
  final DateTime accessed;
  final FileSystemEntityType type;
  final int mode;
  final int size;

  const EntityStat({
    required this.path,
    required this.changed,
    required this.modified,
    required this.accessed,
    required this.type,
    required this.mode,
    required this.size,
  });

  EntityStat.fromStat(String path, FileStat stat)
      : this(
          path: path,
          changed: stat.changed,
          modified: stat.modified,
          accessed: stat.accessed,
          type: stat.type,
          mode: stat.mode,
          size: stat.size,
        );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return FileStatCachesCompanion(
      path: Value(path),
      changed: Value(changed),
      modified: Value(modified),
      accessed: Value(accessed),
      type: Value(type),
      mode: Value(mode),
      size: Value(size),
    ).toColumns(nullToAbsent);
  }
} */
