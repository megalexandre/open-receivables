part of '../api_endpoints.dart';

class _Auth {
  _Auth();

  String get _path => '${ApiEndpoints._base}/auth';
  String get login => '$_path/login';
  String get refresh => '$_path/refresh';
  String get me => '${ApiEndpoints._base}/users/me';
}
