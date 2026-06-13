part of '../api_endpoints.dart';

class _Members {
  _Members();

  String get _path => '${ApiEndpoints._base}/members';

  String get list => _path;
  String get create => _path;
  String byId(String id) => '$_path/$id';
  String reactivate(String id) => '$_path/$id/reactivate';
}
