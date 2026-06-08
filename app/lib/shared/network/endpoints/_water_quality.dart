part of '../api_endpoints.dart';

class _WaterQuality {
  const _WaterQuality();

  static const String _path = '${ApiEndpoints._base}/water-quality';

  String get list => _path;
  String get create => _path;
  String get delete => _path;
}
