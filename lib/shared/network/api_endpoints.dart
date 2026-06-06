part 'endpoints/_auth.dart';
part 'endpoints/_categories.dart';
part 'endpoints/_members.dart';
part 'endpoints/_addresses.dart';
part 'endpoints/_boletos.dart';

class ApiEndpoints {
  static const _base = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const auth = _Auth();
  static const categories = _Categories();
  static const members = _Members();
  static const addresses = _Addresses();
  static const boletos = _Boletos();
}
