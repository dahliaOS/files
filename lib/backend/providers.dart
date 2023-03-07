import 'dart:io';

import 'package:files/backend/database/helper.dart';
import 'package:files/backend/database/model.dart';
import 'package:files/backend/folder_provider.dart';
import 'package:files/backend/stat_cache_proxy.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ubuntu_service/ubuntu_service.dart';

String _isarPath(Directory dir) {
  final String path = p.join(dir.path, 'isar');
  if (!Directory(path).existsSync()) Directory(path).create();
  return path;
}

Future<void> initProviders() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [EntityStatSchema],
    directory: _isarPath(dir),
    inspector: false,
  );
  final folderProvider = await FolderProvider.init();

  registerServiceInstance<Isar>(isar);
  registerServiceInstance<FolderProvider>(folderProvider);
  registerService<EntityStatCacheHelper>(EntityStatCacheHelper.new);
  registerService<StatCacheProxy>(StatCacheProxy.new);
}

Isar get isar => getService<Isar>();

FolderProvider get folderProvider => getService<FolderProvider>();

EntityStatCacheHelper get helper => getService<EntityStatCacheHelper>();

StatCacheProxy get cacheProxy => getService<StatCacheProxy>();
