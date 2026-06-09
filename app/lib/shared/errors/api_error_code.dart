import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/members/domain/member.dart';

typedef ErrorParams = Map<String, String?>;

enum ApiErrorCode {
  categoryNameDuplicated('E_1_1', _categoryNameDuplicated),
  categoryMemberTypeRequired('E_1_2', _categoryMemberTypeRequired),
  categoryMemberTypeInvalid('E_1_3', _categoryMemberTypeInvalid),
  memberDocumentDuplicated('E_2_1', _memberDocumentDuplicated),
  unknown('', _unknownMessage);

  const ApiErrorCode(this.code, this._messageFn);

  final String code;
  final String Function(ErrorParams) _messageFn;

  String messageFor(ErrorParams params) => _messageFn(params);

  static ApiErrorCode fromCode(String code) =>
      values.firstWhere((e) => e.code == code, orElse: () => unknown);

  static ErrorParams paramsFromCategory(Category c) => {
        'name': c.name,
        'member_type': c.memberType,
      };

  static ErrorParams paramsFromMember(Member m) => {
        'document': m.document,
      };
}

String _categoryNameDuplicated(ErrorParams p) =>
    'O nome "${p['name']}" já está associado ao tipo "${p['member_type']}"';

String _categoryMemberTypeRequired(ErrorParams _) => 'O tipo de sócio é obrigatório';

String _categoryMemberTypeInvalid(ErrorParams _) => 'Tipo de sócio inválido';

String _memberDocumentDuplicated(ErrorParams p) =>
    'O documento "${p['document']}" já está cadastrado';

String _unknownMessage(ErrorParams _) => 'Erro desconhecido';
