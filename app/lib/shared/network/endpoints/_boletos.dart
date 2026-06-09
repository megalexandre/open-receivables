part of '../api_endpoints.dart';

class _Boletos {
  const _Boletos();

  String get list => '${ApiEndpoints._base}/boletos';
  String get create => '${ApiEndpoints._base}/boletos';
  String byId(String id) => '${ApiEndpoints._base}/boletos/$id';
}
