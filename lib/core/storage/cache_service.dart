import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cacheServiceProvider = Provider((ref) => CacheService());

class CacheService {
  static const String boxName = 'api_cache';

  Future<void> set(String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, jsonEncode(value));
  }

  Future<dynamic> get(String key) async {
    final box = await Hive.openBox(boxName);
    final value = box.get(key);
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  Future<void> clear() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
}
