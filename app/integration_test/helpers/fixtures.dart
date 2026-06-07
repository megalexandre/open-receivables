import 'dart:convert';

// Gera um JWT válido para pré-popular o storage no pumpAuthenticated.
String fakeJwt([String email = 'test@example.com']) {
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final exp = now + 365 * 24 * 3600;
  final header = base64Url
      .encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(
        utf8.encode('{"sub":"user-1","email":"$email","iat":$now,"exp":$exp}'),
      )
      .replaceAll('=', '');
  return '$header.$payload.fakesig';
}
