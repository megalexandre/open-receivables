import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';

typedef ErrorParams = Map<String, String?>;

enum ApiErrorCode {
  categoryNameDuplicated('E_CATEGORY_DUPLICATED', _categoryNameDuplicated),
  categoryMemberTypeRequired('E_CATEGORY_REQUIRED', _categoryMemberTypeRequired),
  categoryMemberTypeInvalid('E_CATEGORY_INVALID', _categoryMemberTypeInvalid),
  memberDocumentDuplicated('E_MEMBER_DUPLICATED', _memberDocumentDuplicated),
  addressDuplicated('E_ADDRESS_DUPLICATED', _addressDuplicated),
  waterAnalysisDuplicated('E_WATER_ANALYSIS_DUPLICATED', _waterAnalysisDuplicated),
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

  static ErrorParams paramsFromMember(Member m) => {'document': m.document};

  static ErrorParams paramsFromAddress(Address a) => {
    'address_type': a.addressType,
    'name': a.name,
  };

  static ErrorParams paramsFromWaterBatch(WaterAnalysisBatch b) => {
    'reference': '${b.month.toString().padLeft(2, '0')}/${b.year}',
  };
}

String _categoryNameDuplicated(ErrorParams p) =>
    'O nome "${p['name']}" já está associado ao tipo "${p['member_type']}"';

String _categoryMemberTypeRequired(ErrorParams _) =>
    'O tipo de sócio é obrigatório';

String _categoryMemberTypeInvalid(ErrorParams _) => 'Tipo de sócio inválido';

String _memberDocumentDuplicated(ErrorParams p) =>
    'O documento "${p['document']}" já está cadastrado';

String _addressDuplicated(ErrorParams p) =>
    'O logradouro "${p['address_type']} ${p['name']}" já está cadastrado';

String _waterAnalysisDuplicated(ErrorParams p) =>
    'Já existe uma análise de água cadastrada para a referência ${p['reference']}';

String _unknownMessage(ErrorParams _) => 'Erro desconhecido';
