part of '../api_endpoints.dart';

class _Addresses {
  const _Addresses();

  static const String _path = '${ApiEndpoints._base}/addresses';

  String get list => _path;
  String get create => _path;
  String byId(String id) => '$_path/$id';
}
