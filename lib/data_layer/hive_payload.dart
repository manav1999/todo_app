import 'dart:convert';

import 'package:hive/hive.dart';

part 'hive_payload.g.dart';

@HiveType(typeId: 1)
class HivePayload {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String data;

  HivePayload({required this.id, required this.data});

  factory HivePayload.create(
      {required Map<String, dynamic> json, required String id}) {
    return HivePayload(id: id, data: jsonEncode(json));
  }
}
