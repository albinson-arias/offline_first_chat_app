import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';

class ListProfileHook extends MappingHook {
  const ListProfileHook();
  @override
  Object? beforeDecode(Object? value) {
    // if values is String we assume is a Json string
    if (value is String) {
      final decoded = json.decode(value);
      return decoded;
    }
    return super.beforeDecode(value);
  }
}
