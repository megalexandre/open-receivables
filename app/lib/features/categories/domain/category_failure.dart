import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart' show AppFailureType;

class CategoryFailure extends AppFailure {
  const CategoryFailure(super.type);

  @override
  String get message => type == AppFailureType.notFound
      ? 'Categoria não encontrada.'
      : super.message;
}
