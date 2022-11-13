import 'package:files/backend/database/helper.dart';
import 'package:files/backend/database/model.dart';
import 'package:files/backend/folder_provider.dart';
import 'package:files/backend/stat_cache_proxy.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  bool _inited = false;

  late Isar? _isar;
  late FolderProvider? _folderProvider;
  late EntityStatCacheHelper? _helper;
  late StatCacheProxy? _cacheProxy;

  Isar get isar {
    _checkForAvailability();
    return _isar!;
  }

  FolderProvider get folderProvider {
    _checkForAvailability();
    return _folderProvider!;
  }

  EntityStatCacheHelper get helper {
    _checkForAvailability();
    return _helper!;
  }

  StatCacheProxy get cacheProxy {
    _checkForAvailability();
    return _cacheProxy!;
  }

  void _checkForAvailability() {
    if (!_inited) throw Exception("Providers not inited or disposed");
  }

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  Future<void> _init() async {
    if (_inited) return;
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [EntityStatSchema],
      directory: p.join(dir.path, 'isar'),
    );
    _folderProvider = await FolderProvider.init();
    _helper = EntityStatCacheHelper();
    _cacheProxy = StatCacheProxy();
    _inited = true;
  }

  Future<void> _dispose() async {
    await isar.close();
    _folderProvider = null;
    _helper = null;
    _cacheProxy = null;
    _inited = false;
  }
}

Future<void> initProviders() async => _ProvidersSingleton.instance._init();

Future<void> disposeProviders() async =>
    _ProvidersSingleton.instance._dispose();

Isar get isar => _ProvidersSingleton.instance.isar;

FolderProvider get folderProvider =>
    _ProvidersSingleton.instance.folderProvider;

EntityStatCacheHelper get helper => _ProvidersSingleton.instance.helper;

StatCacheProxy get cacheProxy => _ProvidersSingleton.instance.cacheProxy;
