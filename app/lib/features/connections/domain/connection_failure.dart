import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart' show AppFailureType;

class ConnectionFailure extends AppFailure {
  const ConnectionFailure(super.type);

  @override
  String get message => type == AppFailureType.notFound
      ? 'Ligação não encontrada.'
      : super.message;
}
