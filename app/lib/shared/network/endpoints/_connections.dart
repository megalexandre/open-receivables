part of '../api_endpoints.dart';

class _Connections {
  _Connections();

  String get _path => '${ApiEndpoints._base}/connections';

  String get list => _path;
  String get create => _path;
  String byId(String id) => '$_path/$id';
}
