import 'package:files/backend/database/model.dart';
import 'package:files/backend/providers.dart';

class StatCacheProxy {
  final Map<String, EntityStat> _runtimeCache = {};

  StatCacheProxy();

  Future<EntityStat> get(String path) async {
    if (!_runtimeCache.containsKey(path)) {
      final stat = await helper.get(path)
        ..fetchUpdate();
      _runtimeCache[path] = stat;
      return stat;
    }

    return _runtimeCache[path]!..fetchUpdate();
  }
}
