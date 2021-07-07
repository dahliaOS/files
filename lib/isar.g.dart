// ignore_for_file: unused_import, implementation_imports

import 'dart:ffi';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:isar/src/isar_native.dart';
import 'package:isar/src/query_builder.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'backend/database/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:files/backend/database/model.dart';

const _utf8Encoder = Utf8Encoder();

final _schema =
    '[{"name":"EntityStat","idProperty":"id","properties":[{"name":"id","type":3},{"name":"path","type":5},{"name":"changed","type":3},{"name":"modified","type":3},{"name":"accessed","type":3},{"name":"type","type":3},{"name":"mode","type":3},{"name":"size","type":3}],"indexes":[{"unique":true,"replace":false,"properties":[{"name":"path","indexType":1,"caseSensitive":true}]}],"links":[]}]';

Future<Isar> openIsar(
    {String name = 'isar',
    String? directory,
    int maxSize = 1000000000,
    Uint8List? encryptionKey}) async {
  final path = await _preparePath(directory);
  return openIsarInternal(
      name: name,
      directory: path,
      maxSize: maxSize,
      encryptionKey: encryptionKey,
      schema: _schema,
      getCollections: (isar) {
        final collectionPtrPtr = malloc<Pointer>();
        final propertyOffsetsPtr = malloc<Uint32>(8);
        final propertyOffsets = propertyOffsetsPtr.asTypedList(8);
        final collections = <String, IsarCollection>{};
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 0));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['EntityStat'] = IsarCollectionImpl<EntityStat>(
          isar: isar,
          adapter: _EntityStatAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 8),
          propertyIds: {
            'id': 0,
            'path': 1,
            'changed': 2,
            'modified': 3,
            'accessed': 4,
            'type': 5,
            'mode': 6,
            'size': 7
          },
          indexIds: {'path': 0},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        malloc.free(propertyOffsetsPtr);
        malloc.free(collectionPtrPtr);

        return collections;
      });
}

Future<String> _preparePath(String? path) async {
  if (path == null || p.isRelative(path)) {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, path ?? 'isar');
  } else {
    return path;
  }
}

class _EntityStatAdapter extends TypeAdapter<EntityStat> {
  static const _FileSystemEntityTypeConverter = FileSystemEntityTypeConverter();

