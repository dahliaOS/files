// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

extension GetEntityStatCollection on Isar {
  IsarCollection<EntityStat> get entityStats {
    return getCollection('EntityStat');
  }
}

final EntityStatSchema = CollectionSchema(
  name: 'EntityStat',
  schema:
      '{"name":"EntityStat","properties":[{"name":"path","type":"String"},{"name":"changed","type":"Long"},{"name":"modified","type":"Long"},{"name":"accessed","type":"Long"},{"name":"type","type":"Long"},{"name":"mode","type":"Long"},{"name":"size","type":"Long"},{"name":"hasListeners","type":"Byte"}],"indexes":[{"name":"path","unique":true,"properties":[{"name":"path","type":"Hash","caseSensitive":true}]}],"links":[]}',
  adapter: const _EntityStatAdapter(),
  idName: 'id',
  propertyIds: {
    'path': 0,
    'changed': 1,
    'modified': 2,
    'accessed': 3,
    'type': 4,
    'mode': 5,
    'size': 6,
    'hasListeners': 7
  },
  indexIds: {'path': 0},
  indexTypes: {
    'path': [
      NativeIndexType.stringHash,
    ]
  },
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.id,
  version: 0,
);

class _EntityStatAdapter extends IsarTypeAdapter<EntityStat> {
  const _EntityStatAdapter();

  static const _FileSystemEntityTypeConverter = FileSystemEntityTypeConverter();

  @override
  int serialize(IsarCollection<EntityStat> collection, RawObject rawObj,
      EntityStat object, List<int> offsets,
      [int? existingBufferSize]) {
    rawObj.id = object.id ?? Isar.minId;
    var dynamicSize = 0;
    final value0 = object.path;
    final _path = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _path.length;
    final value1 = object.changed;
    final _changed = value1;
    final value2 = object.modified;
    final _modified = value2;
    final value3 = object.accessed;
    final _accessed = value3;
    final value4 =
        _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(object.type);
    final _type = value4;
    final value5 = object.mode;
    final _mode = value5;
    final value6 = object.size;
    final _size = value6;
    final value7 = object.hasListeners;
    final _hasListeners = value7;
    final size = dynamicSize + 67;

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
    final writer = BinaryWriter(buffer, 67);
    writer.writeBytes(offsets[0], _path);
    writer.writeDateTime(offsets[1], _changed);
    writer.writeDateTime(offsets[2], _modified);
    writer.writeDateTime(offsets[3], _accessed);
    writer.writeLong(offsets[4], _type);
    writer.writeLong(offsets[5], _mode);
    writer.writeLong(offsets[6], _size);
    writer.writeBool(offsets[7], _hasListeners);
    return bufferSize;
  }

