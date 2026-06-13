part of '../api_endpoints.dart';

class _WaterQuality {
  _WaterQuality();

  String get _path => '${ApiEndpoints._base}/water-quality';

  String get list => _path;
  String get create => _path;
  String get delete => _path;
}
