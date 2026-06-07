import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/widgets/form/subcategory_dropdown.dart';

typedef ErrorParams = Map<String, String?>;

enum ApiErrorCode {
  categoryNameDuplicated('E_1_1', _categoryNameDuplicated),
  categoryGroupRequired('E_1_2', _categoryGroupRequired),
  categoryGroupInvalid('E_1_3', _categoryGroupInvalid),
  unknown('', _unknownMessage);

  const ApiErrorCode(this.code, this._messageFn);

  final String code;
  final String Function(ErrorParams) _messageFn;

  String message([ErrorParams params = const {}]) => _messageFn(params);

  static ApiErrorCode fromCode(String code) =>
      values.firstWhere((e) => e.code == code, orElse: () => unknown);

  static ErrorParams paramsFromCategory(Category c) => {
        'name': c.name,
        'group': SubcategoryDropdown.items[c.groupId],
      };
}

String _categoryNameDuplicated(ErrorParams p) =>
    'O nome "${p['name']}" já está associado para o subgrupo "${p['group']}"';

String _categoryGroupRequired(ErrorParams _) => 'O subgrupo é obrigatório';

String _categoryGroupInvalid(ErrorParams _) => 'Subgrupo inválido';

String _unknownMessage(ErrorParams _) => 'Erro desconhecido';