  @override
  EntityStat deserialize(IsarCollection<EntityStat> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = EntityStat();
    object.id = id;
    object.path = reader.readString(offsets[0]);
    object.changed = reader.readDateTime(offsets[1]);
    object.modified = reader.readDateTime(offsets[2]);
    object.accessed = reader.readDateTime(offsets[3]);
    object.type = _EntityStatAdapter._FileSystemEntityTypeConverter.fromIsar(
        reader.readLong(offsets[4]));
    object.mode = reader.readLong(offsets[5]);
    object.size = reader.readLong(offsets[6]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readDateTime(offset)) as P;
      case 2:
        return (reader.readDateTime(offset)) as P;
      case 3:
        return (reader.readDateTime(offset)) as P;
      case 4:
        return (_EntityStatAdapter._FileSystemEntityTypeConverter.fromIsar(
            reader.readLong(offset))) as P;
      case 5:
        return (reader.readLong(offset)) as P;
      case 6:
        return (reader.readLong(offset)) as P;
      case 7:
        return (reader.readBool(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension EntityStatByIndex on IsarCollection<EntityStat> {
  Future<EntityStat?> getBypath(String path) {
    // ignore: invalid_use_of_protected_member
    return getAllByIndex('path', [
      [path]
    ]).then((e) => e[0]);
  }

  EntityStat? getBypathSync(String path) {
    // ignore: invalid_use_of_protected_member
    return getAllByIndexSync('path', [
      [path]
    ])[0];
  }

  Future<bool> deleteBypath(String path) {
    // ignore: invalid_use_of_protected_member
    return deleteAllByIndex('path', [
      [path]
    ]).then((e) => e == 1);
  }

  bool deleteBypathSync(String path) {
    // ignore: invalid_use_of_protected_member
    return getAllByIndexSync('path', [
          [path]
        ]) ==
        1;
  }

  Future<List<EntityStat?>> getAllBypath(List<List<dynamic>> values) {
    // ignore: invalid_use_of_protected_member
    return getAllByIndex('path', values);
  }

  List<EntityStat?> getAllBypathSync(List<List<dynamic>> values) {
    // ignore: invalid_use_of_protected_member
    return getAllByIndexSync('path', values);
  }

  Future<int> deleteAllBypath(List<List<dynamic>> values) {
    // ignore: invalid_use_of_protected_member
    return deleteAllByIndex('path', values);
  }

  int deleteAllBypathSync(List<List<dynamic>> values) {
    // ignore: invalid_use_of_protected_member
    return deleteAllByIndexSync('path', values);
  }
}

extension EntityStatQueryWhereSort
    on QueryBuilder<EntityStat, EntityStat, QWhere> {
  QueryBuilder<EntityStat, EntityStat, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: '_id'));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterWhere> anyPath() {
    return addWhereClause(WhereClause(indexName: 'path'));
  }
}

extension EntityStatQueryWhere
    on QueryBuilder<EntityStat, EntityStat, QWhereClause> {
  QueryBuilder<EntityStat, EntityStat, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClause(WhereClause(
      indexName: '_id',
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterWhereClause> idNotEqualTo(
      int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClause(WhereClause(
        indexName: '_id',
        upper: [id],
        includeUpper: false,
      )).addWhereClause(WhereClause(
        indexName: '_id',
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClause(WhereClause(
        indexName: '_id',
        lower: [id],
        includeLower: false,
      )).addWhereClause(WhereClause(
        indexName: '_id',
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<EntityStat, EntityStat, QAfterWhereClause> idIsNull() {
    return addWhereClause(WhereClause(
      indexName: '_id',
      upper: [null],
      includeUpper: true,
      lower: [null],
      includeLower: true,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterWhereClause> idIsNotNull() {
    return addWhereClause(WhereClause(
      indexName: '_id',
      lower: [null],
      includeLower: false,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterWhereClause> pathEqualTo(
      String path) {
    return addWhereClause(WhereClause(
      indexName: 'path',
      lower: [path],
      includeLower: true,
      upper: [path],
      includeUpper: true,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterWhereClause> pathNotEqualTo(
      String path) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClause(WhereClause(
        indexName: 'path',
        upper: [path],
        includeUpper: false,
      )).addWhereClause(WhereClause(
        indexName: 'path',
        lower: [path],
        includeLower: false,
      ));
    } else {
      return addWhereClause(WhereClause(
        indexName: 'path',
        lower: [path],
        includeLower: false,
      )).addWhereClause(WhereClause(
        indexName: 'path',
        upper: [path],
        includeUpper: false,
      ));
    }
  }
}

extension EntityStatQueryFilter
    on QueryBuilder<EntityStat, EntityStat, QFilterCondition> {
  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> idEqualTo(
    int? value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> idGreaterThan(
    int? value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> idLessThan(
    int? value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'path',
      lower: lower,
      upper: upper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathStartsWith(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathEndsWith(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'path',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'path',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> changedEqualTo(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'changed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition>
      changedGreaterThan(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'changed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> changedLessThan(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'changed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> changedBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'changed',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modifiedEqualTo(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'modified',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition>
      modifiedGreaterThan(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'modified',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modifiedLessThan(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'modified',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modifiedBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'modified',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> accessedEqualTo(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'accessed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition>
      accessedGreaterThan(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'accessed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> accessedLessThan(
    DateTime value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'accessed',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> accessedBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'accessed',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> typeEqualTo(
    FileSystemEntityType value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> typeGreaterThan(
    FileSystemEntityType value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'type',
      value: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> typeLessThan(
    FileSystemEntityType value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'type',
      value: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> typeBetween(
    FileSystemEntityType lower,
    FileSystemEntityType upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'type',
      lower: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(lower),
      upper: _EntityStatAdapter._FileSystemEntityTypeConverter.toIsar(upper),
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modeEqualTo(
    int value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'mode',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modeGreaterThan(
    int value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'mode',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modeLessThan(
    int value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'mode',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> modeBetween(
    int lower,
    int upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'mode',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> sizeEqualTo(
    int value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'size',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> sizeGreaterThan(
    int value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      property: 'size',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> sizeLessThan(
    int value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      property: 'size',
      value: value,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition> sizeBetween(
    int lower,
    int upper,
  ) {
    return addFilterCondition(FilterCondition.between(
      property: 'size',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<EntityStat, EntityStat, QAfterFilterCondition>
      hasListenersEqualTo(
    bool value,
  ) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'hasListeners',
      value: value,
    ));
  }
}

extension EntityStatQueryWhereSortBy
    on QueryBuilder<EntityStat, EntityStat, QSortBy> {
  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByPath() {
    return addSortByInternal('path', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByPathDesc() {
    return addSortByInternal('path', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByChanged() {
    return addSortByInternal('changed', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByChangedDesc() {
    return addSortByInternal('changed', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByModified() {
    return addSortByInternal('modified', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByModifiedDesc() {
    return addSortByInternal('modified', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByAccessed() {
    return addSortByInternal('accessed', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByAccessedDesc() {
    return addSortByInternal('accessed', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByMode() {
    return addSortByInternal('mode', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByModeDesc() {
    return addSortByInternal('mode', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortBySize() {
    return addSortByInternal('size', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortBySizeDesc() {
    return addSortByInternal('size', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByHasListeners() {
    return addSortByInternal('hasListeners', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> sortByHasListenersDesc() {
    return addSortByInternal('hasListeners', Sort.desc);
  }
}

extension EntityStatQueryWhereSortThenBy
    on QueryBuilder<EntityStat, EntityStat, QSortThenBy> {
  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByPath() {
    return addSortByInternal('path', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByPathDesc() {
    return addSortByInternal('path', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByChanged() {
    return addSortByInternal('changed', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByChangedDesc() {
    return addSortByInternal('changed', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByModified() {
    return addSortByInternal('modified', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByModifiedDesc() {
    return addSortByInternal('modified', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByAccessed() {
    return addSortByInternal('accessed', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByAccessedDesc() {
    return addSortByInternal('accessed', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByMode() {
    return addSortByInternal('mode', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByModeDesc() {
    return addSortByInternal('mode', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenBySize() {
    return addSortByInternal('size', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenBySizeDesc() {
    return addSortByInternal('size', Sort.desc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByHasListeners() {
    return addSortByInternal('hasListeners', Sort.asc);
  }

  QueryBuilder<EntityStat, EntityStat, QAfterSortBy> thenByHasListenersDesc() {
    return addSortByInternal('hasListeners', Sort.desc);
  }
}

extension EntityStatQueryWhereDistinct
    on QueryBuilder<EntityStat, EntityStat, QDistinct> {
  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('path', caseSensitive: caseSensitive);
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByChanged() {
    return addDistinctByInternal('changed');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByModified() {
    return addDistinctByInternal('modified');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByAccessed() {
    return addDistinctByInternal('accessed');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByType() {
    return addDistinctByInternal('type');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByMode() {
    return addDistinctByInternal('mode');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctBySize() {
    return addDistinctByInternal('size');
  }

  QueryBuilder<EntityStat, EntityStat, QDistinct> distinctByHasListeners() {
    return addDistinctByInternal('hasListeners');
  }
}

extension EntityStatQueryProperty
    on QueryBuilder<EntityStat, EntityStat, QQueryProperty> {
  QueryBuilder<EntityStat, int?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<EntityStat, String, QQueryOperations> pathProperty() {
    return addPropertyName('path');
  }

  QueryBuilder<EntityStat, DateTime, QQueryOperations> changedProperty() {
    return addPropertyName('changed');
  }

  QueryBuilder<EntityStat, DateTime, QQueryOperations> modifiedProperty() {
    return addPropertyName('modified');
  }

  QueryBuilder<EntityStat, DateTime, QQueryOperations> accessedProperty() {
    return addPropertyName('accessed');
  }

  QueryBuilder<EntityStat, FileSystemEntityType, QQueryOperations>
      typeProperty() {
    return addPropertyName('type');
  }

  QueryBuilder<EntityStat, int, QQueryOperations> modeProperty() {
    return addPropertyName('mode');
  }

  QueryBuilder<EntityStat, int, QQueryOperations> sizeProperty() {
    return addPropertyName('size');
  }

  QueryBuilder<EntityStat, bool, QQueryOperations> hasListenersProperty() {
    return addPropertyName('hasListeners');
  }
}
