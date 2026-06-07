import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart' show AppFailureType;

class AddressFailure extends AppFailure {
  const AddressFailure(super.type);

  @override
  String get message => type == AppFailureType.notFound
      ? 'Endereço não encontrado.'
      : super.message;
}
