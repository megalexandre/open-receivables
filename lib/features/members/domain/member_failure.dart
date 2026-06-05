import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart' show AppFailureType;

class MemberFailure extends AppFailure {
  const MemberFailure(super.type);

  @override
  String get message => type == AppFailureType.notFound
      ? 'Sócio não encontrado.'
      : super.message;
}
