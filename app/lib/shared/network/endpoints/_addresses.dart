part of '../api_endpoints.dart';

class _Addresses {
  _Addresses();

  String get _path => '${ApiEndpoints._base}/addresses';

  String get list => _path;
  String get create => _path;
  String byId(String id) => '$_path/$id';
  String reactivate(String id) => '$_path/$id/reactivate';
}
