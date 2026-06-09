import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart' show AppFailureType;

class WaterQualityFailure extends AppFailure {
  const WaterQualityFailure(super.type);

  @override
  String get message => type == AppFailureType.notFound
      ? 'Análise não encontrada.'
      : super.message;
}
