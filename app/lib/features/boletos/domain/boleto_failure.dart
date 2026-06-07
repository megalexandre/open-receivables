import 'package:organizagrana/shared/errors/app_failure.dart';

class BoletoFailure extends AppFailure {
  const BoletoFailure(super.type);

  @override
  String get message => type == AppFailureType.notFound
      ? 'Boleto não encontrado.'
      : super.message;
}
