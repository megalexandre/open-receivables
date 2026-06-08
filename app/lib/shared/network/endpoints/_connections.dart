part of '../api_endpoints.dart';

class _Connections {
  const _Connections();

  static const String _path = '${ApiEndpoints._base}/connections';

  String get list => _path;
  String get create => _path;
  String get summary => '$_path/summary';
  String byId(String id) => '$_path/$id';
}
