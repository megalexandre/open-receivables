part of '../api_endpoints.dart';

class _Caixa {
  const _Caixa();

  static const String _path = '${ApiEndpoints._base}/caixa';

  String get list => _path;
}