  @override
  int serialize(IsarCollectionImpl<EntityStat> collection, RawObject rawObj,
      EntityStat object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = object.path;
    final _path = _utf8Encoder.convert(value1);
    dynamicSize += _path.length;
    final value2 = object.changed;
    final _changed = value2;
    final value3 = object.modified;
    final _modified = value3;
    final value4 = object.accessed;
    final _accessed = value4;
    final value5 =
        _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(object.type);
    final _type = value5;
    final value6 = object.mode;
    final _mode = value6;
    final value7 = object.size;
    final _size = value7;
    final size = dynamicSize + 66;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 66);
    writer.writeLong(offsets[0], _id);
    writer.writeBytes(offsets[1], _path);
    writer.writeDateTime(offsets[2], _changed);
    writer.writeDateTime(offsets[3], _modified);
    writer.writeDateTime(offsets[4], _accessed);
    writer.writeLong(offsets[5], _type);
    writer.writeLong(offsets[6], _mode);
    writer.writeLong(offsets[7], _size);
    return bufferSize;
  }

  @override
  EntityStat deserialize(IsarCollectionImpl<EntityStat> collection,
      BinaryReader reader, List<int> offsets) {
    final object = EntityStat();
    object.id = reader.readLongOrNull(offsets[0]);
    object.path = reader.readString(offsets[1]);
    object.changed = reader.readDateTime(offsets[2]);
    object.modified = reader.readDateTime(offsets[3]);
    object.accessed = reader.readDateTime(offsets[4]);
    object.type = _EntityStatAdapter._FileSystemEntityTypeConverter.fromIsar(
        reader.readLong(offsets[5]));
    object.mode = reader.readLong(offsets[6]);
    object.size = reader.readLong(offsets[7]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLongOrNull(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readDateTime(offset)) as P;
      case 3:
        return (reader.readDateTime(offset)) as P;
      case 4:
        return (reader.readDateTime(offset)) as P;
      case 5:
        return (_EntityStatAdapter._FileSystemEntityTypeConverter.fromIsar(
            reader.readLong(offset))) as P;
      case 6:
        return (reader.readLong(offset)) as P;
      case 7:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension GetCollection on Isar {
  IsarCollection<EntityStat> get entityStats {
    return getCollection('EntityStat');
  }
}

extension EntityStatQueryWhereSort on QueryBuilder<EntityStat, QWhere> {
  QueryBuilder<EntityStat, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension EntityStatQueryWhere on QueryBuilder<EntityStat, QWhereClause> {
  QueryBuilder<EntityStat, QAfterWhereClause> pathEqualTo(String path) {
    return addWhereClause(WhereClause(
      indexName: 'path',
      upper: [path],
      includeUpper: true,
      lower: [path],
      includeLower: true,
    ));
  }

  QueryBuilder<EntityStat, QAfterWhereClause> pathNotEqualTo(String path) {
    return addWhereClause(WhereClause(
      indexName: 'path',
      upper: [path],
      includeUpper: false,
    )).addWhereClause(WhereClause(
      indexName: 'path',
      lower: [path],
      includeLower: false,
    ));
  }
}

extension EntityStatQueryFilter on QueryBuilder<EntityStat, QFilterCondition> {
  QueryBuilder<EntityStat, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> idGreaterThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> idLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> idBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> pathEqualTo(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> pathStartsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'path',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> pathEndsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'path',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> pathContains(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'path',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> pathMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'path',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> changedEqualTo(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'changed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> changedGreaterThan(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'changed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> changedLessThan(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'changed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> changedBetween(
      DateTime lower, DateTime upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'changed',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modifiedEqualTo(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'modified',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modifiedGreaterThan(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'modified',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modifiedLessThan(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'modified',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modifiedBetween(
      DateTime lower, DateTime upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'modified',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> accessedEqualTo(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'accessed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> accessedGreaterThan(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'accessed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> accessedLessThan(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'accessed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> accessedBetween(
      DateTime lower, DateTime upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'accessed',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> typeEqualTo(
      FileSystemEntityType value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'type',
      value: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> typeGreaterThan(
      FileSystemEntityType value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'type',
      value: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> typeLessThan(
      FileSystemEntityType value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'type',
      value: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> typeBetween(
      FileSystemEntityType lower, FileSystemEntityType upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'type',
      lower: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(lower),
      upper: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(upper),
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modeEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'mode',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modeGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'mode',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modeLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'mode',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> modeBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'mode',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> sizeEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'size',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> sizeGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'size',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> sizeLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'size',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, QAfterFilterCondition> sizeBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'size',
      lower: lower,
      upper: upper,
    ));
  }
}

extension EntityStatQueryLinks on QueryBuilder<EntityStat, QFilterCondition> {}

extension EntityStatQueryWhereSortBy on QueryBuilder<EntityStat, QSortBy> {
  QueryBuilder<EntityStat, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByPath() {
    return addSortByInternal('path', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByPathDesc() {
    return addSortByInternal('path', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByChanged() {
    return addSortByInternal('changed', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByChangedDesc() {
    return addSortByInternal('changed', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByModified() {
    return addSortByInternal('modified', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByModifiedDesc() {
    return addSortByInternal('modified', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByAccessed() {
    return addSortByInternal('accessed', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByAccessedDesc() {
    return addSortByInternal('accessed', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByMode() {
    return addSortByInternal('mode', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortByModeDesc() {
    return addSortByInternal('mode', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortBySize() {
    return addSortByInternal('size', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> sortBySizeDesc() {
    return addSortByInternal('size', Sort.Desc);
  }
}

extension EntityStatQueryWhereSortThenBy
    on QueryBuilder<EntityStat, QSortThenBy> {
  QueryBuilder<EntityStat, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByPath() {
    return addSortByInternal('path', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByPathDesc() {
    return addSortByInternal('path', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByChanged() {
    return addSortByInternal('changed', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByChangedDesc() {
    return addSortByInternal('changed', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByModified() {
    return addSortByInternal('modified', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByModifiedDesc() {
    return addSortByInternal('modified', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByAccessed() {
    return addSortByInternal('accessed', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByAccessedDesc() {
    return addSortByInternal('accessed', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByMode() {
    return addSortByInternal('mode', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenByModeDesc() {
    return addSortByInternal('mode', Sort.Desc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenBySize() {
    return addSortByInternal('size', Sort.Asc);
  }

  QueryBuilder<EntityStat, QAfterSortBy> thenBySizeDesc() {
    return addSortByInternal('size', Sort.Desc);
  }
}

extension EntityStatQueryWhereDistinct on QueryBuilder<EntityStat, QDistinct> {
  QueryBuilder<EntityStat, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<EntityStat, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('path', caseSensitive: caseSensitive);
  }

  QueryBuilder<EntityStat, QDistinct> distinctByChanged() {
    return addDistinctByInternal('changed');
  }

  QueryBuilder<EntityStat, QDistinct> distinctByModified() {
    return addDistinctByInternal('modified');
  }

  QueryBuilder<EntityStat, QDistinct> distinctByAccessed() {
    return addDistinctByInternal('accessed');
  }

  QueryBuilder<EntityStat, QDistinct> distinctByType() {
    return addDistinctByInternal('type');
  }

  QueryBuilder<EntityStat, QDistinct> distinctByMode() {
    return addDistinctByInternal('mode');
  }

  QueryBuilder<EntityStat, QDistinct> distinctBySize() {
    return addDistinctByInternal('size');
  }
}

extension EntityStatQueryProperty on QueryBuilder<EntityStat, QQueryProperty> {
  QueryBuilder<int?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<String, QQueryOperations> pathProperty() {
    return addPropertyName('path');
  }

  QueryBuilder<DateTime, QQueryOperations> changedProperty() {
    return addPropertyName('changed');
  }

  QueryBuilder<DateTime, QQueryOperations> modifiedProperty() {
    return addPropertyName('modified');
  }

  QueryBuilder<DateTime, QQueryOperations> accessedProperty() {
    return addPropertyName('accessed');
  }

  QueryBuilder<FileSystemEntityType, QQueryOperations> typeProperty() {
    return addPropertyName('type');
  }

  QueryBuilder<int, QQueryOperations> modeProperty() {
    return addPropertyName('mode');
  }

  QueryBuilder<int, QQueryOperations> sizeProperty() {
    return addPropertyName('size');
  }
}
