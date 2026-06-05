part 'endpoints/_auth.dart';
part 'endpoints/_categories.dart';

class ApiEndpoints {
  static const _base = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const auth = _Auth();
  static const categories = _Categories();
}
