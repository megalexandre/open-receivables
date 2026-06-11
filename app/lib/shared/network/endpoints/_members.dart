part of '../api_endpoints.dart';

class _Members {
  const _Members();

  static const String _path = '${ApiEndpoints._base}/members';

  String get list => _path;
  String get create => _path;
  String byId(String id) => '$_path/$id';
  String reactivate(String id) => '$_path/$id/reactivate';
}
