import 'package:organizagrana/shared/config/runtime_config.dart';

part 'endpoints/_auth.dart';
part 'endpoints/_categories.dart';
part 'endpoints/_members.dart';
part 'endpoints/_addresses.dart';
part 'endpoints/_boletos.dart';
part 'endpoints/_connections.dart';
part 'endpoints/_water_quality.dart';
part 'endpoints/_caixa.dart';
part 'endpoints/_generate_invoices.dart';


class ApiEndpoints {
  static String get _base => RuntimeConfig.apiBaseUrl;

  static final auth = _Auth();
  static final categories = _Categories();
  static final members = _Members();
  static final addresses = _Addresses();
  static final boletos = _Boletos();
  static final connections = _Connections();
  static final waterQuality = _WaterQuality();
  static final caixa = _Caixa();
  static final generateInvoices = _GenerateInvoices();
}
